return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local set_keys = require("utils.keys")
    --- in tmux install tpm plugin and run c-b + I (capital I) ---
    --- this is usefull even outside of tmux.... probably should keep it around
    local nvim_tmux_nav = require("nvim-tmux-navigation")

    nvim_tmux_nav.setup({
      disable_when_zoomed = true, -- defaults to false
    })

    vim.keymap.set("n", set_keys.prefix("h"), nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set("n", set_keys.prefix("j"), nvim_tmux_nav.NvimTmuxNavigateDown)
    vim.keymap.set("n", set_keys.prefix("k"), nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set("n", set_keys.prefix("l"), nvim_tmux_nav.NvimTmuxNavigateRight)
  end,
}
