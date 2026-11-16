return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
  opts = function()
    return {
      window = {
        open = "alternate",
      },
      hooks = {
        -- Updated to use the single 'opts' table
        post_open = function(opts)
          -- Safely check if the window is valid before moving the cursor
          if opts.winnr and vim.api.nvim_win_is_valid(opts.winnr) then
            vim.api.nvim_set_current_win(opts.winnr)
          end

          if opts.is_blocking then
            -- Programmatically trigger your <C-/> keymap to hide the terminal
            local key = vim.api.nvim_replace_termcodes("<C-/>", true, false, true)
            vim.api.nvim_feedkeys(key, "n", false)
          end
        end,

        -- Updated to use the single 'opts' table
        block_end = function(opts)
          vim.schedule(function()
            vim.cmd("T")
          end)
        end,
      },
    }
  end,
}
