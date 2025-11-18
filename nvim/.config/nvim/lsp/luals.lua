return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  telemetry = { enabled = false },
  formatters = {
    ignoreComments = false,
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        -- library = {
        --   vim.env.VIMRUNTIME,
        --   -- vim.api.nvim_get_runtime_file("", true),
        -- },
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 10000,
        preloadFileSize = 10000,
      },
      telemetry = { enable = false },
    },
  },
}
