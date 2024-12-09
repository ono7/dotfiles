return {
  "nvim-telescope/telescope.nvim",
  version = false,
  lazy = false,
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make", -- linux, macos (requires gcc,clang,make)
    },
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "natecraddock/workspaces.nvim", -- manage my workspaces
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        local telescope = require("telescope")
        telescope.load_extension("ui-select")
      end,
    },
  },
  config = function()
    local opt = { noremap = true, silent = true }
    local k = vim.keymap.set

    local telescope = require("telescope")
    local actions = require("telescope.actions")
    -- local trouble = require("trouble.sources.telescope")
    local icons = require("config.icons")

    -- 

    -- local layout_width = 0.9
    local with_dropdown = {
      theme = "dropdown",
      layout_config = {
        center = {
          height = 0.8,
          preview_cutoff = 40,
          prompt_position = "top",
          width = 0.9,
        },
      },
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
      },
    }

    local fd_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--no-ignore-vcs" }

    require("telescope").setup({
      file_ignore_patterns = { "%.git/." },
      pickers = {
        find_files = with_dropdown,
        git_files = with_dropdown,
        oldfiles = with_dropdown,
        buffers = with_dropdown,
        live_grep = {
          mappings = {
            i = { ["<c-f>"] = actions.to_fuzzy_refine },
          },
        },
      },
      extensions = {
        wrap_results = true,
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },

      defaults = {
        -- prompt_prefix = "🔍 ",
        prompt_prefix = " " .. icons.ui.Telescope .. " ",
        selection_caret = icons.ui.BoldArrowRight .. " ",
        file_ignore_patterns = { "node_modules", "package-lock.json" },
        initial_mode = "insert",
        select_strategy = "reset",
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        sorting_strategy = "ascending",
        layout_config = {
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5,
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
    })

    -- pcall(require("telescope").load_extension, "fzf")
    -- pcall(require("telescope").load_extension, "ui-select")
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("workspaces")

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<space>b", builtin.current_buffer_fuzzy_find)

    k("n", "<leader>vc", function()
      builtin.git_files({
        previewer = false,
        cwd = "~/.dotfiles",
        hidden = true,
        show_untracked = true,
        no_ignore = false,
      })
    end)

    k("n", "<leader>fw", function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, opt)

    k("n", "<leader>fW", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, opt)

    k("n", "<leader>d", function()
      builtin.diagnostics({ previewer = false })
    end, opt)

    -- does not use find_command
    vim.keymap.set("n", "<leader>g", function()
      builtin.live_grep({
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-u",
          "--glob",
          "!venv",
          "--glob",
          "!.collections",
          "--glob",
          "!.git",
          "--glob",
          "!tags",
        },
        show_untracked = true,
        no_ignore = false,
      })
    end, { desc = "Live grep with rg" })

    k("n", "<leader>w", function()
      builtin.buffers({ previewer = false })
    end, opt)

    k("n", "<leader>s", function()
      builtin.lsp_document_symbols({ previewer = true, show_line = true })
    end, opt)

    k("n", "<D-w>", ":Telescope workspaces<cr>", opt)

    k("n", "<leader>S", function()
      builtin.lsp_workspace_symbols({ previewer = true, show_line = true })
    end, opt)

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
          prompt_title = "Project files (git)",
          cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
        })
      else
        print("cwd not a git project")
      end
    end

    -- Keymapping for Git files using fd
    -- uses ~/.config/fd/ignore so not all git files are listed
    -- however we traverse back to the git root directory from anywhere in the project which is a win!
    vim.keymap.set(
      { "n", "x" },
      "<c-p>",
      fd_git_files,
      { noremap = true, silent = true, desc = "Find Git files using fd" }
    )

    -- k("n", "<c-s>", [[:bro oldfiles<CR>]], opt)

    -- see picker options
    k("n", "<c-s>", function()
      require("telescope.builtin").oldfiles({})
    end)
  end,
}
