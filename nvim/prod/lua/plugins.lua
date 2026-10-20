-- Native Package Management
vim.pack.add({
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/dcampos/nvim-snippy" },
}, { confirm = false })

-- Snippets Engine
local has_snippy, snippy = pcall(require, "snippy")
if has_snippy then
	snippy.setup({
		snippet_dirs = "~/.dotfiles/nvim/snippets",
		mappings = {
			is = {
				["<Tab>"] = "expand_or_advance",
				-- ["<S-Tab>"] = "previous",
			},
			x = {
				["<leader>d"] = "cut_text",
			},
		},
	})
end

-- Code Formatting
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
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = false,
	},
})

-- Buffer-based File Explorer
local has_oil, oil = pcall(require, "oil")
if has_oil then
	oil.setup()
	vim.keymap.set("n", "<c-\\>", "<CMD>Oil<CR>")
end

-- Fuzzy Picker
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

	-- NOTE(jlima): Use pick.start directly to yield absolute paths without hitting mini.pick builtin tool validation errors
	local function pick_dotfiles()
		local dotfiles_dir = vim.fn.expand("~/.dotfiles")
		if vim.fn.isdirectory(dotfiles_dir) == 0 then
			vim.notify("Directory does not exist: " .. dotfiles_dir, vim.log.levels.WARN)
			return
		end

		local items
		if vim.fn.executable("fd") == 1 then
			local cmd = string.format(
				"fd --type f --hidden --exclude .git --absolute-path . %s",
				vim.fn.shellescape(dotfiles_dir)
			)
			items = vim.fn.systemlist(cmd)
		else
			items = vim.fs.find(function()
				return true
			end, { path = dotfiles_dir, type = "file", limit = math.huge })
		end

		pick.start({
			source = {
				items = items,
				name = "Dotfiles (~/.dotfiles)",
				choose = pick.default_choose,
			},
		})
	end

	pick.registry.oldfiles = pick_oldfiles
	pick.registry.dotfiles = pick_dotfiles

	local silent = { noremap = true, silent = true }
	vim.keymap.set("n", "<M-f>", "<cmd>Pick files<CR>", silent)
	vim.keymap.set("n", "<M-g>", "<cmd>Pick grep_live<CR>", silent)
	vim.keymap.set("n", "<M-r>", pick_oldfiles, silent)
	vim.keymap.set("n", "<leader>vs", pick_dotfiles, vim.tbl_extend("force", silent, { desc = "Find dotfiles" }))
end

-- Embedded Colorscheme: custom-paper-minimal
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
