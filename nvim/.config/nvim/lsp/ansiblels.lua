local function get_poetry_venv()
  local result = vim.fn.trim(vim.fn.system("poetry env info -p"))
  if vim.v.shell_error == 0 and result ~= "" then
    return result
  end
  return nil
end

local function get_python_path(root_dir)
  -- Priority 1: Local .venv
  local local_venv = root_dir .. "/.venv"
  if vim.fn.isdirectory(local_venv) == 1 then
    local python_bin = local_venv .. "/bin/python"
    if vim.fn.executable(python_bin) == 1 then
      return python_bin
    end
  end

  -- Priority 2: Poetry
  local poetry_lock = root_dir .. "/poetry.lock"
  if vim.fn.filereadable(poetry_lock) == 1 then
    local venv = get_poetry_venv()
    if venv then
      return venv .. "/bin/python"
    end
  end

  return nil
end

return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = {
    ".venv",
    "ansible.cfg",
    ".ansible-lint",
    "poetry.lock",
    ".git",
  },
  on_attach = function(client, bufnr)
    local root_dir = client.config.root_dir
    local python_path = get_python_path(root_dir)

    if python_path then
      local venv_dir = vim.fn.fnamemodify(python_path, ":h:h")
      local ansible_path = venv_dir .. "/bin/ansible"
      local ansible_lint_path = venv_dir .. "/bin/ansible-lint"

      client.config.settings.ansible.python.interpreterPath = python_path

      if vim.fn.executable(ansible_path) == 1 then
        client.config.settings.ansible.ansible.path = ansible_path
      end

      if vim.fn.executable(ansible_lint_path) == 1 then
        client.config.settings.ansible.validation.lint.path = ansible_lint_path
      end

      client.notify("workspace/didChangeConfiguration", {
        settings = client.config.settings,
      })
    end
  end,
  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      ansible = {
        path = "ansible",
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
