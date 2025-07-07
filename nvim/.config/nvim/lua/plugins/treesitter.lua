return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = false, -- Changed from true to false
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- Disable for large files and CSV files
          disable = function(lang, buf)
            local max_filesize = 1000 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end

            -- Disable for CSV files regardless of size
            local filename = vim.api.nvim_buf_get_name(buf)
            if filename:match("%.csv$") then
              return true
            end

            -- Disable for files with many lines
            local line_count = vim.api.nvim_buf_line_count(buf)
            if line_count > 10000 then
              return true
            end

            return false
          end,
        },
        indent = {
          enable = true,
          -- Same disable logic for indent
          disable = function(lang, buf)
            local max_filesize = 50 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end

            local filename = vim.api.nvim_buf_get_name(buf)
            if filename:match("%.csv$") then
              return true
            end

            local line_count = vim.api.nvim_buf_line_count(buf)
            if line_count > 5000 then
              return true
            end

            return false
          end,
        },
        context_commentstring = { enable = true, enable_autocmd = false },
        auto_install = false, -- Disable auto-install for performance
        ensure_installed = {
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "query",
          "terraform",
          "typescript",
          "vim",
          "yaml",
        },
      })
    end,
  },
}
