return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "venv", "requirements.txt", "setup.py", ".git" },
  -- on_attach is now handled outside of the config for individual servers. see vim.lsp.handlers
  settings = {
    pyright = {
      autoImportCompletion = true,
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
      },
    },
  },
}
