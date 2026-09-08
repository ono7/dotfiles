local M = {}
local fzf = require("fzf-lua")

local DATA_PATH = vim.fn.expand("~/.neovim_projects.json")
local uv = vim.uv or vim.loop

local function trim_path(s)
  if #s < 50 then
    return s
  end
  local l = math.floor(#s / 2)
  return s:sub(-l)
end

local function load_projects()
  local file = io.open(DATA_PATH, "r")
  if not file then
    return {}
  end
  local content = file:read("*a")
  file:close()
  local ok, data = pcall(vim.json.decode, content)
  return (ok and type(data) == "table" and data) or {}
end

local function save_projects(projects)
  local file = io.open(DATA_PATH, "w")
  if file then
    file:write(vim.json.encode(projects))
    file:close()
  end
end

local function db_remove(target_path)
  local projects = load_projects()
  if projects[target_path] then
    projects[target_path] = nil
    save_projects(projects)
    return true
  end
  return false
end

local function db_touch(path)
  local projects = load_projects()
  projects[path] = os.time()
  save_projects(projects)
end

local function open_project_files(path)
  -- NOTE(jlima): cwd_only scopes vim.v.oldfiles strictly to target root without manual path filtering.
  fzf.oldfiles({
    cwd = path,
    cwd_only = true,
    git_icons = false,
    previewer = false,
    prompt = "MRU Files> ",
  })
end

function M.add_project()
  -- NOTE(jlima): uv.cwd() queries OS process state directly, avoiding window-local cwd desync.
  local cwd = uv.cwd()
  db_touch(cwd)
  vim.notify("Tracking: " .. trim_path(cwd), vim.log.levels.INFO)
end

function M.remove_project()
  local cwd = uv.cwd()
  if db_remove(cwd) then
    vim.notify("Removed project: " .. trim_path(cwd), vim.log.levels.INFO)
  else
    vim.notify("Project not tracked.", vim.log.levels.WARN)
  end
end

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
        if not path then
          return
        end

        if vim.fn.isdirectory(path) == 0 then
          db_remove(path)
          vim.notify("Directory missing. Removed: " .. trim_path(path), vim.log.levels.WARN)
          return
        end

        -- NOTE(jlima): nvim_set_current_dir takes raw string paths directly, bypassing vimscript fnameescape space and parenthesis truncation bugs.
        vim.api.nvim_set_current_dir(path)
        db_touch(path)

        vim.schedule(function()
          open_project_files(path)
        end)
      end,
    },
  })
end

function M.last_project()
  local projects = load_projects()
  local best_path = nil
  local best_time = -1

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

  if vim.fn.isdirectory(best_path) == 0 then
    db_remove(best_path)
    vim.notify("Last project missing. Removed: " .. trim_path(best_path), vim.log.levels.ERROR)
    return
  end

  -- NOTE(jlima): nvim_set_current_dir takes raw string paths directly, bypassing vimscript fnameescape space and parenthesis truncation bugs.
  vim.api.nvim_set_current_dir(best_path)
  db_touch(best_path)
  vim.notify("CWD: " .. trim_path(best_path))

  open_project_files(best_path)
end

function M.setup()
  vim.api.nvim_create_user_command("ProjectAdd", M.add_project, {})
  vim.api.nvim_create_user_command("ProjectRemove", M.remove_project, {})
  vim.api.nvim_create_user_command("ProjectPick", M.pick_project, {})
  vim.api.nvim_create_user_command("L", M.last_project, {})

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>pp", M.pick_project, vim.tbl_extend("force", opts, { desc = "Pick Project" }))
  vim.keymap.set("n", "<leader>pa", M.add_project, vim.tbl_extend("force", opts, { desc = "Add Project" }))
  vim.keymap.set("n", "<leader>pr", M.remove_project, vim.tbl_extend("force", opts, { desc = "Remove Project" }))
  vim.keymap.set("n", "<leader>pl", M.last_project, vim.tbl_extend("force", opts, { desc = "Last Project" }))
end

return M
