local create_augroup = vim.api.nvim_create_augroup

-- Top-level augroup declarations
local general_group = create_augroup("GeneralAutocmds", { clear = true })
local lsp_notify_group = create_augroup("LspManualNotify", { clear = true })
local yank_highlight_group = create_augroup("HighlightYankedText", { clear = true })
local ft_overrides_group = create_augroup("FileTypeOverrides", { clear = true })
local commit_msg_group = create_augroup("VimCommitMsg", { clear = true })
local resize_group = create_augroup("VimResizeWindows", { clear = true })
local restore_cursor_group = create_augroup("RestoreCursor", { clear = true })
local format_options_group = create_augroup("FormatOptions", { clear = true })
local quickfix_group = create_augroup("AutoOpenQuickfix", { clear = true })
local snippets_group = create_augroup("ReloadSnippets", { clear = true })
local scratch_group = create_augroup("ScratchBufConfig", { clear = true })
local echo_filename_group = create_augroup("EchoFileNameOnFocus", { clear = true })
local clipboard_sync_group = create_augroup("ClipboardSync", { clear = true })
local purge_banner_group = create_augroup("PurgeNeovideBanner", { clear = true })

--- Manual LSP File Change Notification ---
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lsp_notify_group,
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

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_highlight_group,
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 100 })
  end,
})

-- FileType commentstring overrides
vim.api.nvim_create_autocmd("FileType", {
  group = ft_overrides_group,
  pattern = { "javascript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Fix commit message editor view
vim.api.nvim_create_autocmd("BufEnter", {
  group = commit_msg_group,
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
  group = resize_group,
  command = "wincmd =",
})

-- Restore cursor position on enter
vim.api.nvim_create_autocmd("BufReadPost", {
  group = restore_cursor_group,
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
  group = format_options_group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Automatically open quickfix list after search commands
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = quickfix_group,
  pattern = "[^l]*",
  callback = function()
    local qf = vim.fn.getqflist()
    if #qf > 0 then
      vim.cmd("copen")
    else
      vim.cmd("cclose")
      print("Build successful")
    end
  end,
})

-- Reload snippets when .snippet files are saved
vim.api.nvim_create_autocmd("BufWritePost", {
  group = snippets_group,
  pattern = "*.snippet",
  command = "SnippyReload",
})

-- Scratch buffer cleanup configuration
vim.api.nvim_create_autocmd("BufEnter", {
  group = scratch_group,
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
  group = echo_filename_group,
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
  group = clipboard_sync_group,
  desc = "Copy visual yanks to system clipboard",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.visual then
      vim.fn.setreg("+", vim.fn.getreg('"'), vim.fn.getregtype('"'))
    end
  end,
})

-- NOTE(jlima): Neovide registers NeovideIntroBanner on TextChanged/TextChangedI.
-- Purge the augroup on VimEnter to eliminate insert-mode callback latency.
vim.api.nvim_create_autocmd("VimEnter", {
  group = purge_banner_group,
  callback = function()
    pcall(vim.api.nvim_del_augroup_by_name, "NeovideIntroBanner")
  end,
})

-- NOTE(jlima): Dismantle default right-click popup-menu without sacrificing mouse integration
pcall(vim.cmd, "aunmenu PopUp")
pcall(vim.api.nvim_del_augroup_by_name, "nvim.popupmenu")

vim.api.nvim_create_autocmd("FileType", {
  group = ft_overrides_group, -- or vim.api.nvim_create_augroup("GlobalCommentFormat", { clear = true })
  callback = function()
    local cs = vim.bo.commentstring
    if cs ~= "" and cs:find("%%s") then
      -- Normalize so there is always a single space surrounding %s
      -- Converts '"%s"' -> '" %s"' or '/*%s*/' -> '/* %s */'
      local normalized = cs:gsub("%s*%%s%s*", " %%s ")
      vim.bo.commentstring = vim.trim(normalized)
    end
  end,
})
