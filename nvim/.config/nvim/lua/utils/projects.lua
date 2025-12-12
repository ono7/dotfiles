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
  return ok and data or {}
end

local function save_projects(projects)
  local file = io.open(DATA_PATH, "w")
  if file then
    file:write(vim.json.encode(projects))
    file:close()
  end
end

-- 1. Add Project
function M.add_project()
  local cwd = vim.fn.getcwd()
  local projects = load_projects()

  -- Check for duplicates
  for _, path in ipairs(projects) do
    if path == cwd then
      vim.notify("Project already exists: " .. cwd, vim.log.levels.WARN)
      return
    end
  end

  table.insert(projects, cwd)
  save_projects(projects)
  vim.notify("Added project: " .. cwd, vim.log.levels.INFO)
end

-- 2. Remove Project
function M.remove_project()
  local cwd = vim.fn.getcwd()
  local projects = load_projects()
  local new_projects = {}
  local found = false

  for _, path in ipairs(projects) do
    if path ~= cwd then
      table.insert(new_projects, path)
    else
      found = true
    end
  end

  if found then
    save_projects(new_projects)
    vim.notify("Removed project: " .. cwd, vim.log.levels.INFO)
  else
    vim.notify("Project not found in list.", vim.log.levels.WARN)
  end
end

-- 3. Pick Project (FZF)
function M.pick_project()
  local projects = load_projects()

  fzf.fzf_exec(projects, {
    prompt = 'Projects> ',
    actions = {
      ['default'] = function(selected)
        local path = selected[1]
        -- Validation: Check if directory still exists
        if vim.fn.isdirectory(path) == 0 then
          vim.notify("Directory no longer exists: " .. path, vim.log.levels.ERROR)
          return
        end

        -- Execute tcd
        vim.cmd('tcd ' .. path)
        vim.notify("Switched to: " .. path)
      end
    }
  })
end

-- Setup user commands
function M.setup()
  vim.api.nvim_create_user_command('ProjectAdd', M.add_project, {})
  vim.api.nvim_create_user_command('ProjectRemove', M.remove_project, {})
  vim.api.nvim_create_user_command('ProjectPick', M.pick_project, {})
  vim.keymap.set('n', '<leader>pp', '<cmd>ProjectPick<CR>', { desc = "Pick Project" })
  vim.keymap.set('n', '<leader>pa', '<cmd>ProjectAdd<CR>', { desc = "Pick Project" })
  vim.keymap.set('n', '<leader>pr', '<cmd>ProjectRemove<CR>', { desc = "Pick Project" })
end

return M
