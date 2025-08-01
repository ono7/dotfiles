return {
  cmd = { "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm", },
  filetypes = { "c" },
  root_markers = { ".git" },
}
