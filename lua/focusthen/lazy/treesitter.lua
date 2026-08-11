-- nvim-treesitter `main` branch: no configs.setup(), no ensure_installed/highlight
-- tables. Parsers are installed imperatively and highlighting is started per buffer.
-- The old `master` branch predicates break on Neovim 0.12 (node:range() on nil).
local ensure_installed = {
	"bash",
	"c",
	"c_sharp",
	"css",
	"go",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"odin",
	"rust",
	"tsx",
	"typescript",
	"vimdoc",
	"zig",
}

local MAX_FILESIZE = 100 * 1024 -- 100 KB

-- Treesitter highlighting we deliberately don't want.
local disabled_filetypes = {
	html = true,
}

-- Filetypes that still want the legacy regex syntax on top of treesitter
-- (replaces master's `additional_vim_regex_highlighting`).
local extra_regex_syntax = {
	markdown = true,
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- config() installs the FileType autocmd; must run before the first one fires
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			local installed = {}
			for _, lang in ipairs(ts.get_installed("parsers")) do
				installed[lang] = true
			end

			-- The main branch shells out to the tree-sitter CLI to build parsers
			-- (the master branch only needed a C compiler). It comes from mason
			-- (`tree-sitter-cli`) or `brew install tree-sitter-cli`.
			local function has_tree_sitter_cli()
				if vim.fn.executable("tree-sitter") == 1 then
					return true
				end
				-- mason.nvim puts its bin dir on PATH, but it only loads on BufReadPre
				-- while this plugin runs at startup, so look there directly.
				local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
				if vim.fn.executable(vim.fs.joinpath(mason_bin, "tree-sitter")) == 1 then
					vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
					return true
				end
				return false
			end

			local has_cli = has_tree_sitter_cli()

			local missing = vim.tbl_filter(function(lang)
				return not installed[lang]
			end, ensure_installed)
			if #missing > 0 and has_cli then
				ts.install(missing)
			elseif #missing > 0 then
				vim.notify(
					"tree-sitter CLI not found; missing parsers: " .. table.concat(missing, ", "),
					vim.log.levels.WARN,
					{ title = "Treesitter" }
				)
			end

			local function too_big(buf)
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > MAX_FILESIZE then
					vim.notify(
						"File larger than 100KB treesitter disabled for performance",
						vim.log.levels.WARN,
						{ title = "Treesitter" }
					)
					return true
				end
				return false
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("focusthen_treesitter", { clear = true }),
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype
					if ft == "" or disabled_filetypes[ft] then
						return
					end

					local lang = vim.treesitter.language.get_lang(ft)
					if not lang or too_big(buf) then
						return
					end

					if not pcall(vim.treesitter.start, buf, lang) then
						-- Parser missing: install it in the background (master's `auto_install`).
						-- Highlighting kicks in the next time this filetype is opened.
						if has_cli and not installed[lang] and vim.tbl_contains(ts.get_available(), lang) then
							installed[lang] = true
							ts.install({ lang })
						end
						return
					end

					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					if extra_regex_syntax[ft] then
						vim.bo[buf].syntax = "on"
					end
				end,
			})
		end,
	},
}
