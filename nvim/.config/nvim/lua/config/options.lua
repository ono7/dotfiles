-- =============================================================================
-- 1. Performance & Loader (Must run first)
-- =============================================================================
vim.loader.enable(true)

-- =============================================================================
-- 2. Leader Keys
-- =============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- 3. General Editor Behavior & Timeouts
-- =============================================================================
-- vim.opt.background = "dark"
vim.opt.bufhidden = "hide"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.mouse = "n"
vim.opt.autochdir = false
vim.opt.autoread = true
vim.opt.more = true

-- Key timeout settings (prevents hung mappings & fast escape resolution)
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 300

-- =============================================================================
-- 4. Indentation & Formatting (Optimized for Low Latency)
-- =============================================================================
vim.opt.autoindent = true
vim.opt.smartindent = false -- Disabled: avoids conflicts with filetype indent scripts
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.formatoptions = "qlj"
vim.opt.joinspaces = false

-- =============================================================================
-- 5. Search & Pattern Matching
-- =============================================================================
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10

-- =============================================================================
-- 6. Undo & Shada Persistence
-- =============================================================================
local undo_dir = vim.fn.expand(vim.env.HOME .. "/.undo")
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

vim.opt.shada = "'100,<50,s10,:1000,/1000,h,r/COMMIT_EDITMSG,r/git-rebase-todo,!"

-- =============================================================================
-- 7. System, Paths & File Handling
-- =============================================================================
vim.opt.shell = "zsh"
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:remove("-")
vim.opt.nrformats:append("alpha")
vim.opt.sessionoptions:remove("terminal")

-- Append recursive search from current working directory for :find
-- vim.opt.path:append("**") -- use :FT or :F now

-- Recursively traverse visible directories, any dot-folder, and all children
-- vim.opt.path:append("**/.*/**")

-- Prune heavy trees so native filesystem searches ignore them
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

-- Configure wildmenu to behave predictably with :find <Tab>
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

-- =============================================================================
-- 8. Memory & Performance Guards
-- =============================================================================
vim.opt.swapfile = false
vim.opt.directory = "~/.tmp"
vim.opt.synmaxcol = 200
vim.opt.lazyredraw = false
vim.opt.scrollback = 10000 -- Bounded to prevent memory bloat and GC pauses
vim.opt.maxmempattern = 2000

-- =============================================================================
-- 9. Splits & Scrolling
-- =============================================================================
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = "screen"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 3
vim.opt.smoothscroll = false

-- =============================================================================
-- 10. Display & Appearance
-- =============================================================================
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes:1"
vim.opt.pumheight = 5
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.cursorlineopt = "number"
vim.opt.ambiwidth = "single"
vim.opt.title = true
vim.opt.titlestring = ""
vim.opt.linespace = 10
vim.opt.showbreak = [[↪ ]]
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

-- =============================================================================
-- 11. Diff & Language Options
-- =============================================================================
vim.opt.diffopt:remove("inline:char")
vim.opt.diffopt:append({
  "vertical",
  "algorithm:histogram",
  "context:5",
  "linematch:60",
  "inline:word",
})

vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,9"

-- =============================================================================
-- 12. Folding Configuration
-- =============================================================================
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 2
vim.opt.foldenable = false
vim.g.markdown_folding = 1
vim.api.nvim_set_hl(0, "Folded", {})

_G.better_fold_text = function()
  local start = vim.v.foldstart
  local finish = vim.v.foldend
  local line = vim.fn.getline(start):gsub("^%s+", "")
  local indent = string.rep(" ", vim.fn.indent(start))
  local max = 60
  if #line > max then
    line = line:sub(1, max) .. "…"
  end
  return string.format("%s▏ ▶ %s   · %d lines", indent, line, (finish - start + 1))
end
vim.opt.foldtext = "v:lua.better_fold_text()"

-- =============================================================================
-- 13. Event-Driven Statusline & Tabline (Zero Keystroke Overhead)
-- =============================================================================
vim.opt.showtabline = 1
vim.opt.laststatus = 0
vim.opt.showcmd = false
vim.opt.showmode = true
vim.opt.ruler = true
vim.opt.shortmess = "aoOstTWICcF"

local cache = {
  tabline = "",
  git_branch = "",
  diagnostics = "",
  filename = "[No Name]",
}

-- 1. Tabline: Only calculated when tabs or buffers change
local function update_tabline()
  local s = ""
  local tabs = vim.api.nvim_list_tabpages()
  local cur_tab = vim.api.nvim_get_current_tabpage()

  for i, tab in ipairs(tabs) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    local filename = (name ~= "") and vim.fs.basename(name) or "[No Name]"

    s = s .. (tab == cur_tab and "%#TabLineSel#" or "%#TabLine#")
    s = s .. " " .. i .. ":" .. filename .. " "
  end
  cache.tabline = s .. "%#TabLineFill#"
end

-- 2. Git Branch: Cached per buffer focus
local function update_git()
  local ok, branch = pcall(vim.fn.FugitiveHead)
  cache.git_branch = (ok and branch and branch ~= "") and ("  " .. branch .. " ") or ""
end

-- 3. Diagnostics: Strictly scoped to current buffer only
local function update_diagnostics(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local count = vim.diagnostic.count(bufnr)

  local errs = count[vim.diagnostic.severity.ERROR] or 0
  local warns = count[vim.diagnostic.severity.WARN] or 0

  if errs == 0 and warns == 0 then
    cache.diagnostics = ""
    return
  end

  local parts = {}
  if errs > 0 then
    table.insert(parts, "E:" .. errs)
  end
  if warns > 0 then
    table.insert(parts, "W:" .. warns)
  end
  cache.diagnostics = table.concat(parts, " ") .. " "
end

-- 4. Filename: Cached relative name
local function update_filename()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    cache.filename = "[No Name]"
    return
  end
  local parent, file = name:match("([^/\\]+)[/\\]([^/\\]+)$")
  cache.filename = parent and (parent .. "/" .. file) or vim.fs.basename(name)
end

function _G.winbar_path()
  local filepath = vim.fn.expand("%:.")
  return (filepath ~= "") and vim.fn.pathshorten(filepath, 4) or ""
end

local status_group = vim.api.nvim_create_augroup("StatuslineCache", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
  group = status_group,
  callback = function(args)
    update_filename()
    update_git()
    update_diagnostics(args.buf)
    update_tabline()
  end,
})

vim.api.nvim_create_autocmd({ "TabEnter", "TabClosed" }, {
  group = status_group,
  callback = update_tabline,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = status_group,
  callback = function(args)
    if args.buf == vim.api.nvim_get_current_buf() then
      update_diagnostics(args.buf)
    end
  end,
})

-- Redraw exports (instant memory reads during redraw)
_G.get_tabline = function()
  return cache.tabline
end
_G.get_filename = function()
  return cache.filename
end
_G.get_git = function()
  return cache.git_branch
end
_G.get_diagnostics = function()
  return cache.diagnostics
end

vim.opt.tabline = "%!v:lua.get_tabline()"

-- Statusline format:
-- Removed %c / %V to stop per-keystroke statusline redraws while typing on the same line
vim.opt.statusline = table.concat({
  "%< %{%v:lua.get_filename()%} %h%w%m%r ",
  "%=",
  "%{%v:lua.get_git()%}",
  "%=",
  "%{%v:lua.get_diagnostics()%}",
  "%-10.(%l/%L%) %P ",
}, "")

-- =============================================================================
-- 14. Custom Commands & Keymaps
-- =============================================================================
vim.cmd([[
function! ToggleFolding()
  if &foldmethod ==# 'manual'
    setlocal foldmethod=indent foldenable foldlevel=1
    echo "Folding enabled (methods folded, classes open)"
  else
    setlocal nofoldenable foldmethod=manual
    echo "Folding disabled"
  endif
endfunction
nnoremap <silent> gz :call ToggleFolding()<CR>

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
