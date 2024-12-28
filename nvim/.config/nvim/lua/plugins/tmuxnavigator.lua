return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local prefix = function(s)
      local c = vim.g.neovide and "D" or "C"
      return string.format("<%s-%s>", c, s)
    end

    --- in tmux install tpm plugin and run c-b + I (capital I) ---
    --- this is usefull even outside of tmux.... probably should keep it around
    local nvim_tmux_nav = require("nvim-tmux-navigation")

    nvim_tmux_nav.setup({
      disable_when_zoomed = true, -- defaults to false
    })

    vim.keymap.set("n", prefix("h"), nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set("n", prefix("j"), nvim_tmux_nav.NvimTmuxNavigateDown)
    vim.keymap.set("n", prefix("k"), nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set("n", prefix("l"), nvim_tmux_nav.NvimTmuxNavigateRight)
  end,
}
