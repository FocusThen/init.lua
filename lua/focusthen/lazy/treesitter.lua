return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- pin: old config API. main branch rewrote setup()
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdate", "TSInstall", "TSUpdateSync" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"c",
					"lua",
					"rust",
					"jsdoc",
					"bash",
					"go",
					"c_sharp",
					"json",
					"html",
					"zig",
				},
				sync_install = false,
				auto_install = true,
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						if lang == "html" then
							return true
						end
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
					additional_vim_regex_highlighting = { "markdown" },
				},
			})
		end,
	},
}

