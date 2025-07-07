local M = {}

function M.setup()
  -- Store the previous directory
  local prev_dir = nil
  local at_root = false

  -- Use your existing function to check if in git repo
  local function is_git_repo()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return result:match("true")
    end
    return false
  end

  -- Get git repo root path
  local function get_git_root()
    local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return result:gsub("\n$", "") -- Remove trailing newline
    end
    return nil
  end

  -- Toggle between project root and previous directory
  local function toggle_project_dir()
    -- Get current directory
    local current_dir = vim.fn.getcwd()

    if at_root and prev_dir then
      -- We're at root, go back to previous directory
      vim.cmd("cd " .. prev_dir)
      print("Changed to: " .. prev_dir)
      at_root = false
    else
      -- We're not at root, save current dir and go to root
      if is_git_repo() then
        prev_dir = current_dir
        local root = get_git_root()
        vim.cmd("cd " .. root)
        print("Changed to git root: " .. root)
        at_root = true
      else
        print("Not in a git repository")
      end
    end
  end

  -- Create the user command
  vim.api.nvim_create_user_command("Cd", toggle_project_dir, {})
end
return M
