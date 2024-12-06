return {

    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    {"dcampos/nvim-snippy",
      config = function () 
      local snippy = require "snippy"
      snippy.setup({
        snippet_dirs = '~/.config/nvim/snippets',
        -- scopes = {
        --   _ = {},
        --   markdown = { "markdown" },
        -- },
        mappings = {
          is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
          },
          x = {
            ['<leader>d'] = 'cut_text',
          },
        },
      })
      end
    },
  }
}
