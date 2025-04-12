return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    enabled = true,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- "windwp/nvim-ts-autotag", -- typescript/js tag closer
    },
    config = function()
      -- this keeps this config from breaking when selecting up to "the end of this quote" and deleting
      -- this should be uncommented if using object motions
      -- vim.opt.selection = "exclusive"
      require("nvim-treesitter.configs").setup({
        -- sync_install = false,
        -- modules = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- use_languagetree = true,
        },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        auto_install = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- Reduce from 300KB to 100KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        ensure_installed = {
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "gowork",
          "html",
          "javascript",
          "json",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "terraform",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        incremental_selection = {
          enable = false,
          keymaps = {},
        },
        textobjects = {
          select = {
            -- this should be set, if enabled = true here
            -- vim.opt.selection = "exclusive"
            enable = false,
            -- lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = { query = "@function.outer", desc = "around a function" },
              ["if"] = { query = "@function.inner", desc = "inner part of a function" },
              ["am"] = { query = "@function.outer", desc = "around a class" },
              ["im"] = { query = "@class.inner", desc = "inner part of a class" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@parameter.inner"] = "v", -- charwise
              ["@function.outer"] = "v", -- charwise
              ["@conditional.outer"] = "V", -- linewise
            },
            include_surrounding_whitespace = false,
          },
          move = {
            enable = false,
            ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
            -- },
            ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
          },
          swap = {
            enable = false,
          },
        },
      })
    end,
  },
}
