return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "venv", "requirements.txt", "setup.py", ".git", "pyproject.toml" },
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = { "--fix", "--select", "I" },
    },
  },
  settings = {
    organizeImports = true,
  },
  single_file_support = true,
}
