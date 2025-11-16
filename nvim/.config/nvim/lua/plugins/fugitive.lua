return {
  "tpope/vim-fugitive",
  config = function()
    vim.cmd([[hi! diffAdded ctermfg=188 ctermbg=64 cterm=bold guifg=#50FA7B guibg=NONE gui=bold]])
    vim.cmd([[hi! diffRemoved ctermfg=88 ctermbg=NONE cterm=NONE guifg=#FA5057 guibg=NONE gui=NONE]])
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "fugitive",
    --   callback = function()
    --     vim.opt_local.cmdheight = 2
    --   end,
    -- })
  end,
}
