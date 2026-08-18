-- return {
--   cmd = { "clangd",
--     "--background-index",
--     "--clang-tidy",
--     "--header-insertion=iwyu",
--     "--completion-style=detailed",
--     "--function-arg-placeholders",
--     "--fallback-style=llvm", },
--   filetypes = { "c" },
--   root_markers = { ".git" },
-- }

return {
  cmd = {
    "clangd",
    "--background-index", -- Index project in the background
    "--clang-tidy", -- Enable clang-tidy diagnostics
    "--header-insertion=iwyu", -- Add #includes automatically for missing symbols
    "--completion-style=detailed", -- Provide detailed completion items
    "--function-arg-placeholders", -- Add placeholders for function arguments
    "--fallback-style=llvm", -- Formatting style to use if no .clang-format is found
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "configure.ac",
    ".git",
  },
  -- clangd doesn't use the LSP settings object in the same way Lua does.
  -- Project-specific settings belong in a `.clangd` YAML file at the project root.
  settings = {},
}
