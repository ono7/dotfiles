return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
  settings = {},
  single_file_support = true,
}
