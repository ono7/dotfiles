local create_augroup = vim.api.nvim_create_augroup

-- Optimize Conform.nvim for large files
-- vim.api.nvim_create_autocmd({ "BufReadPre" }, {
--   group = create_augroup("optimize_large_files", { clear = true }),
--   callback = function(args)
--     local bufnr = args.buf
--     local filename = vim.api.nvim_buf_get_name(bufnr)
--
--     -- Skip formatting for large files
--     local ok, stats = pcall(vim.loop.fs_stat, filename)
--     if ok and stats and stats.size > (1024 * 1024) then -- 1MB
--       vim.b[bufnr].disable_autoformat = true
--     end
--
--     -- Skip formatting for files with many lines
--     local line_count = vim.api.nvim_buf_line_count(bufnr)
--     if line_count > 5000 then
--       vim.b[bufnr].disable_autoformat = true
--     end
--
--     -- Always skip CSV files
--     if filename:match("%.csv$") then
--       vim.b[bufnr].disable_autoformat = true
--     end
--   end,
-- })

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
  group = create_augroup("js_comment_string_add", { clear = true }),
  pattern = "javascript",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("ts_comment_string_add", { clear = true }),
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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   pattern = { ".venv", "venv", "static/html", "static/pico", "**/node_modules/**", "node_modules", "/node_modules/*" },
--   callback = function()
--     vim.diagnostic.enable(false)
--   end,
--   group = create_augroup("disable_lsp_diags_for_folders", { clear = true }),
-- })

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

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd("startinsert!")
  end,
  group = create_augroup("set_buf_number_options", { clear = true }),
  desc = "Terminal Options",
})

local MAX_FILE_SIZE = 1024 * 1024 -- 1MB

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("OptimizeBuffer", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" then
      return
    end

    local ok, stats = pcall(vim.loop.fs_stat, filename)
    local is_large = ok and stats and stats.size > MAX_FILE_SIZE or filename:match("%.csv$")

    if not is_large then
      return
    end

    -- Buffer-local optimizations
    vim.bo[bufnr].syntax = "off"
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].undofile = false
    vim.bo[bufnr].synmaxcol = 200
    vim.b[bufnr].disable_autoformat = true
    vim.b[bufnr].large_file = true
    vim.b[bufnr].lsp_ignore = true -- optional but very helpful

    -- Prevent expensive filetype plugins
    vim.cmd("setlocal eventignore+=FileType")

    -- Window-local optimizations
    vim.schedule(function()
      local win = vim.fn.bufwinid(bufnr)
      if win ~= -1 then
        vim.wo[win].foldmethod = "manual"
        vim.wo[win].foldenable = false
      end

      -- Stop Treesitter
      pcall(vim.treesitter.stop, bufnr)

      -- Disable diagnostics
      vim.diagnostic.enable(false, { bufnr = bufnr })

      vim.notify("File optimizations applied.", vim.log.levels.INFO)
    end)
  end,
})
