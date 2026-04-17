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
      ols = {},
      zls = {},
      clangd = {},
      -- Ships with Xcode; restrict filetypes so clangd keeps C/C++.
      sourcekit = {
        filetypes = { "swift", "objc", "objcpp" },
      },
      jsonls = {},
      html = {},
      rust_analyzer = {}
    }

    local ensure_installed = {}
    for name in pairs(servers or {}) do
      if name ~= "sourcekit" then
        ensure_installed[#ensure_installed + 1] = name
      end
    end
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
      run_on_start = false,
      auto_update = false,
      start_delay = 5000, -- Wait 5 seconds before checking
    })
    require("mason-lspconfig").setup({
      automatic_installation = false, -- Don't auto-install missing servers on startup
    })

    -- Defer tool installation check even longer to not block startup
    vim.defer_fn(function()
      require("mason-tool-installer").check_install()
    end, 5000)

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
