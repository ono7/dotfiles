-- ==============================================================================
-- Streamlined Headless / Server Neovim Configuration
-- Engineering Invariants: Native APIs, zero disk writes, deterministic state
-- ==============================================================================
local map = vim.keymap.set
local nore = { noremap = true }
local silent = { noremap = true, silent = true }
local k = vim.keymap.set

vim.g.mapleader = " "

--------------------------------------------------------------------------------
-- 1. State, Buffer I/O & Core Options
--------------------------------------------------------------------------------
local o = vim.opt

-- State & File I/O (Zero Disk Writes)

o.swapfile = false
o.backup = false
o.writebackup = false
o.undofile = false
o.updatecount = 0
o.breakindent = false

-- Interface Baseline
o.background = "light"
o.termguicolors = true
o.helplang = "en"
o.encoding = "utf-8"
o.laststatus = 0
o.shortmess = "aoOstTWICcF"
o.guicursor = "a:block-blinkon0"
o.backspace = { "indent", "eol", "start" }

-- Input Timing
o.timeout = false
o.ttimeout = true
o.ttimeoutlen = 10

-- Grep Integration
if vim.fn.executable("rg") == 1 then
  o.grepprg = "rg --vimgrep --no-heading --smart-case --pcre2"
  o.grepformat = "%f:%l:%c:%m"
else
  o.grepprg = "grep -nHIRE $* ."
  o.grepformat = "%f:%l:%m"
end

-- c/cpp
-- NOTE(jlima): remove colon trigger from cinkeys to prevent re-indenting mid-typing
vim.opt.cinkeys:remove(":")

-- Global Diff Configuration
o.diffopt = {
  "vertical",
  "filler",
  "closeoff",
  "context:5",
  "internal",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
  "followwrap",
}

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

-- Filetype tab spacing
local function set_ft_indent(tabstop, expand)
  vim.bo.tabstop = tabstop
  vim.bo.softtabstop = expand and tabstop or 0
  vim.bo.shiftwidth = tabstop
  vim.bo.expandtab = expand
end

-- NOTE(jlima): buffer-local bracket navigation for quickfix to preserve normal j/k line motions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    vim.keymap.set("n", "]", "<cmd>cnext<CR>", { buffer = args.buf, silent = true, desc = "Next quickfix entry" })
    vim.keymap.set("n", "[", "<cmd>cprev<CR>", { buffer = args.buf, silent = true, desc = "Previous quickfix entry" })
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = args.buf, desc = "Jump to quickfix entry" })
  end,
})

-- NOTE(jlima): Populates the native quickfix list while keeping compilation non-interactive.
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
    vim.notify("Build clean.", vim.log.levels.INFO)
  end
end

map("n", "<c-m>", make_and_open_qf, silent)

vim.api.nvim_create_autocmd("FileType", {
  group = core_group,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "python" then
      set_ft_indent(4, true)
    elseif ft:match("^(typescript|javascript|markdown|json|ya?ml|html|css)$") then
      set_ft_indent(2, true)
    elseif ft == "go" or ft == "make" then
      set_ft_indent(4, false)
    elseif ft:match("^(sh|bash|zsh|jinja2?)$") then
      set_ft_indent(2, true)
    elseif ft == "qf" then
      vim.keymap.set("n", "<CR>", "<CR>", { buffer = args.buf })
    end

    -- Normalize commentstring formatting
    local cs = vim.bo[args.buf].commentstring
    if cs ~= "" and cs:find("%%s") then
      vim.bo[args.buf].commentstring = vim.trim(cs:gsub("%s*%%s%s*", " %%s "))
    end
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

-- Buffer Clean on Write
vim.api.nvim_create_autocmd("BufWritePre", {
  group = core_group,
  callback = function(args)
    if vim.b[args.buf].large_file or vim.api.nvim_buf_line_count(args.buf) >= 5000 then
      return
    end
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\v\s*\r+$\vert{}\s+$//e]])
    vim.cmd([[keeppatterns %s#\($\n\s*\)\+\%$##e]])
    if vim.bo[args.buf].expandtab then
      vim.cmd([[retab!]])
    end
    vim.fn.winrestview(save)
  end,
})

-- Optional External Formatting
if vim.fn.executable("prettier") == 1 then
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = core_group,
    pattern = { "*.md", "*.json", "*.yaml", "*.yml", "*.css", "*.html", "*.js", "*.ts", "*.jsx", "*.tsx" },
    callback = function()
      vim.cmd("silent! execute '!prettier --write %' | edit!")
    end,
  })
end

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
      vim.opt_local.numberwidth = 4
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
      vim.b.lualine_disable = true
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
-- 4. Custom Auto-Pair Engine
--------------------------------------------------------------------------------
local my_pair_map = { ["("] = ")", ["["] = "]", ["{"] = "}", ["<"] = ">", ["'"] = "'", ['"'] = '"', ["`"] = "`" }
local r_bracket_map = { [")"] = true, ["]"] = true, ["}"] = true, [">"] = true, [" "] = true, ["\t"] = true }
local r_quote_ws_map = { [""] = true, [" "] = true, ["\t"] = true }
local l_quote_prefix_map = {
  [""] = true,
  [" "] = true,
  ["\t"] = true,
  ["("] = true,
  ["["] = true,
  ["{"] = true,
  ["<"] = true,
  ["="] = true,
  [":"] = true,
  [","] = true,
  ["|"] = true,
  ["!"] = true,
  ["+"] = true,
  ["-"] = true,
  ["*"] = true,
  ["/"] = true,
  ["&"] = true,
  ["~"] = true,
  ["%"] = true,
  ["f"] = true,
  ["F"] = true,
  ["r"] = true,
  ["R"] = true,
  ["b"] = true,
  ["B"] = true,
  ["u"] = true,
  ["U"] = true,
}

-- NOTE(jlima): Reads an exact 2-byte buffer window around the cursor via one call to avoid allocating entire minified lines.
local function get_adjacent_chars()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local start_col = col > 0 and (col - 1) or 0
  local text = vim.api.nvim_buf_get_text(0, row, start_col, row, col + 1, {})[1] or ""

  local prev_char = col == 0 and "" or text:sub(1, 1)
  local next_char = col == 0 and text:sub(1, 1) or text:sub(2, 2)
  return prev_char, next_char, col
end

local function handle_open(char, close_char)
  local prev_char, next_char = get_adjacent_chars()
  if char == "{" and prev_char == "{" and next_char == "}" then
    return "{  }<C-g>U<Left><Left>"
  end

  local is_allowed = (next_char == "") or r_bracket_map[next_char]
  -- NOTE(jlima): Strict exception to support Ansible Jinja "{{  }}". ONLY "{" is permitted to auto-close inside quotes.
  if char == "{" and (next_char == '"' or next_char == "'") then
    is_allowed = true
  end

  if not is_allowed then
    return char
  end
  return char .. close_char .. "<C-g>U<Left>"
end

local function handle_close(char)
  local _, next_char = get_adjacent_chars()
  return next_char == char and "<Right>" or char
end

local function handle_quote(char)
  local prev_char, next_char = get_adjacent_chars()
  if next_char == char then
    return "<Right>"
  end
  if not l_quote_prefix_map[prev_char] or not r_quote_ws_map[next_char] then
    return char
  end
  return char .. char .. "<C-g>U<Left>"
end

vim.keymap.set("i", "{", function()
  return handle_open("{", "}")
end, { expr = true })
vim.keymap.set("i", "}", function()
  return handle_close("}")
end, { expr = true })
vim.keymap.set("i", ")", function()
  return handle_close(")")
end, { expr = true })
vim.keymap.set("i", "]", function()
  return handle_close("]")
end, { expr = true })
vim.keymap.set("i", "`", function()
  return handle_quote("`")
end, { expr = true })

vim.keymap.set("i", "<BS>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col > 0 and my_pair_map[prev_char] and my_pair_map[prev_char] == next_char then
    return "<BS><Del>"
  end
  return "<BS>"
end, { expr = true, replace_keycodes = true })

vim.keymap.set("i", "<CR>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col > 0 and next_char ~= "" then
    local pair = prev_char .. next_char
    if pair == "{}" or pair == "()" or pair == "[]" then
      return "<CR><C-o>O"
    end
  end
  return "<CR>"
end, { expr = true })

--------------------------------------------------------------------------------
-- 5. Keybindings & Emacs-Style Motions
--------------------------------------------------------------------------------
-- Remap ; to enter command-line mode directly
map({ "n", "x" }, ";", ":", nore)

-- Normal Mode Navigation & Baseline
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
-- NOTE(jlima): sacrifice insert-mode register paste (<C-r>) for directional search navigation
map("i", "<C-r>", "<C-o>?", silent)
map("i", "<C-s>", "<C-o>/", silent)
map("n", "<C-r>", "?", nore)
map("n", "<C-s>", "/", nore)

-- Window Switching
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)

-- Transients & Quickfix Control
map("n", "<C-t>", "<cmd>T<CR>", silent)
k("t", "<c-t>", [[<c-\><c-n><cmd>T<CR>]], silent)

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

-- Deterministic Save Execution (No undefined check_buf call)
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
map("n", "gp", "`[' . strpart(getregtype(), 0, 1) . ']`", { expr = true })

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

-- Macro execution in Visual Line
map("x", "@", function()
  return vim.fn.mode() == "V" and (":normal! @" .. vim.fn.getcharstr() .. "<CR>") or "@"
end, { expr = true })
map("x", "Q", function()
  return vim.fn.mode() == "V" and (":normal! @" .. vim.fn.reg_recorded() .. "<CR>") or "Q"
end, { expr = true })

--------------------------------------------------------------------------------
-- 6. User Commands & Helpers
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

  if state.buf == nil or not vim.api.nvim_buf_is_valid(state.buf) then
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
    vim.b[state.buf].lualine_disable = true

    vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
    -- NOTE(jlima): Send ETX (Ctrl-C) to clear previous blocked executions before issuing next build.
    if cmd ~= "" then
      vim.fn.chansend(state.job, "\x03")
      vim.fn.chansend(state.job, cmd .. "\n")
    end
    vim.cmd("startinsert")
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.buf then
      state.height = vim.api.nvim_win_get_height(win)
      if #get_normal_wins() > 1 then
        pcall(vim.api.nvim_win_hide, win)
      else
        vim.cmd("enew")
      end
      restore_editor_pos()
      return
    end
  end

  save_editor_pos()
  vim.cmd("botright split")
  vim.wo.winfixheight = true
  vim.cmd("resize " .. state.height)
  vim.api.nvim_win_set_buf(0, state.buf)
  state.win = vim.api.nvim_get_current_win()
  vim.wo.statusline = "%#Normal# "

  -- NOTE(jlima): Send ETX (Ctrl-C) to clear previous blocked executions before issuing next build.
  if cmd ~= "" then
    vim.fn.chansend(state.job, "\x03")
    vim.fn.chansend(state.job, cmd .. "\n")
  end
  vim.cmd("startinsert")
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
    local confirm = vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
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

  -- NOTE(jlima): Use nvim_get_option_value with pcall to prevent fatal __index errors on unlisted or dead bufs.
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
        -- NOTE(jlima): If no positive patterns exist, treat all non-excluded buffers as targets.
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
    -- NOTE(jlima): Verify buffer validity before checking modification state; deleting prior buffers can invalidate siblings.
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
    vim.notify(string.format("Closed %d buffer(s). Skipped %d modified buffer(s) (use :Da! to force).", closed, skipped_modified), vim.log.levels.WARN)
  else
    vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
  end
end, {
  bang = true,
  nargs = "?",
  complete = function(lead)
    local prefix, current_lead = lead:match("^(.*|)(.*)$")
    prefix = prefix or ""
    current_lead = current_lead or lead

    local excl_prefix = current_lead:match("^%s*(!)") or ""
    local query = current_lead:sub(#excl_prefix + 1)

    local bufs = vim.tbl_filter(function(b)
      if not vim.api.nvim_buf_is_valid(b) then
        return false
      end
      local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
      return ok and listed
    end, vim.api.nvim_list_bufs())

    local candidates = {}
    for _, buf in ipairs(bufs) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel = vim.fn.fnamemodify(name, ":.")
        if query == "" or rel:find(query, 1, true) then
          table.insert(candidates, prefix .. excl_prefix .. rel)
        end
      end
    end
    return candidates
  end,
  desc = "Close buffers matching pattern(s); prefix with '!' to exclude",
})

-- Auxiliary Commands & Abbreviations
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

vim.api.nvim_create_user_command("Rg", function(opts_args)
  local pattern = opts_args.args:gsub("|", "\\|")
  vim.cmd("silent! grep! " .. pattern)
  vim.cmd("copen")
  vim.cmd("redraw!")
end, { nargs = "+", complete = "file" })

vim.cmd([[
  cnoreabbrev qq qa!
  cabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() == 'w!!') ? 'w !sudo tee > /dev/null %' : 'w!!'
]])

--------------------------------------------------------------------------------
-- 7. Filetype Execution Runner Hooks
--------------------------------------------------------------------------------
-- NOTE(jlima): Absolute path expansion avoids relying on external shell env during I/O operations.
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
  -- NOTE(jlima): O_TRUNC | O_CREAT | O_WRONLY guarantees atomic file recreation without leftover byte tails.
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

  -- NOTE(jlima): Temporarily scope lcd to file directory so wildcards expand matching :T's working directory without leaking state.
  local expanded_cmd
  vim.api.nvim_buf_call(bufnr, function()
    local saved_cwd = vim.fn.getcwd()
    vim.cmd.lcd(buf_dir)
    expanded_cmd = vim.fn.expandcmd(raw_cmd)
    vim.cmd.lcd(saved_cwd)
  end)

  if expanded_cmd and expanded_cmd ~= "" then
    -- NOTE(jlima): Chaining cd before execution ensures an existing terminal process synchronizes CWD without scraping terminal buffer state.
    local escaped_dir = vim.fn.fnameescape(buf_dir)
    vim.cmd(string.format("T cd %s && %s", escaped_dir, expanded_cmd))
  end
end

local function save_and_execute_hook()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].buftype == "" and vim.bo[bufnr].modified then
    if vim.api.nvim_buf_get_name(bufnr) == "" then
      -- NOTE(jlima): Blocking update on unnamed modified buffers enforces the materialized path invariant and prevents E32 crashes.
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

  -- NOTE(jlima): Passing no arguments presents an interactive edit prompt with existing command; empty input clears.
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

-- Hook Execution Keybinding
map("n", "<leader>r", save_and_execute_hook, { noremap = true, silent = true, desc = "Save and run filetype hook" })

--------------------------------------------------------------------------------
-- 8. Native Package Manager (vim.pack)
--------------------------------------------------------------------------------

-- NOTE(jlima): Declaratively ensure plugins via native package manager API.
vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/stevearc/oil.nvim" },
}, { confirm = false })

-- NOTE(jlima): Guard oil setup to prevent hard failure prior to first vim.pack sync.
local has_oil, oil = pcall(require, "oil")
if has_oil then
  oil.setup()
  map("n", "-", "<cmd>Oil<CR>", silent)
end
