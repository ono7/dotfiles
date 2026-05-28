return {
  "tpope/vim-fugitive",
  config = function()
    vim.cmd([[hi! diffAdded ctermfg=188 ctermbg=64 cterm=bold guifg=#50FA7B guibg=NONE gui=bold]])
    vim.cmd([[hi! diffRemoved ctermfg=88 ctermbg=NONE cterm=NONE guifg=#FA5057 guibg=NONE gui=NONE]])

    vim.keymap.set("n", "<leader>g", "<cmd>G<CR>", {
      silent = true,
      desc = "Launch fugitive",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fugitive",
      callback = function(event)
        -- Buffer-local keymap to close the window
        vim.keymap.set("n", "<C-/>", "<cmd>close<CR>", {
          buffer = event.buf,
          silent = true,
          desc = "Close Fugitive window",
        })
      end,
    })
  end,
}
