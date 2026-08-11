return {
	"saghen/blink.cmp",
	version = "1.*", -- prebuilt Rust fuzzy matcher ships with tagged releases
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		-- Keymaps carried over 1:1 from the old nvim-cmp setup.
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-y>"] = { "select_and_accept", "fallback" },
			["<CR>"] = { "select_and_accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = {
			-- Matches the old `preselect = None` + `confirm({ select = true })`:
			-- nothing is preselected, but <CR>/<C-y> take the first item.
			list = { selection = { preselect = false, auto_insert = true } },
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			menu = { border = "rounded" },
		},
		signature = { enabled = true, window = { border = "rounded" } },
		-- blink's own snippet source reads friendly-snippets off the runtimepath,
		-- so LuaSnip + cmp_luasnip are no longer needed.
		sources = { default = { "lsp", "path", "snippets", "buffer" } },
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
