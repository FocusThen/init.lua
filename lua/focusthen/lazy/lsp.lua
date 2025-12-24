return {
  "neovim/nvim-lspconfig",
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
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim"
  },
  config = function()
    require("mason").setup()
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
      ols = {},
      zls = {},
      clangd = {},
      jsonls = {},
      ts_ls = {},
      html = {},
      rust_analyzer = {}
    }
    
    local ensure_installed = vim.tbl_keys(servers or {})
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    require("mason-lspconfig").setup({
      automatic_installation = true,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
        vim.keymap.set("n", "<leader>ca", function()
          vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>rr", function()
          vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
          vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = 1 })
        end, opts)
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = -1 })
        end, opts)
        vim.keymap.set("n", "<leader>s", vim.lsp.buf.format, opts)
      end,
    })
  end,
}
