-- local c = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

local function branch_name()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  if branch ~= "" then
    return branch
  else
    return ""
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local buf_size = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if buf_size == nil then
      return -- file is empty
    end
    -- disable LSP for files larger than 1MB 1,000,000 bytes
    local buf_size_mb = string.format("%.2f", buf_size.size / 1024 / 1024)
    if buf_size.size > 1000000 then
      vim.defer_fn(function()
        vim.b.disable_autoformat = true
        vim.lsp.stop_client(vim.lsp.get_clients())
        print("large file detected.. lsp disabled: ", buf_size_mb, "MB")
      end, 400)
      -- 400 ms
    end
  end,
  group = create_augroup("large_files", { clear = true }),
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "FocusGained" }, {
  callback = function()
    vim.b.branch_name = branch_name()
  end,
  group = create_augroup("git_branch_name", { clear = true }),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 50,
    })
  end,
  group = create_augroup("highlight_yanked_text", { clear = true }),
})

-- -- Turn off diagnostics for .env files
-- c({ "BufRead", "BufNewFile" }, {
--   pattern = ".env",
--   group = create_augroup("dotenv_disabled_diagnostics", { clear = true }),
--   callback = function(context)
--     vim.diagnostic.enable(false, ...)
--   end,
-- })

-- fix commit msg, goto top of file on enter
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = create_augroup("vim_commit_msg", { clear = true }),
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = false
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
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

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  group = create_augroup("remove_format_options", { clear = true }),
  desc = "Disable New Line Comment",
})

-- AUTO-COMMANDS:
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "static/html", "static/pico", "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
  group = create_augroup("disable_lsp_diags_for_folders", { clear = true }),
})

vim.cmd [[
augroup _QuickFixOpen
	autocmd!
	" auto open quickfix when executing make!
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup END
]]

-- auto source snippets file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.snippet",
  command = [[:SnippyReload<CR>]],
  group = create_augroup("reload_snippets", { clear = true }),
})

-- auto create dirs when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    -- Check if the filetype is NOT oil
    if vim.opt.filetype ~= "oil" then
      vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ":p:h"), "p")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = create_augroup("remove_trailing_empty_line", { clear = true }),
  pattern = { "*" },
  callback = function()
    local lastLine = vim.fn.line('$')
    local lastNonblankLine = vim.fn.prevnonblank(lastLine)
    if lastLine > 0 and lastNonblankLine ~= lastLine then
      vim.cmd(string.format("%d,%ddelete _", lastNonblankLine + 1, lastLine))
    end
  end,
})

-- vim.api.nvim_create_autocmd("FocusGained", {
--   callback = function()
--     vim.cmd("checktime")
--   end,
--   group = create_augroup("update_file_when_changes_detected", { clear = true }),
--   desc = "Update file when there are changes",
-- })

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd("startinsert!")
  end,
  group = create_augroup("set_buf_number_options", { clear = true }),
  desc = "Terminal Options",
})
