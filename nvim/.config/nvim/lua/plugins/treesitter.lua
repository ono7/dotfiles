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
            enable = true,
            -- lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = { query = "@function.outer", desc = "around a function" },
              ["if"] = { query = "@function.inner", desc = "inner part of a function" },
              ["a="] = { query = "@assignment.outer", desc = "select outer part of an assignment" },
              ["i="] = { query = "@assignment.inner", desc = "select inner part of an assignment" },
              ["l="] = { query = "@assignment.lhs", desc = "select left hand side of an assignment" },
              ["r="] = { query = "@assignment.rhs", desc = "select right hand side of an assignment" },
              ["am"] = { query = "@function.outer", desc = "around a class" },
              ["im"] = { query = "@class.inner", desc = "inner part of a class" },
              -- ["ac"] = { query = "@class.outer", desc = "around a class" },
              -- ["ic"] = { query = "@class.inner", desc = "inner part of a class" },
              -- ["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
              -- ["ii"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
              -- ["al"] = { query = "@loop.outer", desc = "around a loop" },
              -- ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
              -- ["ap"] = { query = "@parameter.outer", desc = "around parameter" },
              -- ["ip"] = { query = "@parameter.inner", desc = "inside a parameter" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@parameter.inner"] = "v", -- charwise
              ["@function.outer"] = "v", -- charwise
              ["@conditional.outer"] = "V", -- linewise
              -- ["@loop.outer"] = "V", -- linewise
              -- ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = false,
          },
          move = {
            enable = true,
            -- set_jumps = true, -- whether to set jumps in the jumplist
            -- goto_previous_start = {
            --   ["[f"] = { query = "@function.outer", desc = "Previous function" },
            --   ["[c"] = { query = "@call.outer", desc = "Previous class" },
            ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
            -- },
            -- goto_previous_end = {
            --   ["[F"] = { query = "@function.outer", desc = "Previous function" },
            --   ["[C"] = { query = "@call.outer", desc = "Previous class" },
            --   ["[P"] = { query = "@parameter.inner", desc = "Previous parameter" },
            -- },
            -- goto_next_start = {
            --   ["]f"] = { query = "@function.outer", desc = "Next function" },
            --   ["]c"] = { query = "@call.outer", desc = "Next class" },
            ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
            -- },
            -- goto_next_end = {
            --   ["]F"] = { query = "@function.outer", desc = "Next function" },
            --   ["]C"] = { query = "@call.outer", desc = "Next class" },
            --   ["]P"] = { query = "@parameter.inner", desc = "Next parameter" },
            -- },
          },
          swap = {
            enable = false,
          },
        },
      })
    end,
  },
}
