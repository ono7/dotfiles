vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.breakindent = true
vim.schedule(function()
  -- scheduled to decrease start time
  vim.opt.clipboard = "unnamedplus"
  -- vim.opt.clipboard:append("unnamedplus")
end)
vim.opt.cmdheight = 1
vim.opt.colorcolumn = "99999" -- fixes indentline?
vim.opt.complete = ".,w,b,u"
vim.opt.completeopt = "menu,menuone"
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number"
vim.opt.diffopt = "filler"
vim.opt.directory = "~/.tmp"
vim.opt.expandtab = true
vim.opt.fillchars = [[diff:╱,vert:│,eob: ,msgsep:‾]]
vim.opt.fillchars:append("stl: ")
vim.opt.foldenable = false
vim.opt.foldlevel = 0
vim.opt.foldmethod = "manual"
vim.opt.foldnestmax = 3
vim.opt.foldopen = "hor,mark,percent,quickfix,search,tag,undo" -- removed 'block'
vim.opt.formatoptions = "qlj"                                  -- TODO: overwritten in my_cmds.lua
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.joinspaces = false
vim.opt.jumpoptions:append("view")
vim.opt.laststatus = 0
vim.opt.lazyredraw = true
vim.opt.list = false -- set on demand
vim.opt.listchars = [[tab:  ,trail:•,nbsp:·,conceal: ]]
vim.opt.magic = true
vim.opt.matchtime = 0
vim.opt.maxmempattern = 20000
vim.opt.mousemodel = "extend"
vim.opt.mouse = "n"
vim.opt.nrformats = "bin,hex"
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.number = false
vim.opt.numberwidth = 2
vim.opt.pumheight = 10
vim.opt.relativenumber = false
vim.opt.ruler = true
vim.opt.shiftwidth = 2
vim.opt.shortmess = "aoOstTWICcF" -- F dont show file info when editing file, useful when statusline is enabled already
vim.opt.showbreak = [[↪ ]]
vim.opt.showcmd = false
vim.opt.showmatch = false
vim.opt.showmode = true
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 5
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,5"
vim.opt.spellsuggest = 'best,9'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.synmaxcol = 10           -- for performace
vim.opt.tabstop = 2
vim.opt.tags = [[./tags,tags;~]] -- search upwards until ~ (homedir)
vim.opt.textwidth = 80
vim.opt.timeout = false          -- remove timeout for partially typed commands
vim.opt.timeoutlen = 300
--- report file name to terminal
vim.opt.title = true
vim.opt.titlestring = "%t"
vim.opt.ttimeout = true -- disable for indefinite wait time
vim.opt.ttimeoutlen = 0
vim.opt.undodir = os.getenv("HOME") .. "/.nvim_undo"
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.whichwrap:append "<>[]"
vim.opt.wildignore = [[.tags,tags,vtags,*.o,*.obj,*.rbc,*.pyc,__pycache__/*,.git,.git/*,*.class]]
vim.opt.winaltkeys = "no"
vim.opt.wrap = false
vim.opt.wrapscan = true
vim.opt.writebackup = false

vim.g.floating_window_border = {
  "╭",
  "─",
  "╮",
  "│",
  "╯",
  "─",
  "╰",
  "│",
}
