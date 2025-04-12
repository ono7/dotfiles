return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- this should be uncommented if using object motions
      -- vim.opt.selection = "exclusive"
      require("nvim-treesitter.configs").setup({
        sync_install = true,
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
      })
    end,
  },
}
