return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- This fixes the "undefined global vim" error
        globals = { "vim" },
      },
      workspace = {
        -- Only include the Neovim runtime and specifically your config
        -- Avoid using vim.api.nvim_get_runtime_file("", true) as it is too broad
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        maxPreload = 2000,
        preloadFileSize = 1000,
        -- Prevents the LSP from asking to configure your workspace every time
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
