return {
	"ThePrimeagen/harpoon",
	config = function()
		local harpoon = require("harpoon")
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		harpoon.setup({})

		vim.keymap.set("n", "<leader>a", mark.add_file)
		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

		vim.keymap.set("n", "<C-h>", function()
			ui.nav_next()
		end)
		vim.keymap.set("n", "<C-l>", function()
			ui.nav_prev()
		end)
	end,
}
