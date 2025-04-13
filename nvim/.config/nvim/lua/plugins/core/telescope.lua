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
    local set_keys = require("utils.keys")

    local opt = { noremap = true, silent = true }
    local k = vim.keymap.set

    local telescope = require("telescope")
    local actions = require("telescope.actions")
    -- local trouble = require("trouble.sources.telescope")
    local icons = require("config.icons")

    require("telescope").load_extension("fzf")

    local default_maps = {
      i = {
        [set_keys.prefix("f")] = actions.to_fuzzy_refine,
        [set_keys.prefix("p")] = actions.move_selection_previous,
        [set_keys.prefix("n")] = actions.move_selection_next,
        [set_keys.prefix("q")] = actions.smart_add_to_qflist + actions.open_qflist,
        [set_keys.prefix("x")] = actions.select_horizontal,
        [set_keys.prefix("v")] = actions.select_vertical,

        -- ["<C-f"] = actions.to_fuzzy_refine,
        -- ["<C-p>"] = actions.move_selection_previous,
        -- ["<C-n>"] = actions.move_selection_next,
        -- ["<C-q"] = actions.smart_add_to_qflist + actions.open_qflist,
        -- ["<C-x"] = actions.select_horizontal,
        -- ["<C-v"] = actions.select_vertical,
        ["<M-p>"] = actions.move_selection_previous,
        ["<M-n>"] = actions.move_selection_next,
        -- ["<D-p>"] = actions.move_selection_previous,
        -- ["<D-n>"] = actions.move_selection_next,
        -- ["<M-x>"] = actions.select_horizontal,
        -- ["<M-v>"] = actions.select_vertical,
      },
      n = { ["q"] = actions.close },
    }

    local with_dropdown = {
      theme = "ivy",
    }

    local fd_command = {
      "fd",
      "--type",
      "f",
      "--strip-cwd-prefix",
      "--hidden",
      "--no-ignore", -- Don't use any default ignore files
      "--ignore-file",
      vim.fn.expand("~/.config/fd/ignore"), -- Expand the path explicitly
    }

    require("telescope").setup({
      file_ignore_patterns = { "%.git/." },
      pickers = {
        find_files = with_dropdown,
        git_files = with_dropdown,
        oldfiles = with_dropdown,
        buffers = with_dropdown,
        workspaces = with_dropdown,
        diagnostics = { theme = "ivy" },
        live_grep = {
          mappings = default_maps,
          theme = "ivy",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- default true
          override_file_sorter = true, -- default true
          case_mode = "smart_case",
        },
        -- ["ui-select"] = {
        --   require("telescope.themes").get_dropdown({}),
        -- },
      },

      defaults = {
        theme = "ivy",
        mappings = default_maps,
        set_env = { ["COLORTERM"] = "truecolor" },
        -- prompt_prefix = "🔍 ",
        prompt_prefix = " " .. icons.ui.Telescope .. "  ",
        selection_caret = icons.ui.BoldArrowRight .. " ",
        entry_prefix = "  ",
        file_ignore_patterns = { "node_modules", "package-lock.json", ".git" },
        path_display = function(opts, path)
          local tail = require("telescope.utils").path_tail(path)
          path = string.format(" %s (%s)", tail, path) -- need extra space for iosevka/kitty icons are too large

          local highlights = {
            {
              {
                #tail + 2, -- highlight start position +2 = (path = string.format)
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

      mappings = default_maps,
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

    k("n", "<C-d>", function()
      builtin.diagnostics({ bufnr = 0, previewer = false, theme = "ivy" })
    end, opt)

    -- does not use find_command
    vim.keymap.set("n", "<M-g>", function()
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
        hidden = true,
        no_ignore = false,
        theme = "ivy",
        cwd = (function()
          local d = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          if d:match("not a git repository") then
            return "."
          end
          return d
        end)(),
      })
    end, { desc = "Live grep with rg" })

    k("n", "<M-b>", function()
      builtin.buffers({ previewer = false })
    end, opt)

    k("n", "<leader>s", function()
      builtin.lsp_document_symbols({ previewer = true, show_line = true })
    end, opt)

    k("n", "<M-w>", ":Telescope workspaces theme=ivy<CR>", opt)

    k("n", "<leader>S", function()
      builtin.lsp_workspace_symbols({ previewer = true })
    end, opt)

    --- handle all ignores in ~/.config/fd/ignore
    k({ "n", "x" }, "<M-f>", function()
      local opts = {
        hidden = true,
        show_untracked = true,
        find_command = fd_command,
        -- find_command = { "rg", "--files", "--sortr=modified" },
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
        return builtin.git_files({
          previewer = false,
          show_untracked = true,
          -- find_command = {
          --   "fd",
          --   "--type",
          --   "f",
          --   "--strip-cwd-prefix"
          -- },
          -- prompt_title = "Project files (git)",
          -- cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
        })
      else
        print("cwd not a git project")
      end
    end

    -- Keymapping for Git files using fd
    -- uses ~/.config/fd/ignore so not all git files are listed
    -- however we traverse back to the git root directory from anywhere in the project which is a win!
    vim.keymap.set({ "n" }, "<M-p>", fd_git_files, { noremap = true, silent = true, desc = "Find Git files using fd" })
    -- k("n", "<c-s>", [[:bro oldfiles<CR>]], opt)

    -- see picker options
    k("n", "<M-r>", function()
      require("telescope.builtin").oldfiles({})
    end)

    telescope.load_extension("ui-select")
    telescope.load_extension("workspaces")
  end,
}
