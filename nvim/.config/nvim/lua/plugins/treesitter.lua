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

    -- 3. Install missing parsers (install() acts as a safe no-op if already installed)
    require("nvim-treesitter").install(ensure_installed)

    -- 4. Native Autocmd for Highlighting, Folds, and Indentation
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterNativeSetup", { clear = true }),
      pattern = "*",
      callback = function(args)
        -- Attempt to start treesitter natively.
        -- pcall prevents a hard crash if a parser is uninstalled or corrupted.
        local success = pcall(vim.treesitter.start, args.buf)
        if not success then
          return
        end

        -- Folds (Native Neovim API per official docs)
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        -- Indentation (Provided by nvim-treesitter API)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
