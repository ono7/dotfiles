return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "markdown", "markdown_inline" },
      },
    },
  },
  opts = {
    keymap = {
      preset = "super-tab",
      -- ["<C-y>"] = { "show", "fallback" },
      ["<c-y>"] = { "show_and_insert", "accept", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    -- trigger = { mode = "manual" },
    completion = {
      trigger = {
        show_on_keyword = false,
        show_on_trigger_character = false,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        treesitter_highlighting = true, -- disable this if there is any stuttering or performance issues
        window = { border = "rounded" },
      },
      menu = {
        auto_show = false,
        draw = {
          -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true, -- Changed from true to false
        },
      },
    },
    cmdline = { enabled = false },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
