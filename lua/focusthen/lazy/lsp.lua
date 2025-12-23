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
  },
  config = function()
    require("mason").setup()
    local servers = {
      lua_ls = {},
      omnisharp = {},
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
    require("mason-lspconfig").setup()
    for _, server in ipairs(ensure_installed) do
      vim.lsp.enable(server)
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

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
