return {
  'saghen/blink.cmp',
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<D-p>'] = { 'select_prev', 'fallback' },
      ['<D-n>'] = { 'select_next', 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      documentation = { auto_show = true },
      menu = { auto_show = false } -- This disables automatic completion, use manual trigger
    },
    sources = {
      -- default = { 'lsp', 'path', 'snippets', 'buffer' },
      default = { 'lsp', 'path' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
