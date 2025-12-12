local opts = { silent = true }

local terminal_buf = nil
local terminal_win = nil
local term_job_id = nil
local term_size = 12

local last_win = nil
local last_cursor = nil

vim.api.nvim_create_user_command("T", function(opts)
  local cmd = opts.args

  -- Save editor window + cursor
  local function save_editor_pos()
    last_win = vim.api.nvim_get_current_win()
    last_cursor = vim.api.nvim_win_get_cursor(0)
  end

  -- Restore previous editor window + cursor
  local function restore_editor_pos()
    if last_win and vim.api.nvim_win_is_valid(last_win) then
      vim.api.nvim_set_current_win(last_win)
      if last_cursor then
        pcall(vim.api.nvim_win_set_cursor, last_win, last_cursor)
      end
    end
  end

  ---------------------------------------------------------------------------
  -- CREATE NEW TERMINAL
  ---------------------------------------------------------------------------
  if terminal_buf == nil or not vim.api.nvim_buf_is_valid(terminal_buf) then
    save_editor_pos()
    vim.opt_local.winbar = nil

    -- Create bottom terminal without shifting current window
    vim.cmd("botright " .. term_size .. "split")

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()

    vim.cmd.term()

    terminal_buf = vim.api.nvim_get_current_buf()
    terminal_win = vim.api.nvim_get_current_win()
    term_job_id = vim.b.terminal_job_id

    vim.fn.chansend(term_job_id, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
    if cmd ~= "" then
      vim.fn.chansend(term_job_id, cmd .. "\n")
    end

    vim.cmd("startinsert")
    return
  end

  ---------------------------------------------------------------------------
  -- TERMINAL EXISTS → TOGGLE
  ---------------------------------------------------------------------------

  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == terminal_buf then
      -- HIDE terminal
      vim.api.nvim_win_hide(win)
      restore_editor_pos()
      return
    end
  end

  ---------------------------------------------------------------------------
  -- SHOW EXISTING TERMINAL
  ---------------------------------------------------------------------------
  save_editor_pos()

  vim.cmd("botright " .. term_size .. "split")
  vim.api.nvim_win_set_buf(0, terminal_buf)
  terminal_win = vim.api.nvim_get_current_win()

  if cmd ~= "" then
    vim.fn.chansend(term_job_id, cmd .. "\n")
  end

  vim.cmd("startinsert")
end, { nargs = "*" })

vim.keymap.set("n", "<C-t>", "<cmd>T<CR>", opts)

---Call `:GitOpen dev` to open the file on the `dev` branch
vim.api.nvim_create_user_command("GitOpen", function(opts)
  -- Current file
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file = vim.fn.expand("%:p"):gsub(vim.pesc(git_root .. "/"), "")
  local line = vim.fn.line(".")

  -- Git repo things
  local repo_url = vim.fn.system("git -C " .. git_root .. " config --get remote.origin.url")
  ---@type string | nil
  local forced_branch = #opts.args > 0 and opts.args or nil
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
