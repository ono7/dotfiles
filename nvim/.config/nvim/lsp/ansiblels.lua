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
  local venv_dir = get_python_dir(root_dir)

  if venv_dir then
    local current_venv = vim.env.VIRTUAL_ENV

    -- If same venv is already active, nothing to do
    if current_venv == venv_dir then
      return venv_dir .. "/bin/python"
    end

    -- Clean up previous venv from PATH if different venv was active
    if current_venv and current_venv ~= '' then
      local old_venv_bin = current_venv .. "/bin:"
      vim.env.PATH = vim.env.PATH:gsub(vim.pesc(old_venv_bin), "")

      -- Restore old PYTHONHOME if it was backed up
      if vim.env.OLD_PYTHONHOME then
        vim.env.PYTHONHOME = vim.env.OLD_PYTHONHOME
        vim.env.OLD_PYTHONHOME = nil
      end
    end

    -- Activate new venv
    vim.env.VIRTUAL_ENV = venv_dir

    -- Prepend new venv/bin to PATH
    local venv_bin = venv_dir .. "/bin:"
    vim.env.PATH = venv_bin .. vim.env.PATH

    -- Handle PYTHONHOME
    if vim.env.PYTHONHOME then
      vim.env.OLD_PYTHONHOME = vim.env.PYTHONHOME
      vim.env.PYTHONHOME = nil
    end

    return venv_dir .. "/bin/python"
  end

  return nil
end

return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", "poetry.lock", "venv", ".git" },
  on_attach = function(client, bufnr)
    local root_dir = client.config.root_dir or vim.fn.getcwd()
    local python_path = activate_venv(root_dir)

    if python_path then
      local venv_dir = vim.env.VIRTUAL_ENV
      local ansible_path = venv_dir .. "/bin/ansible"
      local ansible_lint_path = venv_dir .. "/bin/ansible-lint"

      -- Update client settings
      client.config.settings = client.config.settings or {}
      client.config.settings.ansible = client.config.settings.ansible or {}
      client.config.settings.ansible.python = client.config.settings.ansible.python or {}
      client.config.settings.ansible.ansible = client.config.settings.ansible.ansible or {}
      client.config.settings.ansible.validation = client.config.settings.ansible.validation or {}
      client.config.settings.ansible.validation.lint = client.config.settings.ansible.validation.lint or {}

      -- Set Python interpreter
      client.config.settings.ansible.python.interpreterPath = python_path

      -- Set Ansible path if it exists in venv
      if vim.fn.executable(ansible_path) == 1 then
        client.config.settings.ansible.ansible.path = ansible_path
      end

      -- Set ansible-lint path if it exists in venv
      if vim.fn.executable(ansible_lint_path) == 1 then
        client.config.settings.ansible.validation.lint.path = ansible_lint_path
      end

      -- Notify client of settings change
      client.notify("workspace/didChangeConfiguration", {
        settings = client.config.settings
      })
    end
  end,
  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      playbook = {
        arguments = { "--syntax-check" },
      },
      ansible = {
        path = "ansible",
      },
      executionEnvironment = {
        enabled = false,
      },
      validation = {
        lint = {
          enabled = true,
          path = "ansible-lint",
        },
      },
    },
  },
}
