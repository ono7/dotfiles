local terminal_buf = nil
local terminal_win = nil
local term_job_id = nil
local term_size = 12

vim.api.nvim_create_user_command("T", function(opts)
  local cmd = opts.args

  if terminal_buf == nil or not vim.api.nvim_buf_is_valid(terminal_buf) then
    vim.cmd.split()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, term_size)

    -- Get the directory of the current file
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    if current_file ~= "" then
      current_dir = vim.fn.fnamemodify(current_file, ":h")
    else
      current_dir = vim.fn.getcwd()
    end

    vim.cmd.term()
    terminal_buf = vim.api.nvim_get_current_buf()
    terminal_win = vim.api.nvim_get_current_win()
    term_job_id = vim.b.terminal_job_id

    -- Change to the current file's directory
    vim.fn.chansend(term_job_id, "cd " .. vim.fn.shellescape(current_dir) .. "\n")

    if cmd ~= "" then
      vim.fn.chansend(term_job_id, cmd .. "\n")
    end
    vim.cmd("startinsert")
    return
  end

  local wins = vim.api.nvim_list_wins()
  local is_visible = false
  local cursor_pos
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == terminal_buf then
      cursor_pos = vim.api.nvim_win_get_cursor(win)
      vim.api.nvim_win_hide(win)
      is_visible = true
      break
    end
  end

  if not is_visible then
    vim.cmd.split()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, term_size)
    vim.api.nvim_win_set_buf(0, terminal_buf)
    terminal_win = vim.api.nvim_get_current_win()
    if cursor_pos then
      vim.api.nvim_win_set_cursor(terminal_win, cursor_pos)
    end
    if cmd ~= "" then
      vim.fn.chansend(term_job_id, cmd .. "\n")
    end
    vim.cmd("startinsert")
  end
end, { nargs = "*" })

local opts = { silent = true }
vim.keymap.set({ "n" }, "<C-t>", ":T<CR>", opts)
-- vim.keymap.set({ "i" }, "<C-t>", [[<c-\><c-n>:T<CR>]], opts)

vim.keymap.set({ "n" }, "<C-t>", ":T<CR>", opts)
-- vim.keymap.set({ "i" }, "<C-t>", [[<c-\><c-n>:T<CR>]], opts)

vim.api.nvim_create_user_command("Commit", function(opts)
  local diff_cmd = opts.args ~= "" and "head~" .. opts.args or "--staged"
  vim.cmd("r!git diff " .. diff_cmd)
  vim.cmd("normal! ggVG")
end, {
  nargs = "?", -- Makes the argument optional
})

vim.api.nvim_create_user_command("A", function()
  vim.cmd([[WorkspacesAdd]])
end, {})

vim.api.nvim_create_user_command("R", function()
  vim.cmd([[WorkspacesRemove]])
end, {})

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
