return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
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
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
    "onsails/lspkind.nvim",
    "windwp/nvim-autopairs",
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

    local function tooBig(bufnr)
      local max_filesize = 1000 * 1024 -- 1MB
      local check_stats = (vim.uv or vim.loop).fs_stat
      local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return true
      else
        return false
      end
    end

    local preferred_sources = {
      { name = "nvim_lsp", max_item_count = 30 },
      { name = "nvim_lsp_signature_help" },
      { name = "path", max_item_count = 10 },
      { name = "nvim_lua", max_item_count = 10 },
    }

    -- if files are too big disable buffer source
    -- other wise, enable buffer source
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpBufferDisableGrp", { clear = true }),
      callback = function(ev)
        local sources = preferred_sources
        if not tooBig(ev.buf) then
          sources[#sources + 1] = { name = "buffer", keyword_length = 4 }
        end
        cmp.setup.buffer({
          sources = cmp.config.sources(sources),
        })
      end,
    })

    -- Set up manual trigger
    -- vim.keymap.set("i", "<C-Space>", function()
    -- vim.keymap.set("i", "<c-y>", function()
    --   cmp.complete()
    -- end, { noremap = true, silent = true, desc = "Manually trigger completion" })

    -- autopairs integration
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      snippet = {
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },
      completion = {
        autocomplete = false, -- we want to test out running this manually
        -- completeopt = "menu,menuone,noinsert",
        -- completeopt = "menu,menuone,noselect",
        completeopt = "menu,menuone",
        -- keyword_pattern = [[\%(\.\|:\)\@<=\w*]],
        keyword_pattern = [[%.]],
        keyword_length = 4,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({ select = true }),
        -- ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          -- behavior = cmp.ConfirmBehavior.Insert,
          -- select = true,
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
      performance = {
        debounce = 0, -- default is 60ms
        throttle = 0, -- default is 30ms
      },
      sources = preferred_sources,
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol", -- show only symbol annotations
          maxwidth = {
            menu = 50,
            abbr = 50,
          },
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
