local create_augroup = vim.api.nvim_create_augroup

-- --- updates shada so that recent files can be used by Telescope oldfiles
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
--   callback = function()
--     vim.cmd("wshada")
--   end,
--   group = create_augroup("highlight_yanked_text", { clear = true }),
-- })

-- Optimize Conform.nvim for large files
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function(args)
    local bufnr = args.buf
    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- Skip formatting for large files
    local ok, stats = pcall(vim.loop.fs_stat, filename)
    if ok and stats and stats.size > (1024 * 1024) then -- 1MB
      vim.b[bufnr].disable_autoformat = true
    end

    -- Skip formatting for files with many lines
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    if line_count > 5000 then
      vim.b[bufnr].disable_autoformat = true
    end

    -- Always skip CSV files
    if filename:match("%.csv$") then
      vim.b[bufnr].disable_autoformat = true
    end
  end,
})

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

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- vim.opt.formatoptions:remove({ "c", "r", "o" })
    vim.opt.formatoptions:remove({ "c", "o", "t" })
  end,
  group = create_augroup("remove_format_options", { clear = true }),
  desc = "Disable New Line Comment",
})

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

-- this breaks harpoon
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*",
--   callback = function()
--     local dir = vim.fn.expand("%:p:h")
--     vim.cmd("silent! lcd " .. dir)
--   end,
--   group = create_augroup("set_path_lcd", { clear = true }),
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

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "text", "python", "go" },
--   callback = function()
--     vim.opt_local.wrap = true
--   end,
--   group = create_augroup("set_wrap", { clear = true }),
-- })

-------------------- detect large files -------------------------

local M = {}

-- Configure thresholds
local MAX_FILE_SIZE = 1024 * 1024 -- 1MB
local MAX_LINE_COUNT = 10000

-- Check if file is large
local function is_large_file(bufnr)
  bufnr = bufnr or 0

  -- Check file size
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return false
  end

  local ok, stats = pcall(vim.loop.fs_stat, filename)
  if ok and stats and stats.size > MAX_FILE_SIZE then
    return true
  end

  -- Check line count
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count > MAX_LINE_COUNT then
    return true
  end

  -- Check for CSV files (always treat as large)
  if filename:match("%.csv$") then
    return true
  end

  return false
end

-- Optimize buffer for large files
local function optimize_large_file(bufnr)
  bufnr = bufnr or 0

  -- Disable syntax highlighting
  vim.api.nvim_buf_set_option(bufnr, "syntax", "off")

  -- Disable treesitter for this buffer
  local ts_config = require("nvim-treesitter.configs")
  if ts_config then
    vim.api.nvim_buf_set_var(bufnr, "ts_highlight", false)
  end

  -- Disable LSP for this buffer
  vim.b[bufnr].large_file = true

  -- Disable folding
  vim.api.nvim_buf_set_option(bufnr, "foldmethod", "manual")
  vim.api.nvim_buf_set_option(bufnr, "foldenable", false)

  -- Disable swap file
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)

  -- Reduce updatetime for this buffer
  vim.api.nvim_buf_set_option(bufnr, "updatetime", 4000)

  -- Disable auto formatting
  vim.b[bufnr].disable_autoformat = true

  -- Disable colorizer
  if pcall(require, "colorizer") then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("ColorizerDetachFromBuffer")
    end)
  end

  -- Set lower synmaxcol for syntax highlighting (if any)
  vim.api.nvim_buf_set_option(bufnr, "synmaxcol", 200)

  -- Disable cursorline/cursorcolumn
  vim.api.nvim_win_set_option(0, "cursorline", false)
  vim.api.nvim_win_set_option(0, "cursorcolumn", false)

  -- Disable list mode (showing whitespace)
  vim.api.nvim_win_set_option(0, "list", false)

  vim.notify("Large file detecte\nOptimizations applied..")
end

-- vim.cmd([[
--   autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable | NoMatchParen | endif
-- ]])

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function()
    local file = vim.fn.expand("<afile>")
    local size = vim.fn.getfsize(file)

    if size > 10000000 or size == -2 then
      vim.opt_local.undofile = false
      vim.opt_local.foldenable = false

      -- Safely disable matchparen
      pcall(vim.cmd, "NoMatchParen")
    end
  end,
})

-- Setup autocmds
local function setup()
  vim.api.nvim_create_augroup("LargeFileOptimization", { clear = true })

  -- Check on buffer read
  vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    group = "LargeFileOptimization",
    callback = function(args)
      if is_large_file(args.buf) then
        optimize_large_file(args.buf)
      end
    end,
  })

  -- Also check after buffer is loaded (for lazy loading scenarios)
  vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = "LargeFileOptimization",
    callback = function(args)
      if is_large_file(args.buf) and not vim.b[args.buf].large_file then
        optimize_large_file(args.buf)
      end
    end,
  })
end

-- Manual command to optimize current buffer
vim.api.nvim_create_user_command("OptimizeLargeFile", function()
  optimize_large_file()
end, {})

-- Call setup
setup()

M.is_large_file = is_large_file
M.optimize_large_file = optimize_large_file
M.setup = setup

return M
