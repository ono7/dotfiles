return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    css = {
      validate = true,
    },
    less = {
      validate = true,
    },
    scss = {
      validate = true,
    },
  },
  single_file_support = true,
}
