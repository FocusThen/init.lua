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
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend(
			"force",
			capabilities,
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local servers = {
			clangd = {},
			gopls = {},
			rust_analyzer = {},
			ts_ls = {},
			omnisharp = {
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/omnisharp.cmd" },
				enable_ms_build_load_projects_on_demand = false,
				enable_editorconfig_support = true,
				enable_roslyn_analysers = true,
				enable_import_completion = true,
				organize_imports_on_format = true,
				enable_decompilation_support = true,
				analyze_open_documents_only = false,
				filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
			},
			lua_ls = {},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					if server_name == "lua_ls" then
						require("lspconfig")[server_name].setup({
							settings = {
								Lua = {
									completion = {
										callSnippet = "Replace",
									},
									diagnostics = { disable = { "missing-fields", "lowercase-global" } },
									workspace = {
										checkThirdParty = false,
										telemetry = { enable = false },
										library = {
											"${3rd}/love2d/library",
										},
									},
								},
							},
						})
					else
						require("lspconfig")[server_name].setup(server)
					end
				end,
			},
		})

		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
