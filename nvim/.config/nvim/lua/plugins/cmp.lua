return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local snippy = require("snippy")
    snippy.setup({
      snippet_dirs = "~/.config/nvim/snippets",
      mappings = {
        is = {
          ["<Tab>"] = "expand_or_advance",
          ["<S-Tab>"] = "previous",
        },
        x = {
          ["<leader>d"] = "cut_text",
        },
      },
    })

    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }
    cmp.setup({
      snippet = {
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_pattern = [[\%(\.\|:\)\@<=\w*]],
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if snippy.can_jump(-1) then
            snippy.previous()
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = {
        -- { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "tmux" },
      },
      formatting = {
        format = function(entry, vim_item)
          local lspkind_ok, lspkind = pcall(require, "lspkind")
          if not lspkind_ok then
            -- From kind_icons array
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            -- Source
            vim_item.menu = ({
              -- copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              -- latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          else
            -- From lspkind
            return lspkind.cmp_format()(entry, vim_item)
          end
        end,
      },
    })
  end,
}
