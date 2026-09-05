local create_augroup = vim.api.nvim_create_augroup
local general_group = create_augroup("GeneralAutocmds", { clear = true })

--- Manual LSP File Change Notification ---
vim.api.nvim_create_autocmd("BufWritePost", {
  group = create_augroup("LspManualNotify", { clear = true }),
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      client:notify("workspace/didChangeWatchedFiles", {
        changes = {
          {
            uri = vim.uri_from_bufnr(args.buf),
            type = 2, -- LSP Protocol: 1 = Created, 2 = Changed, 3 = Deleted
          },
        },
      })
    end
  end,
})

-- Exit term after closing, prevents exit prompt from blocking until cleared
vim.api.nvim_create_autocmd("TermClose", {
  group = general_group,
  desc = "Close terminal buffer on process exit",
  callback = function(args)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
})

-- LSP attach configuration (omnifunc and pyright venv resolution)
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = general_group,
--   callback = function(args)
--     if vim.b[args.buf].large_file == true then
--       return
--     end
--
--     vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client or client.name ~= "pyright" then
--       return
--     end
--
--     local venv = vim.env.VIRTUAL_ENV
--     if venv and venv ~= "" then
--       client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
--         python = {
--           analysis = {
--             venvPath = vim.fn.fnamemodify(venv, ":h"),
--             venv = vim.fn.fnamemodify(venv, ":t"),
--           },
--         },
--       })
--     end
--   end,
-- })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup("highlight_yanked_text", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 100 })
  end,
})

-- FileType commentstring overrides
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("ft_overrides", { clear = true }),
  pattern = { "javascript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Fix commit message editor view
vim.api.nvim_create_autocmd("BufEnter", {
  group = create_augroup("vim_commit_msg", { clear = true }),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    -- NOTE(jlima): Schedule entering insert mode to prevent subsequent event loops from resetting to normal mode.
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
  end,
})

-- Equalize window splits on terminal/UI resize
vim.api.nvim_create_autocmd("VimResized", {
  group = create_augroup("vim_resize_windows", { clear = true }),
  command = "wincmd =",
})

-- Restore cursor position on enter
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

-- Prevent auto-inserting comment leader on newline
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Automatically open quickfix list after search commands
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = "[^l]*",
  callback = function()
    vim.cmd("cwindow")
  end,
})

-- Reload snippets when .snippet files are saved
vim.api.nvim_create_autocmd("BufWritePost", {
  group = create_augroup("reload_snippets", { clear = true }),
  pattern = "*.snippet",
  command = "SnippyReload",
})

-- Scratch buffer cleanup configuration
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

-- Echo filename when switching windows/buffers
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = create_augroup("EchoFileNameOnFocus", { clear = true }),
  callback = function(args)
    if vim.fn.getcmdwintype() ~= "" then
      return
    end

    local is_normal_win = vim.api.nvim_win_get_config(0).relative == ""
    local is_normal_buf = vim.bo[args.buf].buftype == ""
    local name = vim.api.nvim_buf_get_name(args.buf)

    if is_normal_win and is_normal_buf and name ~= "" then
      vim.schedule(function()
        if vim.fn.getcmdwintype() == "" and vim.api.nvim_win_is_valid(0) and vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.cmd, "file")
        end
      end)
    end
  end,
})

-- Disable plugin splits, terminals, and fzf from running in the command-line window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = general_group,
  callback = function(args)
    local key_opts = { buffer = args.buf, nowait = true, silent = true }

    vim.keymap.set("n", "<C-f>", "<Nop>", key_opts)
    vim.keymap.set("n", "<C-t>", "<Nop>", key_opts)
    vim.keymap.set("n", "<C-v>", "<C-v>", key_opts)
    vim.keymap.set("n", "q", "<C-c>", key_opts)
  end,
})

-- Synchronize visual yanks to system clipboard
vim.opt.clipboard = ""
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup("ClipboardSync", { clear = true }),
  desc = "Copy visual yanks to system clipboard",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.visual then
      vim.fn.setreg("+", vim.fn.getreg('"'), vim.fn.getregtype('"'))
    end
  end,
})
