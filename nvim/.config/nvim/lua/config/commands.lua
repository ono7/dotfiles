local opts = { silent = true }
local term_size = 12

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

vim.api.nvim_create_user_command("T", function(opts_args)
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

  local github_repo_url =
    string.format("https://%s/%s/%s", vim.uri_encode(host), vim.uri_encode(user), vim.uri_encode(repo))
  local github_file_url = string.format(
    "%s/blob/%s/%s#L%s",
    vim.uri_encode(github_repo_url),
    vim.uri_encode(git_ref),
    vim.uri_encode(file),
    line
  )
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
