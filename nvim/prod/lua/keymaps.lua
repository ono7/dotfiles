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
for i = 1, 8 do
	map(modes, "<C-" .. i .. ">", i .. "gt")
end

-- Path lcd helper
local function trim_path(s)
	return #s < 50 and s or s:sub(-(#s / 2))
end

map("n", "<M-c>", function()
	vim.cmd.lcd("%:p:h")
	print("new lcd: " .. trim_path(vim.fn.getcwd()))
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

-- Backspace Auto-Pair Deletion
-- NOTE(jlima): Pre-encode keycodes at load time so replace_keycodes can be disabled on the hot path.
local bs_raw = vim.api.nvim_replace_termcodes("<BS>", true, false, true)
local bs_del_raw = vim.api.nvim_replace_termcodes("<BS><Del>", true, false, true)

-- NOTE(jlima): Map ASCII byte values directly to avoid string slicing and allocations per keystroke.
local pair_bytes = {
	[40] = 41, -- ( -> )
	[91] = 93, -- [ -> ]
	[123] = 125, -- { -> }
	[60] = 62, -- < -> >
	[39] = 39, -- ' -> '
	[34] = 34, -- " -> "
	[96] = 96, -- ` -> `
}

map("i", "<BS>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col == 0 then
		return bs_raw
	end

	local line = vim.api.nvim_get_current_line()
	local prev_byte, next_byte = string.byte(line, col, col + 1)

	-- NOTE(jlima): Strictly deletes paired tokens only; nil next_byte at EOL safely evaluates to false.
	if pair_bytes[prev_byte] == next_byte and next_byte ~= nil then
		return bs_del_raw
	end
	return bs_raw
end, { expr = true, replace_keycodes = false, noremap = true })

-- Bracket Expansion with Auto-Close & Whitespace Precondition
local bracket_pair_map = { ["{"] = "}", ["("] = ")", ["["] = "]" }
map("i", "<CR>", function()
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
				if next_char == close_char then
					return "<CR><C-o>O"
				end
				return close_char .. "<Left><CR><C-o>O"
			end
		end
	end
	return "<CR>"
end, { expr = true })

-- Emacs Insert Mode Navigation
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

-- Quickfix & Execution Maps
map("n", "<M-m>", function()
	local save = vim.fn.winsaveview()
	vim.cmd("silent make!")
	vim.fn.winrestview(save)
	if #vim.fn.getqflist() > 0 then
		vim.cmd("copen")
		vim.cmd("wincmd p")
	else
		vim.cmd("cclose")
		print("Build complete..")
	end
end, silent)

map("x", "@", function()
	return vim.fn.mode() == "V" and (":normal! @" .. vim.fn.getcharstr() .. "<CR>") or "@"
end, { expr = true })

map("n", "<leader>te", function()
	local dir = vim.fn.expand("%:p:h")
	vim.fn.jobstart({ "alacritty", "--working-directory", dir }, { detach = true })
end, { desc = "Open Alacritty in current directory" })

-- Native VimL Utility Remaps & Abbreviations
vim.cmd([[
  nnoremap gm :lcd %:p:h<CR>:!git add %:t && git commit -m "<C-r>=expand('%:t')<CR>: "<Left>
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  inoremap <M-u> <Esc>gUiwea
  inoremap <M-l> <Esc>guiwea
  xnoremap & :<C-u>'<,'>s/\%V\v

  cnoreabbrev qq qa!
  cabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() == 'w!!') ? 'w !sudo tee > /dev/null %' : 'w!!'
  cabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'silent update \| silent make! \| redraw!' : 'make'
]])
