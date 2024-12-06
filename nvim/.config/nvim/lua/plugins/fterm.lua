return {
    "numtostr/fterm.nvim",
    opts = {},
    config = function()
      require('FTerm').setup {
        dimensions = {
          height = 0.9,
          width = 0.9,
        }
      }
      vim.keymap.set("n", "<C-_>", '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
      vim.keymap.set("t", "<C-_>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
        { noremap = true, silent = true })
    end
}
