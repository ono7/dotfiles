return {
  "onsails/lspkind.nvim",

  config = function()
    -- setup() is also available as an alias
    require("lspkind").setup({
      -- DEPRECATED (use mode instead): enables text annotations
      --
      -- default: true
      -- with_text = true,

      -- defines how annotations are shown
      -- default: symbol
      -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
      -- mode = "symbol_text",
      mode = "symbol",

      -- default symbol map
      -- can be either 'default' (requires nerd-fonts font) or
      -- 'codicons' for codicon preset (requires vscode-codicons font)
      --
      -- default: 'default'
      preset = "codicons",

      -- override preset symbols
      --

      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "󰒓",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "󱡠",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰬲",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰬛",
      },
      -- kind_icons = {
      --   Text = '󰉿',
      --   Method = '󰊕',
      --   Function = '󰊕',
      --   Constructor = '󰒓',
      --
      --   Field = '󰜢',
      --   Variable = '󰆦',
      --   Property = '󰖷',
      --
      --   Class = '󱡠',
      --   Interface = '󱡠',
      --   Struct = '󱡠',
      --   Module = '󰅩',
      --
      --   Unit = '󰪚',
      --   Value = '󰦨',
      --   Enum = '󰦨',
      --   EnumMember = '󰦨',
      --
      --   Keyword = '󰻾',
      --   Constant = '󰏿',
      --
      --   Snippet = '󱄽',
      --   Color = '󰏘',
      --   File = '󰈔',
      --   Reference = '󰬲',
      --   Folder = '󰉋',
      --   Event = '󱐋',
      --   Operator = '󰪚',
      --   TypeParameter = '󰬛',
    })
  end,
}
