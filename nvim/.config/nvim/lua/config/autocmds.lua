local create_augroup = vim.api.nvim_create_augroup

-- LSP omnifunc
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})

-- Fallback omni for non-LSP buffers
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf

    -- Don't override LSP
    if next(vim.lsp.get_clients({ bufnr = buf })) ~= nil then
      return
    end

    -- Only fallback if nothing is set by the ftplugin
    if vim.bo[buf].omnifunc == "" then
      vim.bo[buf].omnifunc = "syntaxcomplete#Complete"
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

-- open quickfix list automatically when there are items in it
-- this is now hadled automatically by quicker.nvim plugin
-- vim.cmd([[
-- augroup _QuickFixOpen
--   autocmd!
--   autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
--   autocmd QuickFixCmdPost [^l]* cwindow 6
--   autocmd QuickFixCmdPost    l* lwindow 6
-- augroup END
-- ]])

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
    vim.opt_local.statuscolumn = ""
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert!")
  end,
  group = create_augroup("set_buf_number_options", { clear = true }),
  desc = "Terminal Options",
})

-- local MAX_FILE_SIZE = 1024 * 1024 -- 1MB (1 MiB)
--
-- -- Create or clear the AutoGroup
-- local group_id = vim.api.nvim_create_augroup("OptimizeBuffer", { clear = true })
--
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
--   group = group_id,
--   callback = function(args)
--     local bufnr = args.buf
--     local filename = vim.api.nvim_buf_get_name(bufnr)
--
--     if filename == "" or vim.b[bufnr].large_file then
--       return -- Skip if no name or already optimized
--     end
--
--     local is_large = false
--
--     -- 1. Check for CSV filetype (fast path)
--     if filename:match("%.csv$") then
--       is_large = true
--     else
--       -- 2. Check file size using pcall for safety
--       local ok, stats = pcall(vim.loop.fs_stat, filename)
--       if ok and stats and stats.size then
--         is_large = stats.size > MAX_FILE_SIZE
--       end
--     end
--
--     if not is_large then
--       return -- Not a large file, exit
--     end
--
--     -- --- Apply Buffer-Local Optimizations (Synchronous) ---
--
--     vim.bo[bufnr].syntax = "off"
--     vim.bo[bufnr].swapfile = false
--     vim.bo[bufnr].undofile = false
--     vim.bo[bufnr].synmaxcol = 200
--     vim.b[bufnr].disable_autoformat = true
--     vim.b[bufnr].large_file = true -- Mark as optimized
--     vim.b[bufnr].lsp_ignore = true
--
--     if pcall(require, "matchparen") then
--       require("matchparen").disable(bufnr)
--     end
--
--     -- --- Apply Window-Local/Async Optimizations (Scheduled) ---
--     -- Must be scheduled to run *after* the current event finishes
--
--     vim.schedule(function()
--       local win = vim.fn.bufwinid(bufnr)
--       if win ~= -1 then
--         vim.wo[win].foldmethod = "manual"
--         vim.wo[win].foldenable = false
--       end
--
--       -- Stop Treesitter
--       pcall(vim.treesitter.stop, bufnr)
--
--       -- Disable diagnostics
--       vim.diagnostic.enable(false, { bufnr = bufnr })
--
--       vim.notify("Large file optimizations applied.", vim.log.levels.INFO)
--     end)
--   end,
-- })

-- Cache of project roots we've already entered this session
local seen_projects = {}

local function find_git_root(path)
  local dir = vim.fn.fnamemodify(path, ":p:h")
  local prev = ""
  while dir ~= prev do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      return dir
    end
    prev = dir
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == "" then
      return
    end

    local root = find_git_root(file)
    if not root then
      return
    end

    -- Only do this once per project per session
    if seen_projects[root] then
      return
    end
    seen_projects[root] = true

    -- Window-local directory change
    vim.cmd("lcd " .. vim.fn.fnameescape(root))
  end,
})

-- make scratch buffer more managable, this keeps fzflua from sending files that
-- have been picked to the buffer list, instead they take stage
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    -- Only target [No Name] buffers
    if vim.api.nvim_buf_get_name(buf) ~= "" then
      return
    end

    -- Make it a true scratch buffer
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].swapfile = false -- don't create swapfiles
    vim.bo[buf].modified = false -- NEVER marked modified
  end,
})
