-- Cache to store poetry paths per project root so we don't query system repeatedly

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function trim_path(s)
  if not s or #s <= 45 then
    return s or ""
  end
  return "..." .. s:sub(-42)
end

local function resolve_python_path(root_dir)
  -- 1. Active terminal virtual environment
  if vim.env.VIRTUAL_ENV and file_exists(vim.env.VIRTUAL_ENV .. "/bin/python") then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  if not root_dir then
    return nil
  end

  -- 2. Local .venv (Standard for uv, venv, and in-project Poetry)
  local dot_venv = root_dir .. "/.venv/bin/python"
  if file_exists(dot_venv) then
    return dot_venv
  end

  -- 3. Local venv (Standard alternative naming)
  local standard_venv = root_dir .. "/venv/bin/python"
  if file_exists(standard_venv) then
    return standard_venv
  end

  -- 4. External Poetry environment
  if file_exists(root_dir .. "/poetry.lock") then
    local cmd = "cd " .. vim.fn.shellescape(root_dir) .. " && poetry env info --path"
    local path = vim.fn.trim(vim.fn.system(cmd))
    if vim.v.shell_error == 0 and path ~= "" then
      local poetry_bin = path .. "/bin/python"
      if file_exists(poetry_bin) then
        return poetry_bin
      end
    end
  end

  return nil
end

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    ".venv",
    "pyproject.toml",
    "poetry.lock",
    ".git",
  },
  flags = {
    debounce_text_changes = 300,
  },
  before_init = function(_, config)
    local python_path = resolve_python_path(config.root_dir)
    if python_path then
      config.settings.python.pythonPath = python_path
      vim.schedule(function()
        vim.notify("env: ✔ ")
      end)
    else
      vim.schedule(function()
        vim.notify("env: ✖ system default", vim.log.levels.WARN, {
          title = "Pyright",
        })
      end)
    end
  end,
  on_attach = function(client, bufnr)
    -- Buffer-local keymaps and buffer settings
  end,
  settings = {
    python = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        indexing = false, -- do not index non-open files in the project
      },
    },
  },
}
