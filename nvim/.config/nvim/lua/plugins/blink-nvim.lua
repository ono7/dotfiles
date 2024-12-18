return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  event = "InsertEnter",
  version = "v0.*",
  config = function()
    require("blink-cmp").setup({
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
      completion = {
        menu = {
          border = "rounded",
          max_height = 6,
        },
        documentation = {
          border = "rounded",
          auto_show = true,
        },
        list = {
          max_items = 50,
        },
        accept = { auto_brackets = { enabled = true } },
        trigger = { signature_help = { enabled = true } },
      },
      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "snippets", "buffer" },
        },
        providers = {
          snippets = {
            min_keyword_length = 1, -- don't show when triggered manually, useful for JSON keys
            score_offset = -1,
          },
          path = {
            opts = { get_cwd = vim.uv.cwd },
          },
          buffer = {
            fallback_for = {}, -- disable being fallback for LSP
            max_items = 4,
            min_keyword_length = 4,
            score_offset = -3,
          },
        },
      },
      signature = { enabled = true },
    })
  end,
}
