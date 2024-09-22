-- TODO: migrate this to modules

-- local function check_buf(bufnr)
--   --- checks if this is a valid buffer that we can save to ---
--   local bufname = vim.api.nvim_buf_get_name(bufnr)
--   if bufname == '' then
--     return false
--   end
--   return true
-- end
--
-- local function clean_space_save()
--   if not check_buf(0) then
--     print("save me first!")
--     return
--   end
--   local save_cursor = vim.fn.getcurpos()
--   -- Fixes ^M chars from Windows copy-pastes and removes trailing spaces
--   vim.cmd([[%s/\v\s*\r+$|\s+$//e]])
--   vim.cmd([[:write]])
--   vim.fn.setpos('.', save_cursor)
--   -- this is now handled by conform.nvim
-- end

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
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  },
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function() require "plugins.conform" end
  },
  "onsails/lspkind-nvim",
  "Glench/Vim-Jinja2-Syntax",
  {
    "monkoose/matchparen.nvim",
    config = function()
      require('matchparen').setup({
        on_startup = true,           -- Should it be enabled by default
        hl_group = 'MatchParen',     -- highlight group of the matched brackets
        augroup_name = 'matchparen', -- almost no reason to touch this unless there is already augroup with such name
        debounce_time = 20,          -- debounce time in milliseconds for rehighlighting of brackets.
      })
    end
  },
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
      --- in tmux install tpm plugin and run c-b + I (capital I) ---
      --- this is usefull even outside of tmux.... probably should keep it around
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
      vim.keymap.set("n", "<C-_>", '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
      vim.keymap.set("t", "<C-_>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
        { noremap = true, silent = true })
    end
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
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

})
