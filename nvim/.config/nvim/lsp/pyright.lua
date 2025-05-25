return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyrightconfig.json", "pyproject.toml", "venv", "requirements.txt", "setup.py", ".git" },
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
