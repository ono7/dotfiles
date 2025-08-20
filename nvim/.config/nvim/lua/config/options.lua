vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.background = "dark"

-- vim.opt.path:append({ "**" })
vim.opt.path = ".,**"
vim.opt_local.path = ".,**"
vim.opt.shell = "zsh"

vim.opt.shada = "'30,<1000,s100,:100,/100,h,r/COMMIT_EDITMSG$"

-- vim.opt.winbar = "%=%-.75F %-m"
-- vim.opt.winbar = "%=%f"

function _G.winbar_path()
  local filepath = vim.fn.expand("%:.") -- relative path
  if filepath == "" then
    return ""
  end
  if filepath:sub(1, #vim.env.HOME) == vim.env.HOME then
    filepath = "~" .. filepath:sub(#vim.env.HOME + 1)
  end
  return filepath
end

vim.opt.winbar = "%=" .. "%{v:lua.winbar_path()}"

-- vim.g.loaded_matchparen = 1
vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10

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
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"

vim.opt.foldnestmax = 1
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true

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
vim.opt.maxmempattern = 2000
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
vim.opt.titlestring = ""
