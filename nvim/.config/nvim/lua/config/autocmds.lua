local create_augroup = vim.api.nvim_create_augroup
local general_group = create_augroup("GeneralAutocmds", { clear = true })

--- exit term after closing, prevents exit prompt from blocking until cleared
vim.api.nvim_create_autocmd("TermClose", {
  group = general_group,
  desc = "Close terminal buffer on process exit",
  callback = function(args)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = general_group,
  callback = function(args)
    -- We want to PROCEED if it's NOT a large file
    if vim.b[args.buf].large_file == true then
      return
    end

    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "pyright" then
      return
    end

    local venv = vim.env.VIRTUAL_ENV
    if venv and venv ~= "" then
      client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
        python = {
          analysis = {
            venvPath = vim.fn.fnamemodify(venv, ":h"),
            venv = vim.fn.fnamemodify(venv, ":t"),
          },
        },
      })
    end
  end,
})

-- Fallback omni for non-LSP buffers
vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  callback = function(args)
    -- Use vim.lsp.get_clients instead of get_active_clients (deprecated)
    if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
      return
    end

    if vim.bo[args.buf].omnifunc == "" then
      vim.bo[args.buf].omnifunc = "syntaxcomplete#Complete"
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup("highlight_yanked_text", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 100 })
  end,
})

-- Combined FileType overrides
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("ft_overrides", { clear = true }),
  pattern = { "javascript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- fix commit msg, goto top of file on enter
vim.api.nvim_create_autocmd("BufEnter", {
  group = create_augroup("vim_commit_msg", { clear = true }),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = create_augroup("vim_resize_windows", { clear = true }),
  command = "wincmd =",
})

-- restore cursor position on enter
vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_augroup("restore_cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = "[^l]*",
  callback = function()
    vim.cmd("cwindow")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = create_augroup("reload_snippets", { clear = true }),
  pattern = "*.snippet",
  command = "SnippyReload", -- Removed <CR> as it's not needed in 'command'
})

-- Git root detection (lcd)
local seen_projects = {}
local function find_git_root(path)
  return vim.fs.root(path, ".git")
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_augroup("project_root_lcd", { clear = true }),
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" or path:match("term://") then
      return
    end

    local root = find_git_root(path)
    if root and not seen_projects[root] then
      seen_projects[root] = true
      vim.cmd("lcd " .. vim.fn.fnameescape(root))
    end
  end,
})

-- Scratch buffer management
vim.api.nvim_create_autocmd("BufEnter", {
  group = create_augroup("scratch_buf_config", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
      vim.bo[buf].bufhidden = "hide"
      vim.bo[buf].swapfile = false
      vim.bo[buf].modified = false
    end
  end,
})
