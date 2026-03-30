return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- List of filetypes to NEVER attempt Treesitter on
      local skip_ft = {
        "fidget",
        "fzf",
        "TelescopePrompt",
        "NvimTree",
        "lazy",
        "mason",
        "notify",
        "noice",
      }

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- Skip if it's a known UI/Plugin filetype
          if vim.tbl_contains(skip_ft, args.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          -- 1. AUTO-INSTALL: Only install if we don't have it
          local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0
          if not is_installed then
            -- Use pcall here so it doesn't interrupt your workflow if install fails
            pcall(vim.cmd, "TSInstall " .. lang)
          end

          -- 2. HIGHLIGHT & INDENT: Enable only if queries exist
          if vim.treesitter.query.get(lang, "highlights") then
            pcall(function()
              vim.treesitter.start(args.buf, lang)
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end)
          end
        end,
      })
    end,
  },
}
