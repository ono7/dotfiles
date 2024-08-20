local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "tpope/vim-fugitive",
    config = function()
      vim.cmd [[hi! diffAdded ctermfg=188 ctermbg=64 cterm=bold guifg=#50FA7B guibg=NONE gui=bold]]
      vim.cmd [[hi! diffRemoved ctermfg=88 ctermbg=NONE cterm=NONE guifg=#FA5057 guibg=NONE gui=NONE]]
    end
  },
  -- replace this with conform.nvim
  -- { "nvimtools/none-ls.nvim",    config = function() require "plugins.null_ls" end },
  -- {
  --   'stevearc/conform.nvim',
  --   opts = {},
  --   config = function() require "plugins.conform" end
  -- },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>w",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = {
          "luafmt",
          lsp_format = "fallback",
          inherit = false,
          command = "shfmt",
          args = { "-i", "2", "-filename", "$FILENAME" }
        },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "mdformat" }, -- preserves line wraps...
        -- goimports drop in replacement for gofmt
        go = { "goimports", "goimports-reviser" },
        graphql = { "prettier", stop_after_first = true },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        mdformat = {
          prepend_args = { "--number" },
        },
      },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    }
  },
  "onsails/lspkind-nvim",
  "Glench/Vim-Jinja2-Syntax",
  -- keep just incase...
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function() require "themes.gruvbox" end
  -- },
  {
    "kylechui/nvim-surround",
    config = function() require "plugins.surround" end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require "plugins.harpoon" end
  },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
      }

      vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    end
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "thehamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function() require "plugins.dap" end
  },
  { "NvChad/nvim-colorizer.lua", config = function() require "plugins.colorizer" end },
  { "sindrets/diffview.nvim",    dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function() require "plugins.lsp.mason" end
      },
      { "williamboman/mason-lspconfig.nvim" },
    },
  },
  {
    "numtostr/fterm.nvim",
    opts = {},
    config = function()
      require('FTerm').setup {
        dimensions = {
          height = 0.9,
          width = 0.9,
        }
      }
      vim.keymap.set("n", "<m-/>", '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
      vim.keymap.set("t", "<m-/>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
        { noremap = true, silent = true })
    end
  },
  {
    "f-person/git-blame.nvim",
    config = function()
      vim.g.gitblame_date_format = [[%m/%d/%Y]]
      vim.g.gitblame_message_template = [[<author> • <date> • <summary> • <sha>]]
      require('gitblame').setup {
        enabled = false,
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "dcampos/nvim-snippy", -- configured in lsp
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function() require "plugins.lsp.cmp" end
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function() require "plugins.gitsigns" end
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require "plugins.telescope" end
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'make' -- linux, macos (requires gcc,clang,make)
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function() require "plugins.treesitter" end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        max_lines = 1,
      })
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require "plugins.oil" end
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("gopher").setup()
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end
  },
  "folke/neodev.nvim",
}, {})
