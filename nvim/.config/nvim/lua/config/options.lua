vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.path:append({ "**" })
vim.opt.shell = "zsh"

vim.opt.shada = "'20,<1000,s100,:100,/100,h,r~/COMMIT_EDITMSG"

vim.opt.fsync = false
vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.breakindent = true
vim.schedule(function()
  -- scheduled to decrease start time
  vim.opt.clipboard = "unnamed,unnamedplus"
end)
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number"
vim.o.diffopt = "internal,filler,closeoff,linematch:60"
vim.opt.directory = "~/.tmp"
vim.opt.fillchars = [[diff:╱,vert:│,eob: ,msgsep:‾]]
vim.opt.fillchars:append("stl: ")
vim.opt.fillchars:append({ fold = "·" })

vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.opt.foldenable = false
vim.opt.foldlevel = 99
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "manual" -- fallback
vim.opt.foldnestmax = 1
vim.opt.foldopen = "hor,mark,percent,quickfix,search,tag,undo" -- removed 'block'
vim.g.markdown_folding = 1 -- enable markdown folding

-- vim.opt.formatoptions = "qljr" -- TODO: overwritten in my_cmds.lua
-- Add asterisks in block comments
-- vim.opt.formatoptions:append({ "r" })
vim.opt.formatoptions = "c1lqjr"
vim.opt.grepprg = "rg --ignore-case --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.joinspaces = false
vim.opt.jumpoptions:append({ "view", "stack" })

-- vim.opt.laststatus = 3
vim.opt.laststatus = 0
-- vim.opt.cmdheight = 0
vim.opt.ruler = true
vim.opt.showcmd = false -- this may be slow
vim.opt.showmode = true

vim.cmd([[
set statusline=%{repeat('─',winwidth('.'))}
]])

vim.opt.list = false -- set on demand
vim.opt.listchars = [[tab:  ,trail:•,nbsp:·,conceal: ]]
vim.opt.magic = true
vim.opt.maxmempattern = 20000
vim.opt.mousemodel = "extend"
vim.opt.mouse = "n"
vim.opt.nrformats = "bin,hex"
vim.opt.fileformats = "unix"
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.number = true

vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%l%s"
vim.opt.pumheight = 5
vim.opt.relativenumber = true
-- vim.opt.shortmess = "aoOstTWICcF" -- F dont show file info when editing file, useful when statusline is enabled already
vim.opt.shortmess = "aoOstTWICc" -- F dont show file info when editing file, useful when statusline is enabled already
vim.opt.showbreak = [[↪ ]]
vim.opt.showmatch = false
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 5
vim.opt.scrolloff = 5
vim.opt.sidescroll = 3
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,5"
vim.opt.spellsuggest = "best,9"
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = "screen"
vim.opt.swapfile = false
vim.opt.synmaxcol = 10 -- for performace
vim.opt.tags = [[./tags,tags;~]] -- search upwards until ~ (homedir)
vim.opt.textwidth = 80
vim.opt.timeout = false -- remove timeout for partially typed commands
vim.opt.timeoutlen = 300
vim.opt.title = true
vim.opt.titlestring = "%t"
vim.opt.ttimeout = true -- disable for indefinite wait time

--- needs to be 50 wsl will hang on exit
vim.opt.ttimeoutlen = 50

vim.opt.undodir = os.getenv("HOME") .. "/.nvim_undo"
vim.opt.undofile = true
vim.opt.wildmode = "longest:full,full"
vim.opt.updatetime = 200
vim.opt.whichwrap = vim.opt.whichwrap + "h,l,<,>,[,]"
vim.opt.wildignore = {
  "**/node_modules/**",
  "**/coverage/**",
  "**/.idea/**",
  "**/.git/**",
  "**/.nuxt/**",
  ".tags",
  "tags",
  "__pycache__",
}

vim.opt.suffixesadd = { ".md", ".js", ".ts", ".tsx", "lua" }

vim.opt.sessionoptions:remove({ "buffers", "folds" })

vim.opt.wrap = true
vim.opt.wrapscan = true
vim.opt.writebackup = false
vim.opt.lazyredraw = true

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

vim.g.markdown_fold_style = "nested"

vim.g.loaded_netwr = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3

local MYHOME = os.getenv("HOME")
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = MYHOME .. "/.virtualenvs/prod3/bin/python3"
vim.g.loaded_python3_provider = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
