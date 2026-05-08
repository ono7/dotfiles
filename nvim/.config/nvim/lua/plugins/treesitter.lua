-- NOTE: Run :TSUninstall all, :TSInstall all on a fresh install of if something is currupted

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    -- 1. Register custom filetypes
    vim.filetype.add({
      extension = {
        csproj = "xml",
        esproj = "xml",
        keymap = "c",
        mdx = "markdown",
        uproject = "json",
        wsdl = "xml",
      },
    })

    -- 2. Define minimum required parsers
    local ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "gitcommit", "python", "yaml", "json" }

    -- 3. Install missing parsers
    require("nvim-treesitter").install(ensure_installed)

    -- 4. Native Autocmd for Highlighting, Folds, and Indentation
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterNativeSetup", { clear = true }),
      pattern = "*",
      callback = function(args)
        -- =========================================================
        -- SHORT CIRCUIT: Abort if your large file script flagged this buffer
        -- =========================================================
        if vim.b[args.buf].large_file then
          print("large file detected, no HL support")
          return
        end

        -- Attempt to start treesitter natively
        local success = pcall(vim.treesitter.start, args.buf)
        if not success then
          local lang = vim.treesitter.language.get_lang(args.match) or args.match
          if lang and lang ~= "" then
            pcall(function()
              require("nvim-treesitter").install(lang)
            end)
          end
          return
        end

        -- Folds
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        -- Indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
