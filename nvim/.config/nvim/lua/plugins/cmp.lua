return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  opts = {
    performance = {
      debounce = 0, -- default is 60ms
      throttle = 0, -- default is 30ms
    },
  },
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
    local lspkind = require("lspkind")
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
        format = lspkind.cmp_format({
          mode = "symbol", -- show only symbol annotations
          maxwidth = {
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
            menu = 50, -- leading text (labelDetails)
            abbr = 50, -- actual suggestion item
          },
          ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(entry, vim_item)
            -- ...
            return vim_item
          end,
        }),
      },
    })
  end,
}
