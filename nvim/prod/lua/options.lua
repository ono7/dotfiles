-- State, Buffer I/O & Core Options
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
vim.opt.history = 1000
vim.opt.shada = "'25,<20,s10,:100,/100,h,r/COMMIT_EDITMSG,r/git-rebase-todo,r/tmp/,r/var/tmp/,!"

vim.opt.updatecount = 0
vim.opt.updatetime = 300
vim.opt.bufhidden = "hide"
vim.opt.hidden = true
vim.opt.mouse = "" -- NOTE(jlima): disables terminal mouse tracking entirely to strip event loop overhead
vim.opt.mousemoveevent = false
vim.opt.autochdir = false
vim.opt.autoread = true
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

-- Input Timing
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

-- Statusline Format
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
