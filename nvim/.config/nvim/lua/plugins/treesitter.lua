return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    -- lazy = false,
    branch = "main",
    version = false,
    build = ":TSUpdate",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    config = function()
      local ts = require("nvim-treesitter")
      local ts_cfg = require("nvim-treesitter.config")
      local parsers = require("nvim-treesitter.parsers")

      local ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "groovy",
        "hcl",
        "html",
        "javascript",
        "jsdoc",
        "json",
        --"jsonnet",
        -- "json5", -- https://json5.org
        "just",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "sql",
        "terraform",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zig",
        "zsh",
      }
      local installed = ts_cfg.get_installed()
      local to_install = vim
        .iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()

      if #to_install > 0 then
        ts.install(to_install)
      end

      local ignore_filetype = {
        "checkhealth",
        "lazy",
        "mason",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_win",
        "snacks_input",
        "snacks_picker_input",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "spectre_panel",
        "NvimTree",
        "undotree",
        "Outline",
        "sagaoutline",
        "copilot-chat",
        "vscode-diff-explorer",
      }

      local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        desc = "Enable TreeSitter highlighting and indentation",
        callback = function(ev)
          local ft = ev.match

          if vim.tbl_contains(ignore_filetype, ft) then
            return
          end

          local lang = vim.treesitter.language.get_lang(ft) or ft
          local buf = ev.buf
          pcall(vim.treesitter.start, buf, lang)

          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
