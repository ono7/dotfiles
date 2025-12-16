return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local nv = require("utils.keys").prefix
    --- in tmux install tpm plugin and run c-b + I (capital I) ---
    --- this is usefull even outside of tmux.... probably should keep it around
    local nvim_tmux_nav = require("nvim-tmux-navigation")

    nvim_tmux_nav.setup({
      disable_when_zoomed = true, -- defaults to false
    })

    vim.keymap.set("t", "<c-h>", function()
      vim.cmd.stopinsert()
      nvim_tmux_nav.NvimTmuxNavigateLeft()
    end)
    vim.keymap.set("t", "<c-j>", function()
      vim.cmd.stopinsert()
      nvim_tmux_nav.NvimTmuxNavigateDown()
    end)
    -- vim.keymap.set("t", "<c-k>", function()
    --   vim.cmd.stopinsert()
    --   nvim_tmux_nav.NvimTmuxNavigateUp()
    -- end)
    vim.keymap.set("t", "<c-l>", function()
      vim.cmd.stopinsert()
      nvim_tmux_nav.NvimTmuxNavigateRight()
    end)
    -- else
    vim.keymap.set("n", "<c-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set("n", "<c-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    -- vim.keymap.set("n", "<c-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set("n", "<c-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    -- end
  end,
}
