local create_augroup = vim.api.nvim_create_augroup

--- exit term after closing, prevents exit prompt from blocking until cleared
vim.api.nvim_create_autocmd("TermClose", {
  desc = "Close terminal buffer on process exit",
  callback = function(args)
    -- Only close if the process exited successfully (code 0)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- if vim.bo[args.buf].large_file == true then
    --   return
    -- end
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "pyright" then
      return
    end

    local venv = vim.env.VIRTUAL_ENV
    if not venv or venv == "" then
      return
    end

    client.settings = client.settings or {}
    client.settings.python = client.settings.python or {}
    client.settings.python.analysis = vim.tbl_extend("force", client.settings.python.analysis or {}, {
      venvPath = vim.fn.fnamemodify(venv, ":h"),
      venv = vim.fn.fnamemodify(venv, ":t"),
    })
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
    vim.hl.on_yank({
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

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = "[^l]*", -- Matches :make, :grep, but NOT :lmake
  callback = function()
    vim.cmd("cwindow") -- Opens window only if there are valid errors
  end,
})

-- auto source snippets file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.snippet",
  command = [[:SnippyReload<CR>]],
  group = create_augroup("reload_snippets", { clear = true }),
})

-- auto create dirs when saving files: use :w ++p

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
