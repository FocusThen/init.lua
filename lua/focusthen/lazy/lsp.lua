return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    { "mason-org/mason.nvim", cmd = "Mason" },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim"
  },
  config = function()
    require("mason").setup({
      ui = {
        check_outdated_packages_on_open = false,
      },
    })
    require("fidget").setup({})

    local servers = {
      lua_ls = {},
      omnisharp = {
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          MsBuild = {
            LoadProjectsOnDemand = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = true,
          },
          Sdk = {
            IncludePrereleases = true,
          },
        },
      },
      ols = {
        cmd = { "ols" },
        filetypes = { "odin" },
        root_markers = { "ols.json", ".git" }
      },
      zls = {},
      clangd = {},
      -- Ships with Xcode; restrict filetypes so clangd keeps C/C++.
      sourcekit = {
        filetypes = { "swift", "objc", "objcpp" },
      },
      jsonls = {},
      html = {},
      rust_analyzer = {},
      gopls = {},
      -- vue_ls runs in hybrid mode (CSS/HTML only) since v3, so TypeScript inside
      -- .vue files comes from vtsls loading @vue/typescript-plugin.
      vtsls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.expand(
                    "$MASON/packages/vue-language-server/node_modules/@vue/language-server"
                  ),
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      },
      vue_ls = {},
    }

    -- mason-lspconfig used to translate lspconfig names (lua_ls) into mason
    -- package names (lua-language-server). Without it the packages are listed
    -- directly, so keep this in sync with `servers` above. `sourcekit` ships
    -- with Xcode and `oxfmt` is a formatter, not a server.
    require("mason-tool-installer").setup({
      ensure_installed = {
        "clangd",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "ols",
        "omnisharp",
        "oxfmt",
        "rust-analyzer",
        "tree-sitter-cli", -- nvim-treesitter main branch compiles parsers with it
        "vtsls",
        "vue-language-server",
        "zls",
      },
      run_on_start = false,
      auto_update = false,
      start_delay = 5000, -- Wait 5 seconds before checking
    })

    -- Defer tool installation check even longer to not block startup
    vim.defer_fn(function()
      require("mason-tool-installer").check_install()
    end, 5000)

    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- Configure server-specific settings
    for server_name, server_config in pairs(servers) do
      if next(server_config) ~= nil then
        vim.lsp.config(server_name, server_config)
      end
    end

    -- Enable all LSP servers
    for server_name, _ in pairs(servers) do
      vim.lsp.enable(server_name)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("Focusthen", {}),
      callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>ws", function()
          vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
          vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", function()
          vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>rr", function()
          vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
          vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts)
        vim.keymap.set("n", "<leader>sf", vim.lsp.buf.format, opts)
      end,
    })
  end,
}
