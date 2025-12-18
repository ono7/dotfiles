local M = {}
local fzf = require("fzf-lua")

-- Configuration
local DATA_PATH = vim.fn.stdpath("data") .. "/projects.json"

-- Helpers: Load/Save
local function load_projects()
  local file = io.open(DATA_PATH, "r")
  if not file then
    return {}
  end
  local content = file:read("*a")
  file:close()
  local ok, data = pcall(vim.json.decode, content)
  return (ok and data) or {}
end

local function save_projects(projects)
  local file = io.open(DATA_PATH, "w")
  if file then
    file:write(vim.json.encode(projects))
    file:close()
  end
end

-- Helper: Remove a path from DB
local function db_remove(target_path)
  local projects = load_projects()
  if projects[target_path] then
    projects[target_path] = nil
    save_projects(projects)
    return true
  end
  return false
end

-- Helper: Update timestamp
local function db_touch(path)
  local projects = load_projects()
  projects[path] = os.time()
  save_projects(projects)
end

-- 1. Add Project
function M.add_project()
  local cwd = vim.fn.getcwd()
  db_touch(cwd)
  vim.notify("Tracked project: " .. cwd, vim.log.levels.INFO)
end

-- 2. Remove Project
function M.remove_project()
  local cwd = vim.fn.getcwd()
  if db_remove(cwd) then
    vim.notify("Removed project: " .. cwd, vim.log.levels.INFO)
  else
    vim.notify("Project not tracked.", vim.log.levels.WARN)
  end
end

-- 3. Pick Project (Sorted + Auto-Cleanup + Strict Pathing)
function M.pick_project()
  local projects = load_projects()
  local sorted_paths = {}

  for path, time in pairs(projects) do
    table.insert(sorted_paths, { path = path, time = time })
  end

  table.sort(sorted_paths, function(a, b)
    return a.time > b.time
  end)

  local fzf_list = {}
  for _, item in ipairs(sorted_paths) do
    table.insert(fzf_list, item.path)
  end

  fzf.fzf_exec(fzf_list, {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        local path = selected[1]

        if vim.fn.isdirectory(path) == 0 then
          db_remove(path)
          vim.notify("Directory missing. Removed: " .. path, vim.log.levels.WARN)
          return
        end

        vim.cmd("lcd " .. path)
        db_touch(path)

        -- FIX: Force `fd` to use the strict path, ignoring git roots
        vim.schedule(function()
          fzf.files({
            cwd = path,
            cmd = "fd --type f --hidden --follow --exclude .git",
            git_icons = false,
          })
        end)
      end,
    },
  })
end

-- 4. Open Last Project Directly (Strict Pathing)
function M.last_project()
  local projects = load_projects()
  local best_path = nil
  local best_time = -1

  -- Find the entry with the highest timestamp
  for path, time in pairs(projects) do
    if time > best_time then
      best_path = path
      best_time = time
    end
  end

  if not best_path then
    vim.notify("No projects tracked yet.", vim.log.levels.WARN)
    return
  end

  -- Validate existence
  if vim.fn.isdirectory(best_path) == 0 then
    db_remove(best_path)
    vim.notify("Last project missing. Removed: " .. best_path:sub(-60), vim.log.levels.ERROR)
    return
  end

  -- Switch and Open
  vim.cmd("lcd " .. best_path)
  db_touch(best_path) -- Update timestamp so it stays at the top
  vim.notify("Switched to last: " .. best_path:sub(-60))

  -- FIX: Force `fd` to use the strict path, ignoring git roots
  fzf.files({
    cwd = best_path,
    cmd = "fd --type f --hidden --follow --exclude .git",
    git_icons = false,
  })
end

-- Setup
function M.setup()
  -- User Commands
  vim.api.nvim_create_user_command("ProjectAdd", M.add_project, {})
  vim.api.nvim_create_user_command("ProjectRemove", M.remove_project, {})
  vim.api.nvim_create_user_command("ProjectPick", M.pick_project, {})
  vim.api.nvim_create_user_command("L", M.last_project, {})

  -- Keymaps
  vim.keymap.set("n", "<leader>pp", "<cmd>ProjectPick<CR>", { desc = "Pick Project" })
  vim.keymap.set("n", "<leader>pa", "<cmd>ProjectAdd<CR>", { desc = "Add Project" })
  vim.keymap.set("n", "<leader>pr", "<cmd>ProjectRemove<CR>", { desc = "Remove Project" })
  vim.keymap.set("n", "<leader>pl", "<cmd>L<CR>", { desc = "Last Project" })
end

return M
