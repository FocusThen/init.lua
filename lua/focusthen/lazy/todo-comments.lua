return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")
		todo_comments.setup({
			signs = false,
			highlight = {
				keyword = "",
				after = "",
			},
		})
		vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>", { silent = true })
	end,
}
