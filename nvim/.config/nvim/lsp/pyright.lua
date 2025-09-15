local function get_poetry_venv()
  local result = vim.fn.trim(vim.fn.system('poetry env info -p'))
  -- Check if command succeeded (poetry returns empty or error message if failed)
  if vim.v.shell_error == 0 and result ~= '' then
    return result
  end
  return nil
end

local function get_python_dir(root_dir)
  -- Priority 1: Local venv in project root
  local local_venv = root_dir .. "/venv"
  if vim.fn.isdirectory(local_venv) == 1 then
    local python_bin = local_venv .. "/bin/python"
    if vim.fn.executable(python_bin) == 1 then
      return local_venv
    end
  end

  -- Priority 2: Poetry environment (if poetry.lock exists)
  local poetry_lock = root_dir .. "/poetry.lock"
  if vim.fn.filereadable(poetry_lock) == 1 then
    return get_poetry_venv()
  end

  return nil
end

local function activate_venv(root_dir)
  -- Only activate if no virtual env is already active
  if not vim.env.VIRTUAL_ENV or vim.env.VIRTUAL_ENV == '' then
    local venv_dir = get_python_dir(root_dir)

    if venv_dir then
      -- Set VIRTUAL_ENV
      vim.env.VIRTUAL_ENV = venv_dir

      -- Prepend venv/bin to PATH
      local venv_bin = venv_dir .. "/bin:"
      vim.env.PATH = venv_bin .. vim.env.PATH

      -- Handle PYTHONHOME if set
      if vim.env.PYTHONHOME then
        vim.env.OLD_PYTHONHOME = vim.env.PYTHONHOME
        vim.env.PYTHONHOME = nil
      end

      return venv_dir .. "/bin/python"
    end
  else
    -- Return existing venv python path
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  return nil
end

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyrightconfig.json", "pyproject.toml", "poetry.lock", "venv", "requirements.txt", "setup.py", ".git" },
  on_attach = function(client, bufnr)
    local root_dir = client.config.root_dir or vim.fn.getcwd()
    local python_path = activate_venv(root_dir)

    if python_path then
      -- Update client settings
      client.config.settings = client.config.settings or {}
      client.config.settings.python = client.config.settings.python or {}
      client.config.settings.python.pythonPath = python_path

      -- Notify client of settings change
      client.notify("workspace/didChangeConfiguration", {
        settings = client.config.settings
      })
    end
  end,
  settings = {
    pyright = {
      autoImportCompletion = true,
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        extraPaths = {},
        reportMissingImports = true,
        reportMissingTypeStubs = false,
        -- pythonVersion = "3.12",
        typeCheckingMode = "basic",
        -- Disable "is not accessed" warnings
        -- reportUnusedVariable = false,
        -- reportUnusedImports = false,
        -- reportUnusedClass = false,
        -- reportUnusedFunction = false,
      },
    },
  },
}
