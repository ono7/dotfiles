local opt = { noremap = true, silent = true }
local k = vim.keymap.set

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  if dot_git_path then
    return vim.fn.fnamemodify(dot_git_path, ":h")
  else
    -- return "."
    return false
  end
end

-- local data = assert(vim.fn.stdpath "data") --[[@as string]]

local actions = require "telescope.actions"

require("telescope").setup {
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    git_files = {
      theme = "dropdown",
    },
    oldfiles = {
      theme = "dropdown",
      cwd_only = false,
    },
    live_grep = {
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
      },
    },
  },
  extensions = {
    wrap_results = true,
    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
  defaults = {
    layout_config = {
      vertical = { width = 0.5 },
    },
    preview = false,
    file_ignore_patterns = {
      ".git/",
      ".venv/",
      ".cache",
      "__pycache__",
      "%.o",
      "%.a",
      "%.out",
      "%.pdf",
      "%.mkv",
      "%.zip",
      '%.npz',
      '%.aux',
      '%.otf',
      '%.ttf',
      '%.mp3',
      '%.sfd',
      '%.fmt',
      '%.jpg',
      '%.png',
    },
  },

  mappings = {
    i = {
      ["<c-k>"] = actions.move_selection_previous,
      ["<c-j>"] = actions.move_selection_next,
      -- ["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
      -- ['<C-u>'] = false,
      -- ['<C-d>'] = false,
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<space>fh", builtin.help_tags)
vim.keymap.set("n", "<space>fg", builtin.live_grep)
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

-- vim.keymap.set("n", "<space>gw", builtin.grep_string)
--
-- vim.keymap.set("n", "<space>fa", function()
--   ---@diagnostic disable-next-line: param-type-mismatch
--   builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
-- end)

k("n", "<leader>vc", function()
  builtin.git_files { previewer = false, cwd = '~/.dotfiles', hidden = true, show_untracked = true, no_ignore = false }
end)

k("n", "<leader>fw", function()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string { search = word }
end, opt)

k("n", "<leader>fW", function()
  local word = vim.fn.expand("<cWORD>")
  builtin.grep_string { search = word }
end, opt)

k("n", "<leader>fd", function() builtin.diagnostics({ previewer = false }) end, opt)

k("n", "<leader>g", function()
  builtin.live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-u' }, use_regex = true, show_untracked = true, no_ignore = false }
end, opt)

k({ "n", "x" }, "<s-tab>", function() builtin.buffers({ previewer = false }) end, opt)

k({ "n", "x" }, "<c-f>", function()
  -- builtin.find_files({ no_ignore = false, hidden = true, cwd = get_git_root() })
  builtin.find_files({ no_ignore = true, hidden = true, previewer = false })
end, opt)

k({ "n", "x" }, "<c-p>", function()
  builtin.git_files({ no_ignore = false, hidden = true, previewer = false })
end, opt)

-- k("n", "<c-s>", [[:bro oldfiles<CR>]], opt)


k("n", "<c-s>", function()
  require("telescope.builtin").oldfiles {}
end)


-- k("n", "<leader>ff", function()
--   vim.ui.input({ prompt = "Enter directory path: " }, function(input)
--     require("telescope.builtin").find_files({ cwd = input })
--   end)
-- end)
