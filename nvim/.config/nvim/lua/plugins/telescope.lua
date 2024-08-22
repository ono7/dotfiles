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

local actions = require "telescope.actions"

-- local layout_width = 0.9
local with_dropdown = {
  theme = "dropdown",
  layout_config = {
    center = {
      height = 0.8,
      preview_cutoff = 40,
      prompt_position = "top",
      width = 0.9
    },
  },
  mappings = {
    i = { ["<c-f>"] = actions.to_fuzzy_refine },
  },
}

require("telescope").setup {
  pickers = {
    find_files = with_dropdown,
    git_files = with_dropdown,
    oldfiles = with_dropdown,
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
      center = {
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5
      },
    },
    path_display = { "truncate" },
    preview = false,
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

k({ "n", "x" }, "<c-b>", function() builtin.buffers({ previewer = false }) end, opt)

k({ "n", "x" }, "<c-f>", function()
  -- builtin.find_files({ no_ignore = false, hidden = true, cwd = get_git_root() })
  builtin.find_files({ no_ignore = false, hidden = true, previewer = false })
end, opt)

k({ "n", "x" }, "<c-p>", function()
  builtin.git_files({ no_ignore = false, hidden = true, previewer = false })
end, opt)

-- k("n", "<c-s>", [[:bro oldfiles<CR>]], opt)

-- see picker options
k("n", "<c-s>", function()
  require("telescope.builtin").oldfiles {}
end)

-- k("n", "<leader>ff", function()
--   vim.ui.input({ prompt = "Enter directory path: " }, function(input)
--     require("telescope.builtin").find_files({ cwd = input })
--   end)
-- end)
