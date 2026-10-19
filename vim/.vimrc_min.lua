-- ==============================================================================
-- Streamlined Headless / Server Neovim Configuration
-- Engineering Invariants: Native APIs, zero disk writes, deterministic state
-- ==============================================================================
vim.loader.enable()

vim.g.mapleader = " "
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

--------------------------------------------------------------------------------
-- 1. State, Buffer I/O & Core Options
--------------------------------------------------------------------------------
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

vim.opt.fillchars = {
	foldopen = "",
	foldclose = "▶",
	fold = " ",
	diff = "╱",
	vert = "│",
	eob = " ",
	msgsep = "‾",
	stl = " ",
}

local undo_dir = vim.fn.expand("~/.undo")
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
-- vim.opt.shada = "'100,<50,s10,:1000,/1000,h,r/COMMIT_EDITMSG,r/git-rebase-todo,!"
vim.opt.history = 200
vim.opt.shada = "'25,<20,s10,:100,/100,h,r/COMMIT_EDITMSG,r/git-rebase-todo,r/tmp/,r/var/tmp/,!"

vim.opt.updatecount = 0
vim.opt.updatetime = 300
vim.opt.bufhidden = "hide"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.mouse = "" -- NOTE(jlima): disables terminal mouse tracking entirely to strip event loop overhead
vim.opt.mousemoveevent = false
vim.opt.autochdir = false
vim.opt.autoread = true
-- allows paging when doing things like :hi
vim.opt.more = true

-- Interface Baseline
vim.opt.background = "light"
vim.opt.termguicolors = true
vim.opt.helplang = "en"
vim.opt.encoding = "utf-8"
vim.opt.laststatus = 0
vim.opt.showtabline = 1
vim.opt.showcmd = false
vim.opt.showmode = true
vim.opt.ruler = false -- NOTE(jlima): ruler redraws on every cursor column movement; disable when using custom statusline
vim.opt.shortmess = "aoOstTWICcF"
vim.opt.guicursor = "a:block-blinkon0"
vim.opt.backspace = { "indent", "eol", "start" }

-- Input Timing (Zero-delay escape sequence resolution)
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 0 -- NOTE(jlima): 0ms resolves terminal escape sequences immediately on key release

-- Performance & Memory Guards
vim.opt.synmaxcol = 200
vim.opt.lazyredraw = false
vim.opt.scrollback = 10000
vim.opt.maxmempattern = 2000

-- Indentation & Formatting
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.breakindent = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.formatoptions = "qlj"
vim.opt.joinspaces = false
vim.opt.cinkeys:remove(":")

-- Search & Pattern Matching
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2

-- Splits & Jump Navigation
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = "screen"
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 0
vim.opt.sidescroll = 0
vim.opt.smoothscroll = false
vim.opt.jumpoptions = { "stack", "view" }

-- Display & Visual Configuration
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes:1"
vim.opt.pumheight = 10
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.ambiwidth = "single"
vim.opt.title = false

-- Folding Configuration (Pure Native Manual)
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 2
vim.opt.foldenable = false

-- Statusline Format (Native printf; zero Lua runtime overhead during cursor movements)
vim.opt.statusline = "%<%f %h%w%m%r %= %-10.(%l/%L%) %P "

-- Path & Wildcard Filtering
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:remove("-")
vim.opt.nrformats:append("alpha")
vim.opt.sessionoptions:remove("terminal")

vim.opt.wildignore:append({
	"*/.git/*",
	"*/.venv/*",
	"*/venv/*",
	"*/__pycache__/*",
	"*/node_modules/*",
	"*/.tox/*",
	"*/build/*",
	"*/dist/*",
	"*.o",
	"*.pyc",
	"*.swp",
})
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

vim.opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"vertical",
	"context:5",
	"followwrap",
	"algorithm:histogram",
	"indent-heuristic",
	"inline:char",
	"linematch:70",
}

vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,9"

-- Grep Integration
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --pcre2"
	vim.opt.grepformat = "%f:%l:%c:%m"
else
	vim.opt.grepprg = "grep -nHIRE $* ."
	vim.opt.grepformat = "%f:%l:%m"
end

-- Shell & Terminal Detection
vim.o.shell = vim.fn.executable("zsh") == 1 and "zsh" or vim.o.shell

-- SSH OSC 52 Clipboard Integration
if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end

--------------------------------------------------------------------------------
-- 2. Buffer Hygiene, Dynamic Modes & Autocommands
--------------------------------------------------------------------------------
local core_group = vim.api.nvim_create_augroup("CoreSystemAutoCmds", { clear = true })

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

-- Fast Trailing Whitespace Cleanup (Without Global Document Rescanning)
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

-- Window Balance & Cmdwin Bindings
vim.api.nvim_create_autocmd("VimResized", {
	group = core_group,
	callback = function()
		vim.cmd("wincmd =")
	end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
	group = core_group,
	callback = function(args)
		local kopts = { buffer = args.buf, nowait = true, silent = true }
		vim.keymap.set("n", "<C-f>", "<Nop>", kopts)
		vim.keymap.set("n", "<C-t>", "<Nop>", kopts)
		vim.keymap.set("n", "<C-v>", "<C-v>", kopts)
		vim.keymap.set("n", "q", "<C-c>", kopts)
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

--------------------------------------------------------------------------------
-- 3. Transient Window Architecture & Tab Terminal
--------------------------------------------------------------------------------
local tab_state = {}
local term_size = 12

local function get_normal_wins()
	return vim.tbl_filter(function(win)
		return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == ""
	end, vim.api.nvim_tabpage_list_wins(0))
end

local function get_tab_state()
	local tab = vim.api.nvim_get_current_tabpage()
	if not tab_state[tab] then
		tab_state[tab] = {
			buf = nil,
			win = nil,
			job = nil,
			last_win = nil,
			last_cursor = nil,
			height = term_size,
		}
	end
	return tab_state[tab]
end

local function close_quickfix()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.fn.win_gettype(win) == "quickfix" then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end
end

local function hide_transients()
	local state = get_tab_state()
	local closed_terminal = false

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) then
			local b = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[b].filetype
			local bt = vim.bo[b].buftype
			local wt = vim.fn.win_gettype(win)

			if bt == "terminal" or wt == "quickfix" or ft == "fugitive" or ft == "oil" then
				if #get_normal_wins() > 1 then
					if bt == "terminal" then
						state.height = vim.api.nvim_win_get_height(win)
						closed_terminal = true
					end
					pcall(vim.api.nvim_win_hide, win)
				end
			end
		end
	end

	if closed_terminal and state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
		vim.api.nvim_set_current_win(state.last_win)
	end
end

vim.api.nvim_create_autocmd("TabClosed", {
	group = core_group,
	callback = function()
		local valid_tabs = vim.api.nvim_list_tabpages()
		local valid_set = {}
		for _, t in ipairs(valid_tabs) do
			valid_set[t] = true
		end

		for tab_id, state in pairs(tab_state) do
			if not valid_set[tab_id] then
				if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
					vim.api.nvim_buf_delete(state.buf, { force = true })
				end
				tab_state[tab_id] = nil
			end
		end
	end,
})

--------------------------------------------------------------------------------
-- 4. Keybindings & Emacs-Style Motions
--------------------------------------------------------------------------------
local map = vim.keymap.set
local nore = { noremap = true }
local silent = { noremap = true, silent = true }

map({ "n", "x" }, ";", ":", nore)
map("n", "Y", "y$", nore)
map("n", "&", ":&&<CR>", nore)
map("n", "j", "gj", nore)
map("n", "k", "gk", nore)
map("n", "<leader><leader>", "<cmd>set hlsearch!<CR>", silent)
map("n", "<leader>a", "ggVG", silent)
map("n", "<leader>n", "<cmd>e ~/notes.md<CR>", silent)
map("n", "<C-w>q", "<C-w>c", nore)
map("n", "<C-w><C-q>", "<C-w>c", nore)
map("n", "<C-w><C-d>", "<C-w>d", nore)

-- Directional Search Swap
map("i", "<C-r>", "<C-o>?", silent)
map("i", "<C-s>", "<C-o>/", silent)
map("n", "<C-r>", "?", nore)
map("n", "<C-s>", "/", nore)

-- Window Switching
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)

-- Tab Switching
local modes = { "n", "x" }
vim.keymap.set(modes, "<C-1>", "1gt")
vim.keymap.set(modes, "<C-2>", "2gt")
vim.keymap.set(modes, "<C-3>", "3gt")
vim.keymap.set(modes, "<C-4>", "4gt")
vim.keymap.set(modes, "<C-5>", "5gt")
vim.keymap.set(modes, "<C-6>", "6gt")
vim.keymap.set(modes, "<C-7>", "7gt")
vim.keymap.set(modes, "<C-8>", "8gt")

-- Transients & Quickfix Control
map("n", "<C-t>", "<cmd>T<CR>", silent)
map("t", "<c-x>", [[<c-\><c-n>]], silent)
map("t", "<c-t>", [[<c-\><c-n><cmd>T<CR>]], silent)

local function trim_path(s)
	if #s < 50 then
		return s
	else
		local l = #s / 2
		return s:sub(-l)
	end
end

map("n", "<M-c>", function()
	vim.cmd.lcd("%:p:h")
	local path = vim.fn.getcwd()
	print("new lcd: " .. trim_path(path))
end, { silent = true })

map("n", "<C-/>", hide_transients, silent)
map("n", "<C-_>", hide_transients, silent)
map("t", "<C-/>", function()
	hide_transients()
	vim.cmd("stopinsert")
end, silent)
map("t", "<C-_>", function()
	hide_transients()
	vim.cmd("stopinsert")
end, silent)

-- Deterministic Save Execution
local function safe_write()
	local b = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(b) or vim.bo[b].buftype ~= "" then
		vim.notify("Invalid buffer type for write.", vim.log.levels.WARN)
		return
	end
	vim.cmd("write ++p")
end
map("n", "<leader>w", safe_write, silent)
map("n", "<M-w>", safe_write, silent)

-- Visual Editing & Clipboard
map("v", "J", ":m '>+1<CR>gv=gv", silent)
map("v", "K", ":m '<-2<CR>gv=gv", silent)
map("v", ">", ">gv", silent)
map("v", "<", "<gv", silent)
map("x", "p", '"_dP', silent)
map("x", "y", "ygv<Esc>", silent)
map({ "x", "n" }, "<leader>p", '"+p', silent)
map("v", "<CR>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

-- =============================================================================
-- Insert Mode Bracket Expansion with Auto-Close & Whitespace Precondition
-- =============================================================================
local bracket_pair_map = {
	["{"] = "}",
	["("] = ")",
	["["] = "]",
}

vim.keymap.set("i", "<CR>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col > 0 then
		local line = vim.api.nvim_get_current_line()
		local prev_char = line:sub(col, col)
		local close_char = bracket_pair_map[prev_char]

		if close_char then
			-- NOTE(jlima): Invariant check: only expand if bracket is line-start or preceded by whitespace
			local before_open = col > 1 and line:sub(col - 1, col - 1) or ""
			if col == 1 or before_open == " " or before_open == "\t" then
				local next_char = line:sub(col + 1, col + 1)
				-- If already auto-paired (e.g. "{}" with cursor inside), split it cleanly
				if next_char == close_char then
					return "<CR><C-o>O"
				end
				-- If solitary bracket ("{<CR>"), insert closing bracket on newline and open indented line above
				return close_char .. "<Left><CR><C-o>O"
			end
		end
	end
	return "<CR>"
end, { expr = true })

-- Emacs Insert Mode Navigation & Editing
map("i", "<C-a>", "<C-o>^", silent)
map("i", "<C-e>", "<End>", silent)
map("i", "<C-b>", "<Left>", silent)
map("i", "<C-f>", "<Right>", silent)
map("i", "<C-p>", "<Up>", silent)
map("i", "<C-n>", "<Down>", silent)
map("i", "<M-b>", "<C-o>b", silent)
map("i", "<M-f>", "<C-o>e<Right>", silent)
map("i", "<M-a>", "<C-o>{", silent)
map("i", "<M-e>", "<C-o>}", silent)
map("i", "<C-d>", "<C-g>u<Del>", silent)
map("i", "<C-h>", "<C-g>u<BS>", silent)
map("i", "<C-k>", function()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line_len = #vim.api.nvim_get_current_line()
	return col >= line_len and "<C-g>u<Del>" or "<C-g>u<C-o>D"
end, { expr = true, replace_keycodes = true })
map("i", "<C-u>", "<C-g>u<C-u>", silent)
map("i", "<C-w>", "<C-g>u<C-w>", silent)
map("i", "<M-d>", "<C-g>u<C-\\><C-o>dw", silent)
map("i", "<M-BS>", "<C-g>u<C-w>", silent)
map("i", "<C-BS>", "<C-g>u<C-w>", silent)
map("i", "<C-y>", '<C-r>"', silent)
map("i", "<C-S-e>", "<Esc>Go", silent)

-- Emacs Command-Line Mode
map("c", "<C-a>", "<Home>", nore)
map("c", "<C-e>", "<End>", nore)
map("c", "<C-b>", "<Left>", nore)
map("c", "<C-d>", "<Del>", nore)
map("c", "<C-BS>", "<C-w>", nore)
map("c", "<M-b>", "<S-Left>", nore)
map("c", "<M-f>", "<S-Right>", nore)
map("c", "<M-d>", "<S-Right><C-w>", nore)
map("c", "<C-f>", function()
	return vim.fn.getcmdpos() > #vim.fn.getcmdline() and vim.o.cedit or "<Right>"
end, { expr = true, replace_keycodes = true })
map("c", "<C-k>", function()
	return string.rep("<Del>", #vim.fn.getcmdline() - vim.fn.getcmdpos() + 1)
end, { expr = true, replace_keycodes = true })
map("c", "<C-u>", function()
	return string.rep("<BS>", vim.fn.getcmdpos() - 1)
end, { expr = true, replace_keycodes = true })

-- Toggle quickfix list
map("n", "<c-/>", function()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
			break
		end
	end
	if qf_exists == true then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, silent)

-- Quickfix Make Execution
local function make_and_open_qf()
	local save = vim.fn.winsaveview()
	vim.cmd("silent make!")
	vim.fn.winrestview(save)
	local qf_count = #vim.fn.getqflist()
	if qf_count > 0 then
		vim.cmd("copen")
		vim.cmd("wincmd p")
	else
		vim.cmd("cclose")
		print("Build complete..")
	end
end
map("n", "<M-m>", make_and_open_qf, silent)

-- Macro execution in Visual Line
map("x", "@", function()
	return vim.fn.mode() == "V" and (":normal! @" .. vim.fn.getcharstr() .. "<CR>") or "@"
end, { expr = true })

--------------------------------------------------------------------------------
-- 5. User Commands & Helpers
--------------------------------------------------------------------------------
local function run_fd_filtered(input, max_results)
	local parts = vim.split(input, "!", { plain = true })
	local pattern = parts[1] ~= "" and parts[1] or ".*"
	local limit_flag = max_results and string.format("--max-results %d", max_results) or ""
	local cmd = string.format("fd --type f --hidden --exclude .git -p %s %s", limit_flag, vim.fn.shellescape(pattern))
	local results = vim.fn.systemlist(cmd)

	for i = 2, #parts do
		local exclude = parts[i]
		if exclude ~= "" then
			results = vim.tbl_filter(function(item)
				return not item:find(exclude, 1, true) and not item:match(exclude)
			end, results)
		end
	end
	return results
end

-- Terminal Drawer (:T)
vim.api.nvim_create_user_command("T", function(opts_args)
	local cmd = opts_args.args
	local state = get_tab_state()

	close_quickfix()

	local function save_editor_pos()
		state.last_win = vim.api.nvim_get_current_win()
		state.last_cursor = vim.api.nvim_win_get_cursor(0)
	end

	local function restore_editor_pos()
		if state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
			vim.api.nvim_set_current_win(state.last_win)
			if state.last_cursor then
				pcall(vim.api.nvim_win_set_cursor, state.last_win, state.last_cursor)
			end
		end
	end

	-- NOTE(jlima): Check if existing buffer is valid AND still running an active channel job.
	local is_alive = state.buf
		and vim.api.nvim_buf_is_valid(state.buf)
		and state.job
		and pcall(vim.fn.jobwait, { state.job }, 0)
		and vim.fn.jobwait({ state.job }, 0)[1] == -1

	-- Case 1: Terminal does not exist or previous job terminated
	if not is_alive then
		if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
			pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
		end

		save_editor_pos()
		vim.opt_local.winbar = nil
		vim.cmd("botright split")
		vim.wo.winfixheight = true
		vim.cmd("resize " .. state.height)

		local current_file = vim.api.nvim_buf_get_name(0)
		local current_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()

		vim.cmd.term()

		state.buf = vim.api.nvim_get_current_buf()
		state.win = vim.api.nvim_get_current_win()
		state.job = vim.b.terminal_job_id
		vim.wo.statusline = "%#Normal# "

		vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
		if cmd ~= "" then
			vim.fn.chansend(state.job, cmd .. "\n")
			-- NOTE(jlima): Retain editor focus when executed via automated runner hook
			restore_editor_pos()
		else
			vim.cmd("startinsert")
		end
		return
	end

	-- Find if terminal buffer is visible in any window on the current tab
	local visible_win = nil
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_buf(win) == state.buf then
			visible_win = win
			break
		end
	end

	-- Case 2: Terminal is visible
	if visible_win then
		state.height = vim.api.nvim_win_get_height(visible_win)

		-- NOTE(jlima): Toggle closed ONLY when :T is called without an execution argument.
		if cmd == "" then
			if #get_normal_wins() > 1 then
				pcall(vim.api.nvim_win_hide, visible_win)
			else
				vim.cmd("enew")
			end
			restore_editor_pos()
			return
		end

		-- If a command was supplied and terminal is visible, interrupt current job and re-run
		vim.fn.chansend(state.job, "\x03")
		vim.fn.chansend(state.job, cmd .. "\n")
		return
	end

	-- Case 3: Terminal exists in memory but window is hidden
	save_editor_pos()
	vim.cmd("botright split")
	vim.wo.winfixheight = true
	vim.cmd("resize " .. state.height)
	vim.api.nvim_win_set_buf(0, state.buf)
	state.win = vim.api.nvim_get_current_win()
	vim.wo.statusline = "%#Normal# "

	if cmd ~= "" then
		vim.fn.chansend(state.job, "\x03")
		vim.fn.chansend(state.job, cmd .. "\n")
		restore_editor_pos()
	else
		vim.cmd("startinsert")
	end
end, { nargs = "*" })

-- Fuzzy Find (:F and :FT)
vim.api.nvim_create_user_command("F", function(opts_cmd)
	local is_empty = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""
	if is_empty then
		vim.cmd.edit(vim.fn.fnameescape(opts_cmd.args))
	else
		vim.cmd.tabedit(vim.fn.fnameescape(opts_cmd.args))
	end
end, {
	nargs = 1,
	complete = function(lead)
		return run_fd_filtered(lead, 100)
	end,
	desc = "Fast regex find: :F <pattern>!<exclude>",
})

vim.api.nvim_create_user_command("FT", function(opts_cmd)
	local files = run_fd_filtered(opts_cmd.args, nil)
	if #files == 0 then
		vim.notify("No files matched: " .. opts_cmd.args, vim.log.levels.WARN)
		return
	end

	local max_tabs = vim.o.tabpagemax
	if #files > max_tabs then
		local confirm =
			vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
		if confirm ~= 1 then
			return
		end
	end

	for i, file in ipairs(files) do
		if i > max_tabs then
			break
		end
		local is_empty = i == 1 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""
		if is_empty then
			vim.cmd.edit(vim.fn.fnameescape(file))
		else
			vim.cmd.tabedit(vim.fn.fnameescape(file))
		end
	end
end, {
	nargs = 1,
	complete = function(lead)
		return run_fd_filtered(lead, 50)
	end,
	desc = "Open all regex matches in separate tabs: :FT <pattern>!<exclude>",
})

-- Delete All Matching Buffers (:Da)
vim.api.nvim_create_user_command("Da", function(opts_cmd)
	local arg = vim.trim(opts_cmd.args)
	local raw_patterns = arg ~= "" and vim.split(arg, "|", { trimempty = true }) or {}
	local include_pats, exclude_pats = {}, {}

	for _, pat in ipairs(raw_patterns) do
		local trimmed = vim.trim(pat)
		if trimmed:sub(1, 1) == "!" then
			local stripped = vim.trim(trimmed:sub(2))
			if stripped ~= "" then
				table.insert(exclude_pats, stripped)
			end
		elseif trimmed ~= "" then
			table.insert(include_pats, trimmed)
		end
	end

	local bufs = vim.tbl_filter(function(b)
		if not vim.api.nvim_buf_is_valid(b) then
			return false
		end
		local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
		return ok and listed
	end, vim.api.nvim_list_bufs())

	local function test_match(str, pat)
		if not str or str == "" then
			return false
		end
		local ok, match = pcall(string.find, str, pat)
		if ok and match ~= nil then
			return true
		end
		return str:lower():find(pat:lower(), 1, true) ~= nil
	end

	local targets = {}
	for _, buf in ipairs(bufs) do
		local full_path = vim.api.nvim_buf_get_name(buf)
		local rel_path = full_path ~= "" and vim.fn.fnamemodify(full_path, ":.") or ""
		local buf_name = vim.fn.bufname(buf)

		local is_excluded = false
		for _, pat in ipairs(exclude_pats) do
			if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
				is_excluded = true
				break
			end
		end

		if not is_excluded then
			if #include_pats == 0 then
				table.insert(targets, buf)
			else
				for _, pat in ipairs(include_pats) do
					if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
						table.insert(targets, buf)
						break
					end
				end
			end
		end
	end

	if #targets == 0 then
		vim.notify("No buffers matched" .. (arg ~= "" and (": " .. arg) or ""), vim.log.levels.WARN)
		return
	end

	local closed, skipped_modified = 0, 0
	for _, buf in ipairs(targets) do
		if vim.api.nvim_buf_is_valid(buf) then
			local ok_mod, is_modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = buf })
			if not opts_cmd.bang and ok_mod and is_modified then
				skipped_modified = skipped_modified + 1
			else
				if pcall(vim.api.nvim_buf_delete, buf, { force = opts_cmd.bang }) then
					closed = closed + 1
				end
			end
		end
	end

	if skipped_modified > 0 then
		vim.notify(
			string.format(
				"Closed %d buffer(s). Skipped %d modified buffer(s) (use :Da! to force).",
				closed,
				skipped_modified
			),
			vim.log.levels.WARN
		)
	else
		vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
	end
end, {
	bang = true,
	nargs = "?",
	desc = "Close buffers matching pattern(s); prefix with '!' to exclude",
})

vim.api.nvim_create_user_command("D", "bdelete!", {})
vim.api.nvim_create_user_command("Cd", function()
	local name = vim.api.nvim_buf_get_name(0)
	local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
	local git = vim.fs.find(".git", { path = start, upward = true })[1]
	if git then
		vim.cmd.lcd(vim.fs.dirname(git))
	else
		print("not a git repo")
	end
end, {})

vim.cmd([[
  cnoreabbrev qq qa!
  cabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() == 'w!!') ? 'w !sudo tee > /dev/null %' : 'w!!'
]])

--- take

vim.api.nvim_create_user_command("Take", function(opts)
	local path = vim.fn.fnamemodify(opts.args:gsub("%s+", "-"), ":p")
	vim.fn.mkdir(path, "p")
	vim.cmd.lcd(vim.fn.fnameescape(path))
end, { nargs = "+", complete = "dir" })

--------------------------------------------------------------------------------
-- 6. Filetype Execution Runner Hooks
--------------------------------------------------------------------------------
local HOOKS_PATH = vim.fn.expand("~/.dotfiles/hooks.json")

local function load_hooks()
	local uv = vim.uv or vim.loop
	local fd, _ = uv.fs_open(HOOKS_PATH, "r", 438)
	if not fd then
		return {}
	end

	local stat = uv.fs_fstat(fd)
	local data = stat and uv.fs_read(fd, stat.size, 0) or ""
	uv.fs_close(fd)

	if not data or data == "" then
		return {}
	end

	local ok, parsed = pcall(vim.json.decode, data)
	if not ok or type(parsed) ~= "table" then
		return {}
	end

	return parsed
end

local function save_hooks(hooks)
	local encoded = vim.json.encode(hooks)
	local dir = vim.fs.dirname(HOOKS_PATH)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local uv = vim.uv or vim.loop
	local fd, err = uv.fs_open(HOOKS_PATH, "w", 438)
	if not fd then
		vim.notify(string.format("Failed to open hooks file: %s", err), vim.log.levels.ERROR)
		return false
	end

	uv.fs_write(fd, encoded, 0)
	uv.fs_close(fd)
	return true
end

local function execute_hook_command(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local ft = vim.bo[bufnr].filetype
	local hooks = load_hooks()
	local raw_cmd = hooks[ft]
	if not raw_cmd or raw_cmd == "" then
		vim.notify(string.format("No hook configured for filetype '%s'.", ft), vim.log.levels.WARN)
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	local buf_dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

	local expanded_cmd
	vim.api.nvim_buf_call(bufnr, function()
		local saved_cwd = vim.fn.getcwd()
		vim.cmd.lcd(buf_dir)
		expanded_cmd = vim.fn.expandcmd(raw_cmd)
		vim.cmd.lcd(saved_cwd)
	end)

	if expanded_cmd and expanded_cmd ~= "" then
		local escaped_dir = vim.fn.fnameescape(buf_dir)
		vim.cmd(string.format("T cd %s && %s", escaped_dir, expanded_cmd))
	end
end

local function save_and_execute_hook()
	local bufnr = vim.api.nvim_get_current_buf()

	if vim.bo[bufnr].buftype == "" and vim.bo[bufnr].modified then
		if vim.api.nvim_buf_get_name(bufnr) == "" then
			vim.notify("Cannot save and execute: buffer has no file name.", vim.log.levels.ERROR)
			return
		end
		vim.cmd("silent update")
	end

	execute_hook_command(bufnr)
end

vim.api.nvim_create_user_command("H", function(args)
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	if ft == "" then
		vim.notify("Cannot register hook: buffer has no filetype.", vim.log.levels.WARN)
		return
	end

	local hooks = load_hooks()

	local function apply_hook(input)
		if input == nil then
			return
		end

		local cleaned = vim.trim(input)
		if cleaned == "" then
			hooks[ft] = nil
			save_hooks(hooks)
			print(string.format("[%s] Compiler cleared.", ft))
			return
		end

		hooks[ft] = cleaned
		save_hooks(hooks)
		print(string.format("[%s] Compiler configured: %s", ft, cleaned))
	end

	if #args.args == 0 then
		vim.ui.input({
			prompt = string.format("[%s] Edit Hook (empty to clear): ", ft),
			default = hooks[ft] or "",
		}, function(input)
			apply_hook(input)
		end)
	else
		apply_hook(args.args)
	end
end, { nargs = "*", desc = "Configure or clear runner hook for current filetype" })

vim.api.nvim_create_user_command("HRun", save_and_execute_hook, { desc = "Save and run filetype hook" })
map("n", "<leader>r", save_and_execute_hook, { noremap = true, silent = true, desc = "Save and run filetype hook" })

--- visual selection search ---
vim.keymap.set("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

vim.keymap.set("n", "<leader>te", function()
	local dir = vim.fn.expand("%:p:h")
	vim.fn.jobstart({ "alacritty", "--working-directory", dir }, { detach = true })
end, { desc = "Open Alacritty in current directory" })

--------------------------------------------------------------------------------
-- 7. Native Package Manager (vim.pack)
--------------------------------------------------------------------------------
vim.pack.add({
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/stevearc/conform.nvim" },
}, { confirm = false })

require("conform").setup({
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		lua = { "stylua" },
		yaml = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		go = { "goimports", "goimports-reviser" },
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "isort", "ruff_fix", "ruff_format" }
			else
				return { "isort", "ruff_fix", "black" }
			end
		end,
		-- ['_'] = { 'trim_whitespace' },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = false,
	},
})

local has_oil, oil = pcall(require, "oil")
if has_oil then
	oil.setup()
	vim.keymap.set("n", "<c-\\>", "<CMD>Oil<CR>")
end

local has_pick, pick = pcall(require, "mini.pick")
if has_pick then
	pick.setup({
		window = {
			config = {
				border = "single",
			},
		},
	})

	local function pick_oldfiles()
		local old = vim.tbl_filter(function(path)
			return path ~= "" and vim.uv.fs_stat(path) ~= nil
		end, vim.v.oldfiles)

		local items = {}
		for i = 1, math.min(#old, 25) do
			table.insert(items, old[i])
		end

		pick.start({
			source = {
				items = items,
				name = "Oldfiles",
				choose = pick.default_choose,
			},
		})
	end

	-- Register picker into :Pick registry so `:Pick oldfiles` works natively
	pick.registry.oldfiles = pick_oldfiles

	map("n", "<M-f>", "<cmd>Pick files<CR>", silent)
	map("n", "<M-g>", "<cmd>Pick grep_live<CR>", silent)
	map("n", "<M-r>", pick_oldfiles, silent)
end

--------------------------------------------------------------------------------
-- 8. Embedded Colorscheme: custom-paper-minimal
--------------------------------------------------------------------------------
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "custom-paper-minimal"

local bg = "#EDE9E1"
local fg = "#242424"
local fn_col = "#B63E46"
local type_col = "#35659A"
local comment = "#7B858F"
local visual = "#D9D4CA"
local hl = "#E5E1D9"
local line_nr = "#9DA4AB"
local border = "#9299A1"

if vim.g.neovide then
	vim.g.neovide_background_color = bg
end

vim.g.terminal_color_0 = "#242424"
vim.g.terminal_color_1 = "#8F242B"
vim.g.terminal_color_2 = "#355B3F"
vim.g.terminal_color_3 = "#76520D"
vim.g.terminal_color_4 = "#274F7D"
vim.g.terminal_color_5 = "#57345A"
vim.g.terminal_color_6 = "#1A5962"
vim.g.terminal_color_7 = "#E8E4DC"

-- Bright ANSI variants
vim.g.terminal_color_8 = "#59616B"
vim.g.terminal_color_9 = "#A3262E"
vim.g.terminal_color_10 = "#2E4C35"
vim.g.terminal_color_11 = "#624508"
vim.g.terminal_color_12 = "#1F3D60"
vim.g.terminal_color_13 = "#472A49"
vim.g.terminal_color_14 = "#174B53"
vim.g.terminal_color_15 = "#F2EFE9"

local hl_groups = {
	Normal = { fg = fg, bg = bg },
	NormalFloat = { fg = fg, bg = bg },
	FloatBorder = { fg = border, bg = bg },
	Visual = { bg = visual },
	CursorLine = { bg = hl },
	LineNr = { fg = line_nr, bg = bg },
	CursorLineNr = { fg = "#8C6615", bg = "none" },
	SignColumn = { bg = "none" },
	WinSeparator = { fg = line_nr, bg = "none" },
	StatusLine = { fg = fg, bg = "#DDD8CE" },
	StatusLineNC = { fg = "#59616B", bg = "#D8D3C9" },
	-- Search = { fg = bg, bg = "#8C6615" },
	Search = { fg = "#174B53", bg = "#e5c07b" },
	CurSearch = { fg = "#ffffff", bg = "#c678dd" },
	MatchParen = { fg = bg, bg = "#174B53", bold = true },

	Comment = { fg = comment, italic = true },
	Constant = { fg = fg },
	ModeMsg = { fg = fg },
	String = { fg = fg },
	Identifier = { fg = fg },
	Statement = { fg = fn_col },
	Keyword = { fg = fn_col },
	Operator = { fg = fg },
	Delimiter = { fg = "#59616B" },
	Special = { fg = fg },

	Type = { fg = type_col },
	["@type"] = { fg = type_col },
	["@type.builtin"] = { fg = type_col },
	Function = { fg = fn_col, bold = true },
	["@function"] = { fg = fn_col, bold = true },
	["@function.call"] = { fg = fn_col },
	["@function.method"] = { fg = fn_col },
	["@keyword.conditional"] = { fg = fn_col },
	["@keyword.repeat"] = { fg = fn_col },
	["@function.builtin"] = { fg = fn_col },

	Pmenu = { fg = fg, bg = bg },
	PmenuSel = { fg = bg, bg = type_col },
	PmenuThumb = { bg = line_nr },
	DiagnosticError = { fg = "#B63E46" },
	DiagnosticWarn = { fg = "#8C6615" },
	DiagnosticInfo = { fg = type_col },
	DiagnosticHint = { fg = comment },
	DiffAdd = { fg = "none", bg = "none" },
	DiffText = { fg = "#EDE9E1", bg = "#B63E46" },
	DiffDelete = { fg = "#8F242B", bg = "none" },
	DiffChange = { bg = "none" },
	Folded = { fg = "#7A7265", bg = "#EBE6DD" },
	FoldColumn = { fg = "#B0A898", bg = "none" },
}

for group, spec in pairs(hl_groups) do
	vim.api.nvim_set_hl(0, group, spec)
end

vim.cmd([[
" these are oldies but work great and are easier to suppo
" commit
nnoremap gm :lcd %:p:h<CR>:!git add %:t && git commit -m "<C-r>=expand('%:t')<CR>: "<Left>

" select last inserted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" case transformation parity
inoremap <M-u> <Esc>gUiwea
inoremap <M-l> <Esc>guiwea

" change inside selection
xnoremap & :<C-u>'<,'>s/\%V\v


function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? 'c' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register Cm call CopyMatches(<q-reg>)

function! WrapSelection(left, right)
    let save_reg = @"
    normal! `
    call search('\S', 'c')
    let start_pos = getpos('.')
    normal! `>
    let end_pos = getpos('.')

    call setpos('.', end_pos)
    execute "normal! a" . a:right
    call setpos('.', start_pos)
    execute "normal! i" . a:left
    let @" = save_reg
    startinsert
endfunction

xnoremap ' :<C-u>call WrapSelection("'", "'")<CR>
" this overrides the " register key
" vnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>

function! DuplicateAndMark()
    let l:c = col('.')
    " Duplicate line above using the unnamed register
    execute "normal! yyP"
    " Restore cursor column on the new line
    call cursor(line('.'), l:c)
    " Move down to the original line (mimicking your previous <Down>)
    execute "normal! j"

    redraw
    echo "Mark set"
endfunction

inoremap <silent> <C-,> <C-o>:call DuplicateAndMark()<CR>
nnoremap <silent> <C-,> <cmd>call DuplicateAndMark()<CR>

if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
endif

function! Rg(args) abort
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
endfunction

command! -nargs=+ -complete=file Rg call Rg(<q-args>)
]])

-- fix command line editing window, by restoring CR mapping to defaults
-- the <c-m> mapping for running make was causing problems
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

local neovide_path = vim.fn.expand("~/.dotfiles/nvim/.config/nvim/lua/config/neovide.lua")
if vim.g.neovide and vim.fn.filereadable(neovide_path) == 1 then
	dofile(neovide_path)
end
