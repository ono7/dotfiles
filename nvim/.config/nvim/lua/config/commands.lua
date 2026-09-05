local opts = { silent = true }
local term_size = 18

-- Helper to get non-floating windows in the current tabpage
local function get_normal_wins()
  return vim.tbl_filter(function(win)
    return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))
end

-- 👇 ADD THIS AUTOCMD TO FORCE THE STATUSLINE TO HIDE 👇
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.b.lualine_disable = true
      vim.opt_local.statusline = "%#Normal# "
    end
  end,
})

---------------------------------------------------------------------------
-- TAB-LOCAL STATE MANAGEMENT
---------------------------------------------------------------------------
local tab_state = {}

local function get_tab_state()
  local tab = vim.api.nvim_get_current_tabpage()
  if not tab_state[tab] then
    tab_state[tab] = {
      buf = nil,
      win = nil,
      job = nil,
      last_win = nil,
      last_cursor = nil,
      height = term_size,
    }
  end
  return tab_state[tab]
end

-- Cleanup orphaned terminal buffers when a tab is closed
vim.api.nvim_create_autocmd("TabClosed", {
  group = vim.api.nvim_create_augroup("TabTerminalCleanup", { clear = true }),
  callback = function()
    local valid_tabs = vim.api.nvim_list_tabpages()
    local valid_set = {}
    for _, t in ipairs(valid_tabs) do
      valid_set[t] = true
    end

    for tab_id, state in pairs(tab_state) do
      if not valid_set[tab_id] then
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        tab_state[tab_id] = nil
      end
    end
  end,
})

local function close_quickfix()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.win_gettype(win) == "quickfix" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

---------------------------------------------------------------------------
-- TRANSIENT WINDOW MANAGEMENT (Terminal, Fugitive, Oil, Quickfix)
---------------------------------------------------------------------------
local function hide_transients()
  local state = get_tab_state()
  local closed_terminal = false

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      local wt = vim.fn.win_gettype(win)

      if bt == "terminal" or wt == "quickfix" or ft == "fugitive" or ft == "oil" then
        if #get_normal_wins() > 1 then
          if bt == "terminal" then
            state.height = vim.api.nvim_win_get_height(win)
            closed_terminal = true
          end
          pcall(vim.api.nvim_win_hide, win)
        end
      end
    end
  end

  if closed_terminal and state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
    vim.api.nvim_set_current_win(state.last_win)
  end
end

vim.keymap.set("n", "<C-/>", hide_transients, opts)
vim.keymap.set("n", "<C-_>", hide_transients, opts)
vim.keymap.set("t", "<C-/>", function()
  hide_transients()
  vim.cmd("stopinsert")
end, opts)
vim.keymap.set("t", "<C-_>", function()
  hide_transients()
  vim.cmd("stopinsert")
end, opts)

---------------------------------------------------------------------------
-- TERMINAL COMMAND
---------------------------------------------------------------------------
vim.api.nvim_create_user_command("T", function(opts_args)
  local cmd = opts_args.args
  local state = get_tab_state()

  close_quickfix()

  local function save_editor_pos()
    state.last_win = vim.api.nvim_get_current_win()
    state.last_cursor = vim.api.nvim_win_get_cursor(0)
  end

  local function restore_editor_pos()
    if state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
      vim.api.nvim_set_current_win(state.last_win)
      if state.last_cursor then
        pcall(vim.api.nvim_win_set_cursor, state.last_win, state.last_cursor)
      end
    end
  end

  ---------------------------------------------------------------------------
  -- CREATE NEW TERMINAL
  ---------------------------------------------------------------------------
  if state.buf == nil or not vim.api.nvim_buf_is_valid(state.buf) then
    save_editor_pos()
    vim.opt_local.winbar = nil

    vim.cmd("botright split")
    vim.wo.winfixheight = true
    vim.cmd("resize " .. state.height)

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()

    vim.cmd.term()

    state.buf = vim.api.nvim_get_current_buf()
    state.win = vim.api.nvim_get_current_win()
    state.job = vim.b.terminal_job_id

    vim.wo.statusline = "%#Normal# "
    vim.b[state.buf].lualine_disable = true

    vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
    if cmd ~= "" then
      vim.fn.chansend(state.job, cmd .. "\n")
    end

    vim.cmd("startinsert")
    return
  end

  ---------------------------------------------------------------------------
  -- TERMINAL EXISTS → TOGGLE
  ---------------------------------------------------------------------------
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.buf then
      state.height = vim.api.nvim_win_get_height(win)

      if #get_normal_wins() > 1 then
        pcall(vim.api.nvim_win_hide, win)
      else
        vim.cmd("enew")
      end

      restore_editor_pos()
      vim.cmd("echo ''")
      return
    end
  end

  ---------------------------------------------------------------------------
  -- SHOW EXISTING TERMINAL
  ---------------------------------------------------------------------------
  save_editor_pos()

  vim.cmd("botright split")
  vim.wo.winfixheight = true
  vim.cmd("resize " .. state.height)

  vim.api.nvim_win_set_buf(0, state.buf)
  state.win = vim.api.nvim_get_current_win()

  vim.wo.statusline = "%#Normal# "

  if cmd ~= "" then
    vim.fn.chansend(state.job, cmd .. "\n")
  end

  vim.cmd("startinsert")
end, { nargs = "*" })

vim.keymap.set("n", "<C-t>", "<cmd>T<CR>", opts)

---Call `:GitOpen dev` to open the file on the `dev` branch
vim.api.nvim_create_user_command("GitOpen", function(opts_args)
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file = vim.fn.expand("%:p"):gsub(vim.pesc(git_root .. "/"), "")
  local line = vim.fn.line(".")

  local repo_url = vim.fn.system("git -C " .. git_root .. " config --get remote.origin.url")
  ---@type string | nil
  local forced_branch = #opts_args.args > 0 and opts_args.args or nil
  local branch = forced_branch or vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local commit_hash = vim.fn.system("git rev-parse HEAD"):gsub("\n", "")
  local git_ref = branch == "HEAD" and commit_hash or branch

  local ssh_url_captures = { string.find(repo_url, ".*@(.*)[:/]([^/]*)/([^%s/]*)") }
  local _, _, host, user, repo = unpack(ssh_url_captures)
  repo = repo:gsub(".git$", "")

  local github_repo_url = string.format("https://%s/%s/%s", vim.uri_encode(host), vim.uri_encode(user), vim.uri_encode(repo))
  local github_file_url = string.format("%s/blob/%s/%s#L%s", vim.uri_encode(github_repo_url), vim.uri_encode(git_ref), vim.uri_encode(file), line)
  vim.fn.system("open " .. github_file_url)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Cd", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local start_dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

  local git_marker = vim.fs.find(".git", { path = start_dir, upward = true })[1]

  if git_marker then
    local root = vim.fs.dirname(git_marker)
    vim.cmd.lcd(root)
  else
    print("not a git repo")
  end
end, {})

-- finds files faster than built in find command
-- vim.api.nvim_create_user_command("F", function(opts)
--   vim.cmd.edit(vim.fn.fnameescape(opts.args))
-- end, {
--   nargs = 1,
--   complete = function(lead)
--     local cmd = string.format("fd --type f --hidden --exclude .git %s", vim.fn.shellescape(lead))
--     return vim.fn.systemlist(cmd)
--   end,
--   desc = "Fast find including dotfiles",
-- })

--- same as above but supports regex

-- Directory + File regex:
-- :F config.*init<Tab>

-- Alternation / OR:
-- :F (init|options)\.lua$<Tab>

-- End-of-line anchors:
-- :F zshrc$<Tab>

-- Character classes / Wildcards:
-- :F \.config/.*[0-9]<Tab>
vim.api.nvim_create_user_command("F", function(opts)
  vim.cmd.edit(vim.fn.fnameescape(opts.args))
end, {
  nargs = 1,
  complete = function(lead)
    local pattern = lead ~= "" and lead or ".*"

    -- -p: regex matches against entire relative path, not just basename
    -- --max-results: caps results to prevent wildmenu lag on broad patterns
    local cmd = string.format("fd --type f --hidden --exclude .git -p --max-results 50 %s", vim.fn.shellescape(pattern))
    return vim.fn.systemlist(cmd)
  end,
  desc = "Fast regex find including dotfiles",
})

-- same as above but opens matches in tabs
vim.api.nvim_create_user_command("FT", function(opts)
  local pattern = opts.args ~= "" and opts.args or ".*"
  local cmd = string.format("fd --type f --hidden --exclude .git -p %s", vim.fn.shellescape(pattern))
  local files = vim.fn.systemlist(cmd)

  if #files == 0 then
    vim.notify("No files matched: " .. pattern, vim.log.levels.WARN)
    return
  end

  -- Guard against crashing/freezing Neovim if the regex matches hundreds of files
  local max_tabs = vim.o.tabpagemax -- Defaults to 50
  if #files > max_tabs then
    local confirm = vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
    if confirm ~= 1 then
      return
    end
  end

  for i, file in ipairs(files) do
    if i > max_tabs then
      break
    end

    -- If Tab 1 is currently an empty, unmodified scratch buffer, reuse it for file #1
    local is_empty_buffer = i == 1 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

    if is_empty_buffer then
      vim.cmd.edit(vim.fn.fnameescape(file))
    else
      vim.cmd.tabedit(vim.fn.fnameescape(file))
    end
  end
end, {
  nargs = 1,
  complete = function(lead)
    local pattern = lead ~= "" and lead or ".*"
    local cmd = string.format("fd --type f --hidden --exclude .git -p --max-results 50 %s", vim.fn.shellescape(pattern))
    return vim.fn.systemlist(cmd)
  end,
  desc = "Open all regex matches in separate tabs",
})

vim.api.nvim_create_user_command("Da", function(opts)
  local arg = vim.trim(opts.args)
  local patterns = arg ~= "" and vim.split(arg, "|", { trimempty = true }) or {}

  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  local targets = {}
  for _, buf in ipairs(bufs) do
    if #patterns == 0 then
      table.insert(targets, buf)
    else
      local full_path = vim.api.nvim_buf_get_name(buf)
      local rel_path = full_path ~= "" and vim.fn.fnamemodify(full_path, ":.") or ""
      local buf_name = vim.fn.bufname(buf)

      local function test_match(str, pat)
        if not str or str == "" then
          return false
        end
        local ok, match = pcall(string.find, str, pat)
        if ok and match ~= nil then
          return true
        end
        return str:lower():find(pat:lower(), 1, true) ~= nil
      end

      -- OR match: true if ANY sub-pattern matches
      local matched = false
      for _, pat in ipairs(patterns) do
        local trimmed_pat = vim.trim(pat)
        if test_match(rel_path, trimmed_pat) or test_match(buf_name, trimmed_pat) or test_match(full_path, trimmed_pat) then
          matched = true
          break
        end
      end

      if matched then
        table.insert(targets, buf)
      end
    end
  end

  if #targets == 0 then
    vim.notify("No buffers matched" .. (arg ~= "" and (": " .. arg) or ""), vim.log.levels.WARN)
    return
  end

  local closed = 0
  local skipped_modified = 0

  for _, buf in ipairs(targets) do
    if not opts.bang and vim.bo[buf].modified then
      skipped_modified = skipped_modified + 1
    else
      local ok = pcall(vim.api.nvim_buf_delete, buf, { force = opts.bang })
      if ok then
        closed = closed + 1
      end
    end
  end

  if skipped_modified > 0 then
    vim.notify(string.format("Closed %d buffer(s). Skipped %d modified buffer(s) (use :D! to force).", closed, skipped_modified), vim.log.levels.WARN)
  else
    vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
  end
end, {
  bang = true,
  nargs = "?",
  complete = function(lead)
    -- Preserve prefix before the last pipe for multi-pattern completion
    local prefix, current_lead = lead:match("^(.*|)(.*)$")
    prefix = prefix or ""
    current_lead = current_lead or lead

    local bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())

    local candidates = {}
    for _, buf in ipairs(bufs) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel = vim.fn.fnamemodify(name, ":.")
        if current_lead == "" or rel:find(current_lead, 1, true) then
          table.insert(candidates, prefix .. rel)
        end
      end
    end
    return candidates
  end,
  desc = "Close buffers matching pattern(s) separated by '|', or all if empty",
})
