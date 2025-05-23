return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "venv", "requirements.txt", "setup.py", ".git", "pyproject.toml" },
  settings = {
    organizeImports = true,
  },
  single_file_support = true,
}
