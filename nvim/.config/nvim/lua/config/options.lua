vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.background = "dark"

-- vim.opt.path:append({ "**" })
vim.opt.path = ".,**"
vim.opt_local.path = ".,**"
vim.opt.shell = "zsh"

vim.opt.shada = "'30,<1000,s100,:100,/100,h,r/COMMIT_EDITMSG$"

vim.opt.winbar = "%=%-.75F %-m"

vim.g.loaded_matchparen = 1
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

-- vim.opt.fsync = false
vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.breakindent = true

vim.opt.cursorcolumn = false
vim.opt.guicursor = ""
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number"
-- vim.o.diffopt = "internal,filler,closeoff,linematch:60"
vim.opt.diffopt = "vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic,linematch:60,closeoff"
vim.opt.directory = "~/.tmp"
vim.opt.fillchars = [[diff:╱,vert:│,eob: ,msgsep:‾]]
vim.opt.fillchars:append("stl: ")

_G.better_fold_text = function()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local indent = string.rep(" ", vim.fn.indent(vim.v.foldstart))

  -- Clean up the line but keep most of its content
  line = line:gsub("^%s+", "")

  -- Truncate if too long (adjust max length as needed)
  local max_length = 60
  local display_line = line
  if #line > max_length then
    display_line = line:sub(1, max_length) .. "..."
  end

  -- Add the line count in brackets
  return indent .. "▶ " .. display_line .. " [" .. line_count .. " lines]"
end

vim.opt.foldtext = "v:lua.better_fold_text()"
vim.opt.fillchars:append({ fold = " " })

-- Clear the Folded highlight group completely
vim.api.nvim_set_hl(0, "Folded", {})
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"

vim.opt.foldnestmax = 1
vim.opt.foldmethod = "indent"

vim.g.markdown_folding = 1    -- enable markdown folding

vim.opt.formatoptions = "qlj" -- TODO: overwritten in my_cmds.lua
-- vim.opt.formatoptions = "c1lqjr"

-- allows lookaround :Rg ^from (?=.*Adapter)
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --pcre2"
else
  vim.opt.grepprg = "grep -nHIRE $* ."
end

vim.opt.grepformat = "%f:%l:%c:%m,%f"

vim.cmd([[
function! Rg(args) abort
  execute "silent! grep!" shellescape(a:args)
  cwindow
  redraw!
endfunction
command -nargs=+ -complete=file Rg call Rg(<q-args>)
]])

vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.joinspaces = false

vim.opt.laststatus = 0
vim.opt.ruler = true
vim.opt.showcmd = false
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
vim.opt.fileformat = "unix"
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.number = true

vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%l%s"
vim.opt.pumheight = 5
vim.opt.relativenumber = true
vim.opt.complete = ".,w,b"
vim.opt.shortmess = "aoOstTWICc" -- F dont show file info when editing file, useful when statusline is enabled already
vim.opt.showbreak = [[↪ ]]
vim.opt.showmatch = false
vim.opt.showtabline = 0
vim.opt.scrollback = 1000
vim.opt.sidescrolloff = 5
vim.opt.scrolloff = 5
vim.opt.sidescroll = 3
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
vim.opt.synmaxcol = 10           -- for performace
vim.opt.tags = [[./tags,tags;~]] -- search upwards until ~ (homedir)
vim.opt.textwidth = 80
-- vim.opt.timeout = false -- remove timeout for partially typed commands
vim.opt.timeout = false -- remove timeout for partially typed commands
vim.opt.timeoutlen = 300
vim.opt.title = true
vim.opt.titlestring = "%t"
vim.opt.ttimeout = true -- disable for indefinite wait time
vim.opt.ttimeoutlen = 50
vim.opt.undodir = os.getenv("HOME") .. "/.nvim_undo"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignorecase = true
vim.opt.updatetime = 300
vim.opt.whichwrap = vim.opt.whichwrap + "h,l,<,>,[,]"

vim.opt.suffixesadd = { ".md", ".js", ".ts", ".tsx", "lua" }

vim.opt.sessionoptions = { "buffers", "curdir" }
vim.opt.wrap = false
vim.opt.wrapscan = true
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.lazyredraw = true
vim.g.markdown_fold_style = "nested"

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

-- Base wildignore setup
vim.opt.wildignore = {}

-- General ignores (OS, editors, etc.)
vim.opt.wildignore:append({
  "**/.DS_Store",
  "**/Thumbs.db",
  "**/Desktop.ini",
  "**/.git/**",
  "**/.svn/**",
  "**/.hg/**",
  "**/.idea/**",
  "**/.vscode/**",
  "**/*.tmp",
  "**/*.temp",
  "**/*.swp",
  "**/*.swo",
  "**/*~",
  ".tags",
  "tags",
})

-- Shared build/cache/temp directories
vim.opt.wildignore:append({
  "**/.cache/**",
  "**/build/**",
  "**/dist/**",
  "**/out/**",
  "**/target/**",
  "**/coverage/**",
  "**/tmp/**",
  "**/.tmp/**",
  "**/.temp/**",
  "**/logs/**",
  "**/.logs/**",
  "**/*.log",
})

-- Python-specific ignores
vim.opt.wildignore:append({
  "**/__init__.py",
  "**/test_*.py",
  "**/*_test.py",
  "**/conftest.py",
  "**/__pycache__/**",
  "**/venv/**",
  "**/.venv/**",
  "**/env/**",
  "**/.env/**",
  "**/virtualenv/**",
  "**/.pytest_cache/**",
  "**/.coverage",
  "**/htmlcov/**",
  "**/.tox/**",
  "**/*.egg-info/**",
  "**/*.egg/**",
  "**/wheels/**",
  "**/.mypy_cache/**",
  "**/.ruff_cache/**",
  "**/site-packages/**",
  "**/*.pyc",
  "**/*.pyo",
  "**/*.pyd",
  "**/pip-log.txt",
  "**/pip-delete-this-directory.txt",
})

-- JavaScript/TypeScript/Node.js ignores
vim.opt.wildignore:append({
  "**/node_modules/**",
  "**/npm-debug.log*",
  "**/yarn-debug.log*",
  "**/yarn-error.log*",
  "**/.npm/**",
  "**/.yarn/**",
  "**/package-lock.json",
  "**/yarn.lock",
  "**/pnpm-lock.yaml",
  "**/.next/**",
  "**/.nuxt/**",
  "**/.output/**",
  "**/.nyc_output/**",
  "**/.parcel-cache/**",
  "**/jspm_packages/**",
  "**/bower_components/**",
  "**/*.min.js",
  "**/*.min.css",
  "**/.eslintcache",
  "**/.stylelintcache",
  "**/tsconfig.tsbuildinfo",
  "**/.turbo/**",
})

-- Go ignores
vim.opt.wildignore:append({
  "**/vendor/**",
  "**/*.exe",
  "**/go.sum",
  "**/bin/**",
  "**/.bin/**",
})

-- Database ignores
vim.opt.wildignore:append({
  "**/*.sqlite",
  "**/*.db",
  "**/*.sqlite3",
})

-- Documentation/Media
vim.opt.wildignore:append({
  "**/*.pdf",
  "**/*.doc",
  "**/*.docx",
  "**/*.jpg",
  "**/*.jpeg",
  "**/*.png",
  "**/*.gif",
  "**/*.ico",
  "**/*.svg",
  "**/*.mp3",
  "**/*.mp4",
  "**/*.avi",
  "**/*.mov",
})
