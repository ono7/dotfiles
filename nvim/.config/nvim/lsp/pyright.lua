return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyrightconfig.json", "venv", "requirements.txt", "setup.py", ".git" },
  settings = {
    pyright = {
      autoImportCompletion = true,
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        extraPaths = {}, -- Add any extra paths to your packages here
        reportMissingImports = true,
        reportMissingTypeStubs = false,
        pythonVersion = "3.x",
        typeCheckingMode = "basic",
      },
    },
  },
  -- Make sure capabilities are set in your global LSP setup
}
