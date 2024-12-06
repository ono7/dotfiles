local opt = { noremap = true, silent = true }
local k = vim.keymap.set

-- local function get_git_root()
--   local dot_git_path = vim.fn.finddir(".git", ".;")
--   if dot_git_path then
--     return vim.fn.fnamemodify(dot_git_path, ":h")
--   else
--     -- return "."
--     return false
--   end
-- end

local actions = require "telescope.actions"

-- 

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

local fd_command = { 'fd',
  '--type',
  'f',
  '--strip-cwd-prefix',
  '--hidden',
  '--no-ignore-vcs',
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
    prompt_prefix = "🔍 ",
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

k("n", "<leader>d", function() builtin.diagnostics({ previewer = false }) end, opt)

-- does not use find_command
vim.keymap.set("n", "<leader>g", function()
  builtin.live_grep {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '-u',
      '--glob', '!venv',
      '--glob', '!.collections',
      '--glob', '!.git',
      '--glob', '!tags'
    },
    show_untracked = true,
    no_ignore = false
  }
end, { desc = "Live grep with rg" })

k("n", "<c-b>", function() builtin.buffers({ previewer = false }) end, opt)

--- handle all ignores in ~/.config/fd/ignore
k({ "n", "x" }, "<c-f>", function()
  builtin.find_files({
    previewer = false,
    find_command = fd_command,
  })
end, opt)

-- Function to check if we're in a Git repository
local function is_git_repo()
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("true")
  end
  return false
end

-- Custom function to use fd for Git files
local function fd_git_files()
  if is_git_repo() then
    return builtin.find_files({
      previewer = false,
      find_command = fd_command,
      cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
    })
  else
    print("Not in a Git repository")
  end
end

-- Keymapping for Git files using fd
-- uses ~/.config/fd/ignore so not all git files are listed
-- however we traverse back to the git root directory from anywhere in the project which is a win!
vim.keymap.set({ "n", "x" }, "<c-p>", fd_git_files, { noremap = true, silent = true, desc = "Find Git files using fd" })

-- k("n", "<c-s>", [[:bro oldfiles<CR>]], opt)

-- see picker options
k("n", "<c-s>", function()
  require("telescope.builtin").oldfiles {}
end)
