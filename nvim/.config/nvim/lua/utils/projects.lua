local M = {}
local fzf = require('fzf-lua')

-- Configuration
local DATA_PATH = vim.fn.stdpath('data') .. '/projects.json'

-- Helpers: Load/Save
local function load_projects()
  local file = io.open(DATA_PATH, "r")
  if not file then return {} end
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

-- Helper: Remove a path from DB (Shared logic)
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
  db_touch(cwd) -- Adds or updates timestamp
  vim.notify("Tracked project: " .. cwd, vim.log.levels.INFO)
end

-- 2. Remove Project (Manual)
function M.remove_project()
  local cwd = vim.fn.getcwd()
  if db_remove(cwd) then
    vim.notify("Removed project: " .. cwd, vim.log.levels.INFO)
  else
    vim.notify("Project not tracked.", vim.log.levels.WARN)
  end
end

-- 3. Pick Project (Sorted + Auto-Cleanup)
function M.pick_project()
  local projects = load_projects()
  local sorted_paths = {}

  -- Convert map to list for sorting
  for path, time in pairs(projects) do
    table.insert(sorted_paths, { path = path, time = time })
  end

  -- Sort: Newest time first
  table.sort(sorted_paths, function(a, b) return a.time > b.time end)

  -- Extract paths for FZF
  local fzf_list = {}
  for _, item in ipairs(sorted_paths) do
    table.insert(fzf_list, item.path)
  end

  fzf.fzf_exec(fzf_list, {
    prompt = 'Projects> ',
    actions = {
      ['default'] = function(selected)
        local path = selected[1]

        -- Validation: Check existence
        if vim.fn.isdirectory(path) == 0 then
          -- Auto-cleanup missing directory
          db_remove(path)
          vim.notify("Directory missing. Removed from list: " .. path, vim.log.levels.WARN)
          return
        end

        -- Execute tcd and update timestamp
        vim.cmd('tcd ' .. path)
        db_touch(path)
        vim.notify("Switched to: " .. path)
      end
    }
  })
end

-- Setup
function M.setup()
  vim.api.nvim_create_user_command('ProjectAdd', M.add_project, {})
  vim.api.nvim_create_user_command('ProjectRemove', M.remove_project, {})
  vim.api.nvim_create_user_command('ProjectPick', M.pick_project, {})
  vim.keymap.set('n', '<leader>pp', '<cmd>ProjectPick<CR>', { desc = "Pick Project" })
  vim.keymap.set('n', '<leader>pa', '<cmd>ProjectAdd<CR>', { desc = "Pick Project" })
  vim.keymap.set('n', '<leader>pr', '<cmd>ProjectRemove<CR>', { desc = "Pick Project" })
end

return M
