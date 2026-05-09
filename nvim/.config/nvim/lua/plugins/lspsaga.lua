-- Prerequisite: :TSInstall markdown markdown_inline

return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lspsaga").setup({
      hover = {
        max_width = 0.9,
        max_height = 0.8,
        open_link = "gx",
        open_cmd = "!chrome",
      },
      ui = {
        border = "rounded",
      },
    })

    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true, desc = "Lspsaga Hover Doc" })
    vim.keymap.set(
      "n",
      "<C-f>",
      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>",
      { silent = true, desc = "Scroll Down Hover" }
    )
    vim.keymap.set(
      "n",
      "<C-b>",
      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>",
      { silent = true, desc = "Scroll Up Hover" }
    )
  end,
}
