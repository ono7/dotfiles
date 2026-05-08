return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main", -- Using the v1.0 native API branch
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
        -- =========================================================
        -- SHORT CIRCUIT 1: Ignore Large Files
        -- =========================================================
        if vim.b[args.buf].large_file then
          vim.notify("Large file detected", vim.log.levels.WARN)
          return
        end

        -- =========================================================
        -- SHORT CIRCUIT 2: Ignore UI and internal filetypes
        -- =========================================================
        local ignored_filetypes = {
          fzf = true,
          lazy = true,
          oil = true,
          netrw = true,
          qf = true,
          TelescopePrompt = true,
          mason = true,
          fidget = true,
          notify = true,
        }
        if ignored_filetypes[args.match] then
          return
        end

        -- =========================================================
        -- START TREESITTER
        -- =========================================================
        -- Attempt to start treesitter natively.
        -- pcall safely catches and ignores missing parsers.
        local success = pcall(vim.treesitter.start, args.buf)
        if not success then
          -- If it fails, try to find out what language it needed and install it quietly
          local lang = vim.treesitter.language.get_lang(args.match) or args.match
          if lang and lang ~= "" then
            pcall(function()
              require("nvim-treesitter").install(lang)
            end)
          end
          return
        end

        -- =========================================================
        -- APPLY NATIVE FEATURES
        -- =========================================================
        -- Folds (Native Neovim API per official docs)
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        -- Indentation (Provided by nvim-treesitter API)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
