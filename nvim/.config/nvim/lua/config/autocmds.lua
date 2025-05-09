local create_augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 100,
    })
  end,
  group = create_augroup("highlight_yanked_text", { clear = true }),
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*.js",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescriptreact",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- fix commit msg, goto top of file on enter
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = create_augroup("vim_commit_msg", { clear = true }),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    -- vim.cmd('startinsert')
  end,
})

-- resize windows

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  command = [[:wincmd =]],
  group = create_augroup("vim_resize_windows_automatically", { clear = true }),
})

-- restore cursor position on enter
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match("commit") and ft:match("rebase"))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "x", false)
        end
      end,
    })
  end,
  group = create_augroup("restore_cursor_position_on_enter", { clear = true }),
})

-- redundant
-- vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
-- vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=co]] })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     -- vim.opt.formatoptions:remove({ "c", "r", "o" })
--     vim.opt.formatoptions:remove({ "c", "o" })
--   end,
--   group = create_augroup("remove_format_options", { clear = true }),
--   desc = "Disable New Line Comment",
-- })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "venv", "static/html", "static/pico", "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
  group = create_augroup("disable_lsp_diags_for_folders", { clear = true }),
})

vim.cmd([[
augroup _QuickFixOpen
	autocmd!
	" auto open quickfix when executing make!
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup END
]])

-- auto source snippets file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.snippet",
  command = [[:SnippyReload<CR>]],
  group = create_augroup("reload_snippets", { clear = true }),
})

-- auto create dirs when saving files: use :w ++p

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    vim.cmd("silent! lcd " .. dir)
  end,
  group = create_augroup("set_path_lcd", { clear = true }),
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd("startinsert!")
  end,
  group = create_augroup("set_buf_number_options", { clear = true }),
  desc = "Terminal Options",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text", "python", "go" },
  callback = function()
    vim.opt_local.wrap = true
  end,
  group = create_augroup("set_wrap", { clear = true }),
})

-- python ruff fix imports on write
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.py" },
--   group = vim.api.nvim_create_augroup("buf_write_post_ruff_fix_format_sort", { clear = true }),
--   callback = function()
--     -- fixAll
--     if vim.bo.filetype == "python" then
--       vim.lsp.buf.code_action({
--         context = {
--           only = { "source.fixAll.ruff" },
--         },
--         apply = true,
--       })
--     end
--     -- format
--     vim.lsp.buf.format({ async = vim.bo.filetype ~= "python" })
--     -- organizeImports
--     if vim.bo.filetype == "python" then
--       vim.lsp.buf.code_action({
--         context = {
--           only = { "source.organizeImports.ruff" },
--         },
--         apply = true,
--       })
--     end
--   end,
-- })
