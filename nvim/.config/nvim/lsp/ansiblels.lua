-- Shared cache for poetry paths
local venv_cache = {}

local function trim_path(s)
  if #s < 50 then
    return s
  else
    local l = #s / 2
    return s:sub(-l)
  end
end

local function get_python_path(root_dir)
  -- Priority 0: Active Shell Virtual Environment (Fastest & Safest)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  -- GUARD CLAUSE: Return nil if we aren't in a project
  if not root_dir then
    return nil
  end

  -- Priority 1: Local .venv in project root (Fast)
  local local_venv = root_dir .. "/.venv"
  if vim.fn.isdirectory(local_venv) == 1 then
    return local_venv .. "/bin/python"
  end

  -- Priority 2: Poetry (Slow, so we cache it)
  local poetry_lock = root_dir .. "/poetry.lock"
  if vim.fn.filereadable(poetry_lock) == 1 then
    if venv_cache[root_dir] then
      return venv_cache[root_dir]
    end

    local cmd = "cd " .. vim.fn.shellescape(root_dir) .. " && poetry env info --path"
    local path = vim.fn.trim(vim.fn.system(cmd))

    if vim.v.shell_error == 0 and path ~= "" then
      local python_bin = path .. "/bin/python"
      venv_cache[root_dir] = python_bin
      return python_bin
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

  -- Dynamic environment setup before server initialization
  before_init = function(params, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    config.cmd_env = config.cmd_env or {}

    -- Dynamically build collections path using the actual detected project root
    local collections_paths = root_dir .. "/collections:" .. root_dir .. "/.collections"
    if vim.env.ANSIBLE_COLLECTIONS_PATH then
      collections_paths = collections_paths .. ":" .. vim.env.ANSIBLE_COLLECTIONS_PATH
    end

    config.cmd_env.ANSIBLE_COLLECTIONS_PATH = collections_paths
  end,

  on_attach = function(client, bufnr)
    local root_dir = client.config.root_dir
    local python_path = get_python_path(root_dir)
    -- disable formatting, let conform handle this, conform will honor rules
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if python_path then
      local bin_dir = vim.fn.fnamemodify(python_path, ":h")

      local ansible_path = bin_dir .. "/ansible"
      local ansible_lint_path = bin_dir .. "/ansible-lint"

      -- 1. Set Python Interpreter
      client.config.settings.ansible.python.interpreterPath = python_path

      -- 2. Set Ansible Binary (if it exists in venv)
      if vim.fn.executable(ansible_path) == 1 then
        client.config.settings.ansible.ansible.path = ansible_path
      end

      -- 3. Set Ansible Lint (if it exists in venv)
      if vim.fn.executable(ansible_lint_path) == 1 then
        client.config.settings.ansible.validation.lint.path = ansible_lint_path
      end


      client:notify("workspace/didChangeConfiguration", {
        settings = client.config.settings,
      })

      -- vim.notify("Ansible: " .. trim_path(bin_dir))
      vim.notify("Ansible: project venv active")
    end
  end,

  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      ansible = {
        path = "ansible",
        useFullyQualifiedCollectionNames = true,
      },
      executionEnvironment = {
        enabled = false,
      },
      validation = {
        lint = {
          enabled = true,
          path = "ansible-lint",
          arguments = "-x yaml[line-length]",
        },
      },
    },
  },
}
