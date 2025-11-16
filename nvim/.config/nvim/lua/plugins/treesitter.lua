return {
  -- opitimized config
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local function too_large(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        local ok, st = pcall(vim.loop.fs_stat, name)
        if ok and st and st.size > 500 * 1024 then
          vim.notify("file too large, optimizing")
          return true
        end
        return false
      end

      local function too_many_lines(buf)
        return vim.api.nvim_buf_line_count(buf) > 5000
      end

      require("nvim-treesitter.configs").setup({
        auto_install = true, -- on-demand parser installation
        ensure_installed = {}, -- empty = no manual list

        highlight = {
          enable = true,
          disable = function(_, buf)
            return too_large(buf)
          end,
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = false,
          disable = function(_, buf)
            return too_large(buf) or too_many_lines(buf)
          end,
        },

        incremental_selection = { enable = false },
        textobjects = { enable = false },
      })
    end,
  },
}
