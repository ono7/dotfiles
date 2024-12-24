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

    require("telescope").load_extension("fzf")

    local with_dropdown = {
      theme = "ivy",
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
        n = { ["q"] = actions.close },
      },
    }

    local fd_command = {
      "fd",
      "--type",
      "f",
      "--strip-cwd-prefix",
      "--hidden",
      -- "--no-ignore-vcs", -- Ignore all default ignore files
      "--ignore-file",
      "~/.config/fd/ignore",
    }

    require("telescope").setup({
      file_ignore_patterns = { "%.git/." },
      pickers = {
        find_files = with_dropdown,
        git_files = with_dropdown,
        oldfiles = with_dropdown,
        buffers = with_dropdown,
        workspaces = { theme = "ivy" },
        diagnostics = { theme = "ivy" },
        live_grep = {
          mappings = {
            i = { ["<c-f>"] = actions.to_fuzzy_refine },
            n = { ["q"] = actions.close },
          },
          theme = "ivy",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        -- ["ui-select"] = {
        --   require("telescope.themes").get_dropdown({}),
        -- },
      },

      defaults = {
        theme = "ivy",
        set_env = { ["COLORTERM"] = "truecolor" },
        -- prompt_prefix = "🔍 ",
        prompt_prefix = " " .. icons.ui.Telescope .. "  ",
        selection_caret = icons.ui.BoldArrowRight .. " ",
        entry_prefix = "  ",
        file_ignore_patterns = { "node_modules", "package-lock.json", ".git" },
        path_display = function(opts, path)
          local tail = require("telescope.utils").path_tail(path)
          path = string.format(" %s (%s)", tail, path)

          local highlights = {
            {
              {
                #tail + 2, -- highlight start position
                #tail + #path + 2, -- highlight end position
              },
              "Pmenu", -- highlight group name
            },
          }

          return path, highlights
        end,
        -- Add the extra space between icon and path using the entry formatter
        preview = false,
      },

      mappings = {
        i = {
          ["<c-k>"] = actions.move_selection_previous,
          ["<c-j>"] = actions.move_selection_next,
          ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
          -- ["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          -- ['<C-u>'] = false,
          -- ['<C-d>'] = false,
        },
        n = {
          n = { ["q"] = actions.close },
        },
      },
    })

    local builtin = require("telescope.builtin")

    -- vim.keymap.set("n", "<leader>b", builtin.current_buffer_fuzzy_find)

    k("n", "<leader>vc", function()
      builtin.git_files({
        previewer = false,
        cwd = "~/.dotfiles",
        hidden = true,
        show_untracked = true,
        prompt_title = "Dotfiles",
        no_ignore = false,
      })
    end)

    k("n", "<leader>d", function()
      builtin.diagnostics({ previewer = false, theme = "ivy" })
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
        theme = "ivy",
      })
    end, { desc = "Live grep with rg" })

    k("n", "<c-d>", function()
      builtin.buffers({ previewer = false })
    end, opt)

    k("n", "<leader>s", function()
      builtin.lsp_document_symbols({ previewer = true, show_line = true })
    end, opt)

    k("n", "<m-w>", ":Telescope workspaces theme=ivy<CR>", opt)

    k("n", "<leader>S", function()
      builtin.lsp_workspace_symbols({ previewer = true })
    end, opt)

    --- handle all ignores in ~/.config/fd/ignore
    k({ "n", "x" }, "<c-f>", function()
      local opts = {
        hidden = true,
        no_ignore = true,
        find_command = fd_command,
      }
      require("telescope.builtin").find_files(opts)
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

    telescope.load_extension("ui-select")
    telescope.load_extension("workspaces")
  end,
}
