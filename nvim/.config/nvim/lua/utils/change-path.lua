local M = {}

function M.setup()
  local prev_dir = nil
  local at_root = false

  -- Return the project root according to Neovim’s built-in mechanism.
  -- Documentation: :h vim.fs.root
  local function get_project_root()
    local buf = vim.api.nvim_get_current_buf()
    local markers = { ".git", "pyproject.toml", "package.json", "Makefile" }
    return vim.fs.root(buf, markers)
  end

  local function toggle_project_dir()
    local current_dir = vim.uv.cwd()

    -- Toggle back to previous buffer-local cwd.
    if at_root and prev_dir then
      vim.cmd.lcd(prev_dir)
      vim.notify("Changed to: " .. prev_dir, vim.log.levels.INFO)
      at_root = false
      return
    end

    -- Find new root.
    local root = get_project_root()
    if not root then
      vim.notify("No project root detected", vim.log.levels.WARN)
      return
    end

    prev_dir = current_dir
    vim.cmd.lcd(root)
    vim.notify("Changed to project root: " .. root, vim.log.levels.INFO)
    at_root = true
  end

  vim.api.nvim_create_user_command("Cd", toggle_project_dir, {})
end

return M
