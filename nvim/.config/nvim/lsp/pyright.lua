local function get_poetry_venv()
  local result = vim.fn.trim(vim.fn.system("poetry env info -p"))
  if vim.v.shell_error == 0 and result ~= "" then
    return result
  end
  return nil
end

local function trim_path(s)
  if #s < 50 then
    return s
  else
    local l = #s / 2
    return s:sub(-l)
  end
end

local function get_python_path(root_dir)
  -- Priority 1: Local .venv

  if not root_dir then
    return
  end

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

vim.diagnostic.config({ update_in_insert = false })

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    ".venv",
    "pyproject.toml",
    "poetry.lock",
    "requirements.txt",
    ".git",
  },
  flags = {
    debounce_text_changes = 500, -- Wait 300ms after typing stops before analyzing
  },
  on_attach = function(client, bufnr)
    local root_dir = client.config.root_dir
    local python_path = get_python_path(root_dir)

    if python_path then
      -- vim.api.nvim_echo({ { "venv: ", "Normal" }, { trim_path(python_path), "Comment" } }, false, {})
      vim.notify("VENV: " .. trim_path(python_path))
      client.config.settings.python.pythonPath = python_path
      client.notify("workspace/didChangeConfiguration", {
        settings = client.config.settings,
      })
    end
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
}
