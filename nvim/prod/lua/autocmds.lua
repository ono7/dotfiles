local core_group = vim.api.nvim_create_augroup("CoreSystemAutoCmds", { clear = true })
local quickfix_group = vim.api.nvim_create_augroup("quickfixGroup", { clear = true })

-- NOTE(jlima): enforces formatoptions deterministically against runtime ftplugin overrides
vim.api.nvim_create_autocmd("FileType", {
	group = core_group,
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions = "qlj"
	end,
})

-- NOTE(jlima): buffer-local bracket navigation for quickfix to preserve normal j/k line motions
vim.api.nvim_create_autocmd("FileType", {
	group = core_group,
	pattern = "qf",
	callback = function(args)
		vim.keymap.set(
			"n",
			"<M-j>",
			"<cmd>cnext<CR>",
			{ buffer = args.buf, silent = true, desc = "Next quickfix entry" }
		)
		vim.keymap.set(
			"n",
			"<M-k>",
			"<cmd>cprev<CR>",
			{ buffer = args.buf, silent = true, desc = "Previous quickfix entry" }
		)
		vim.keymap.set("n", "<CR>", "<CR>", { buffer = args.buf, desc = "Jump to quickfix entry" })
	end,
})

-- FileType Indentation Rules
vim.api.nvim_create_autocmd("FileType", {
	group = core_group,
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = core_group,
	pattern = {
		"typescript",
		"javascript",
		"markdown",
		"typescriptreact",
		"javascriptreact",
		"json",
		"yaml",
		"yml",
		"sh",
		"bash",
		"zsh",
		"jinja",
		"jinja2",
	},
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = core_group,
	pattern = { "go", "make" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false
	end,
})

-- Large File Handling & Buffer Position Restore
vim.api.nvim_create_autocmd("BufReadPre", {
	group = core_group,
	callback = function(args)
		local size = vim.fn.getfsize(args.file)
		if size > 10000000 then
			vim.b[args.buf].large_file = true
			vim.opt_local.undofile = false
			vim.opt_local.foldenable = false
			vim.cmd("syntax off")
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = core_group,
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 1 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Trailing Whitespace Cleanup
vim.api.nvim_create_autocmd("BufWritePre", {
	group = core_group,
	callback = function(args)
		if vim.b[args.buf].large_file or vim.api.nvim_buf_line_count(args.buf) >= 5000 then
			return
		end
		local save = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(save)
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = core_group,
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- Cmdline Window Sanity
vim.api.nvim_create_autocmd("CmdwinEnter", {
	group = core_group,
	callback = function(args)
		local kopts = { buffer = args.buf, nowait = true, silent = true }
		vim.keymap.set("n", "<C-f>", "<Nop>", kopts)
		vim.keymap.set("n", "<C-t>", "<Nop>", kopts)
		vim.keymap.set("n", "<C-v>", "<C-v>", kopts)
		vim.keymap.set("n", "q", "<C-c>", kopts)
		-- NOTE(jlima): restore native <CR> execution overridden by global <C-m> mapping
		vim.keymap.set("n", "<CR>", "<CR>", { buffer = args.buf })
	end,
})

-- Dynamic Diff Mode Hook
vim.api.nvim_create_autocmd("OptionSet", {
	group = core_group,
	pattern = "diff",
	callback = function()
		local is_diff = vim.opt_local.diff:get()
		if is_diff then
			vim.opt_local.signcolumn = "no"
			vim.opt_local.foldcolumn = "0"
			vim.opt_local.numberwidth = 1
			vim.opt_local.number = true
			vim.opt_local.wrap = false

			vim.keymap.set("n", "]", "]c", { buffer = true, desc = "Next diff hunk" })
			vim.keymap.set("n", "[", "[c", { buffer = true, desc = "Prev diff hunk" })
			vim.keymap.set("n", "dp", "<cmd>diffput<CR>", { buffer = true, desc = "Diff Put" })
			vim.keymap.set("n", "dg", "<cmd>diffget<CR>", { buffer = true, desc = "Diff Get" })
		else
			vim.opt_local.signcolumn = "auto"
			vim.opt_local.foldcolumn = "0"
			vim.opt_local.numberwidth = 2
			vim.opt_local.number = true

			pcall(vim.keymap.del, "n", "]", { buffer = true })
			pcall(vim.keymap.del, "n", "[", { buffer = true })
			pcall(vim.keymap.del, "n", "dp", { buffer = true })
			pcall(vim.keymap.del, "n", "dg", { buffer = true })
		end
	end,
})

-- Terminal Buffer State
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
	group = core_group,
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.opt_local.statusline = "%#Normal# "
		end
	end,
})

-- Quickfix Window Lifecycle
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = quickfix_group,
	pattern = "[^l]*",
	nested = true,
	callback = function()
		-- NOTE(jlima): Query list size directly to avoid allocating full item dictionaries
		local qf_count = vim.fn.getqflist({ size = 0 }).size
		if qf_count > 0 then
			vim.cmd("copen")
			-- NOTE(jlima): :cc jumps current window to entry 1; focus stays in code buffer
			vim.cmd("wincmd p")
			pcall(vim.cmd, "cc 1")
		else
			vim.cmd("cclose")
			print("Build complete..")
		end
	end,
})
