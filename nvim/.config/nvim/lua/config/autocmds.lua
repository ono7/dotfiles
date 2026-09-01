local create_augroup = vim.api.nvim_create_augroup
local general_group = create_augroup("GeneralAutocmds", { clear = true })

local opts = { silent = true }
local term_size = 8

---------------------------------------------------------------------------
-- TAB-LOCAL STATE MANAGEMENT
---------------------------------------------------------------------------
-- Maps tabpage_handle -> { buf, win, job, last_win, last_cursor }
local tab_state = {}

local function get_tab_state()
  local tab = vim.api.nvim_get_current_tabpage()
  if not tab_state[tab] then
    tab_state[tab] = { buf = nil, win = nil, job = nil, last_win = nil, last_cursor = nil }
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
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.fn.win_gettype(win) == "quickfix" then
      vim.api.nvim_win_close(win, true)
    end
  end
end

---------------------------------------------------------------------------
-- TRANSIENT WINDOW MANAGEMENT (Terminal, Fugitive, Oil, Quickfix)
---------------------------------------------------------------------------
local function hide_transients()
  local state = get_tab_state()
  local closed_terminal = false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      local wt = vim.fn.win_gettype(win)

      if bt == "terminal" or wt == "quickfix" or ft == "fugitive" or ft == "oil" then
        if #vim.api.nvim_list_wins() > 1 then
          vim.api.nvim_win_hide(win)
          if bt == "terminal" then
            closed_terminal = true
          end
        end
      end
    end
  end

  -- Drop focus back to editor if terminal was the active window being closed
  if closed_terminal and state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
    vim.api.nvim_set_current_win(state.last_win)
  end
end

-- Terminals often send <C-_> for <C-/>, binding both ensures compatibility
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
  if vim.fn.getcmdwintype() ~= "" then
    return
  end
  local cmd = opts_args.args
  local state = get_tab_state()

  -- Hoisted: Close quickfix before evaluating any terminal state
  close_quickfix()

  -- Save editor window + cursor
  local function save_editor_pos()
    state.last_win = vim.api.nvim_get_current_win()
    state.last_cursor = vim.api.nvim_win_get_cursor(0)
  end

  -- Restore previous editor window + cursor
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

    -- Create bottom terminal without shifting current window
    vim.cmd("botright " .. term_size .. "split")

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()

    vim.cmd.term()

    state.buf = vim.api.nvim_get_current_buf()
    state.win = vim.api.nvim_get_current_win()
    state.job = vim.b.terminal_job_id

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
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == state.buf then
      -- HIDE terminal
      if #wins > 1 then
        vim.api.nvim_win_hide(win)
      else
        -- If it's the last window, replace it with a new empty buffer
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

  vim.cmd("botright " .. term_size .. "split")
  vim.api.nvim_win_set_buf(0, state.buf)
  state.win = vim.api.nvim_get_current_win()

  if cmd ~= "" then
    vim.fn.chansend(state.job, cmd .. "\n")
  end

  vim.cmd("startinsert")
end, { nargs = "*" })

vim.keymap.set("n", "<C-t>", "<cmd>T<CR>", opts)

---Call `:GitOpen dev` to open the file on the `dev` branch
vim.api.nvim_create_user_command("GitOpen", function(opts_args)
  -- Current file
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file = vim.fn.expand("%:p"):gsub(vim.pesc(git_root .. "/"), "")
  local line = vim.fn.line(".")

  -- Git repo things
  local repo_url = vim.fn.system("git -C " .. git_root .. " config --get remote.origin.url")
  ---@type string | nil
  local forced_branch = #opts_args.args > 0 and opts_args.args or nil
  local branch = forced_branch or vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local commit_hash = vim.fn.system("git rev-parse HEAD"):gsub("\n", "")
  local git_ref = branch == "HEAD" and commit_hash or branch

  -- Parse GitHub URL parts
  local ssh_url_captures = { string.find(repo_url, ".*@(.*)[:/]([^/]*)/([^%s/]*)") }
  local _, _, host, user, repo = unpack(ssh_url_captures)
  repo = repo:gsub(".git$", "")

  local github_repo_url = string.format("https://%s/%s/%s", vim.uri_encode(host), vim.uri_encode(user), vim.uri_encode(repo))
  local github_file_url = string.format("%s/blob/%s/%s#L%s", vim.uri_encode(github_repo_url), vim.uri_encode(git_ref), vim.uri_encode(file), line)
  vim.fn.system("open " .. github_file_url)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Cd", function()
  -- Start searching from the current buffer's directory, or CWD if the buffer is empty
  local buf_name = vim.api.nvim_buf_get_name(0)
  local start_dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

  -- Find .git upwards (works for directories and worktree files)
  local git_marker = vim.fs.find(".git", { path = start_dir, upward = true })[1]

  if git_marker then
    -- git_marker is the path to .git; the parent is the repo root
    local root = vim.fs.dirname(git_marker)
    vim.cmd.lcd(root)
  else
    print("not a git repo")
  end
end, {})

--- Manual LSP File Change Notification ---
--- this fill notify the lsp when we make a change to a file, this will make the changes immediate
--- and allow the lsp to know about new files or changes to a file
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("LspManualNotify", { clear = true }),
  callback = function(args)
    -- Get active LSP clients for the current buffer
    local clients = vim.lsp.get_clients({ bufnr = args.buf })

    for _, client in ipairs(clients) do
      client:notify("workspace/didChangeWatchedFiles", {
        changes = {
          {
            uri = vim.uri_from_bufnr(args.buf),
            type = 2, -- LSP Protocol: 1 = Created, 2 = Changed, 3 = Deleted
          },
        },
      })
    end
  end,
})

--- exit term after closing, prevents exit prompt from blocking until cleared
vim.api.nvim_create_autocmd("TermClose", {
  group = general_group,
  desc = "Close terminal buffer on process exit",
  callback = function(args)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = general_group,
  callback = function(args)
    -- We want to PROCEED if it's NOT a large file
    if vim.b[args.buf].large_file == true then
      return
    end

    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "pyright" then
      return
    end

    local venv = vim.env.VIRTUAL_ENV
    if venv and venv ~= "" then
      client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
        python = {
          analysis = {
            venvPath = vim.fn.fnamemodify(venv, ":h"),
            venv = vim.fn.fnamemodify(venv, ":t"),
          },
        },
      })
    end
  end,
})

-- Fallback omni for non-LSP buffers
vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  callback = function(args)
    -- Use vim.lsp.get_clients instead of get_active_clients (deprecated)
    if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
      return
    end

    if vim.bo[args.buf].omnifunc == "" then
      vim.bo[args.buf].omnifunc = "syntaxcomplete#Complete"
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup("highlight_yanked_text", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 100 })
  end,
})

-- Combined FileType overrides
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("ft_overrides", { clear = true }),
  pattern = { "javascript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- fix commit msg, goto top of file on enter
vim.api.nvim_create_autocmd("BufEnter", {
  group = create_augroup("vim_commit_msg", { clear = true }),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = create_augroup("vim_resize_windows", { clear = true }),
  command = "wincmd =",
})

-- restore cursor position on enter
vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_augroup("restore_cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = "[^l]*",
  callback = function()
    vim.cmd("cwindow")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = create_augroup("reload_snippets", { clear = true }),
  pattern = "*.snippet",
  command = "SnippyReload", -- Removed <CR> as it's not needed in 'command'
})

-- Git root detection (lcd)
local seen_projects = {}
local function find_git_root(path)
  return vim.fs.root(path, ".git")
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_augroup("project_root_lcd", { clear = true }),
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" or path:match("term://") then
      return
    end

    local root = find_git_root(path)
    if root and not seen_projects[root] then
      seen_projects[root] = true
      vim.cmd("lcd " .. vim.fn.fnameescape(root))
    end
  end,
})

-- Scratch buffer management
vim.api.nvim_create_autocmd("BufEnter", {
  group = create_augroup("scratch_buf_config", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
      vim.bo[buf].bufhidden = "hide"
      vim.bo[buf].swapfile = false
      vim.bo[buf].modified = false
    end
  end,
})

-- this will display the filename when i switch windows
-- useful when not running statusline
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("EchoFileNameOnFocus", { clear = true }),
  callback = function(args)
    -- Ignore command-line window and non-normal windows/buffers
    if vim.fn.getcmdwintype() ~= "" then
      return
    end

    local is_normal_win = vim.api.nvim_win_get_config(0).relative == ""
    local is_normal_buf = vim.bo[args.buf].buftype == ""
    local name = vim.api.nvim_buf_get_name(args.buf)

    if is_normal_win and is_normal_buf and name ~= "" then
      vim.schedule(function()
        -- Ensure we haven't entered cmdwin during the schedule delay
        if vim.fn.getcmdwintype() == "" and vim.api.nvim_win_is_valid(0) and vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.cmd, "file")
        end
      end)
    end
  end,
})

-- Disable plugin splits, terminals, and fzf from running in the command-line window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = general_group,
  callback = function(args)
    local key_opts = { buffer = args.buf, nowait = true, silent = true }

    -- Disable fzf-lua and terminal toggles
    vim.keymap.set("n", "<C-f>", "<Nop>", key_opts)
    vim.keymap.set("n", "<C-t>", "<Nop>", key_opts)

    -- Restore standard Vim Visual Block selection for Ctrl-v
    vim.keymap.set("n", "<C-v>", "<C-v>", key_opts)

    -- Optional: Allow pressing 'q' to close the command-line window quickly
    vim.keymap.set("n", "q", "<C-c>", key_opts)
  end,
})

local clean_init_group = vim.api.nvim_create_augroup("CleanInitialBuffer", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = clean_init_group,
  once = true, -- Only needs to run once when the first real file is loaded
  callback = function(args)
    local opened_buf = args.buf

    -- Defer slightly to ensure the new file buffer and tab are fully mounted
    vim.schedule(function()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if bufnr ~= opened_buf and vim.api.nvim_buf_is_valid(bufnr) then
          local name = vim.api.nvim_buf_get_name(bufnr)
          local is_empty = vim.api.nvim_buf_line_count(bufnr) == 1 and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == ""
          local is_unmodified = not vim.bo[bufnr].modified
          local is_real = vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ""

          -- If it has no name, is listed, empty, and unmodified, wipe it out
          if name == "" and is_real and is_empty and is_unmodified then
            -- If that buffer occupied Tab 1, closing the tab or buffer prevents empty tabs
            local wins = vim.fn.win_findbuf(bufnr)
            for _, win in ipairs(wins) do
              local tab = vim.api.nvim_win_get_tabpage(win)
              -- If Tab 1 has only this single window, close the redundant tab
              if #vim.api.nvim_tabpage_list_wins(tab) == 1 and #vim.api.nvim_list_tabpages() > 1 then
                pcall(vim.cmd, "tabclose " .. vim.api.nvim_tabpage_get_number(tab))
              end
            end
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
        end
      end
    end)
  end,
})
