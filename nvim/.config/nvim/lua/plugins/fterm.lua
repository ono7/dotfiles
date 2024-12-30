return {
  "numtostr/fterm.nvim",
  opts = {},
  config = function()
    local binding = vim.g.neovide and "<D-/>" or "<C-_>"

    require("FTerm").setup({
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })
    vim.keymap.set("n", binding, '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
    vim.keymap.set("t", binding, '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
  end,
}
