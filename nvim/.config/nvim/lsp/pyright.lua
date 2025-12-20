-- Cache to store poetry paths per project root so we don't query system repeatedly
local venv_cache = {}

local function get_python_path(root_dir)
  -- Priority 0: Active Shell Virtual Environment (Fastest & Safest)
  -- This works even if root_dir is nil (e.g. library files)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  -- GUARD CLAUSE: If we are in a dependency file (site-packages), root_dir is nil.
  -- We cannot check for local project files, so we bail out.
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
    -- Return cached value if it exists
    if venv_cache[root_dir] then
      return venv_cache[root_dir]
    end

    -- Run poetry info only once
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
  on_attach = function(client, bufnr)
    -- 1. Virtual Env Setup
    local root_dir = client.config.root_dir
    local python_path = get_python_path(root_dir)

    if python_path then
      client.config.settings.python.pythonPath = python_path
      client.notify("workspace/didChangeConfiguration", {
        settings = client.config.settings,
      })
    end

    -- 2. UX Optimization: Enable Inlay Hints (Neovim 0.10+)
    -- Shows param names inline: func(name="param")
    -- if client.server_capabilities.inlayHintProvider then
    --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- end
  end,
  settings = {
    python = {
      analysis = {
        -- PERFORMANCE: Only analyze files you are editing, not the whole repo.
        diagnosticMode = "openFilesOnly",

        -- TYPE CHECKING: Strictness settings
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
