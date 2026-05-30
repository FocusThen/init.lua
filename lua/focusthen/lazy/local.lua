local local_plugins = {
	-- {
	-- 	"floaterminal",
	-- 	dir = "~/personel/floaterminal.nvim",
	-- },
	-- {
	-- 	"musicPlayer",
	-- 	dir = "~/personel/music-player.nvim",
	-- 	config = function()
	-- 		require("music-player").setup({})
	-- 	end,
	-- },
	{
		"OpenVpn",
  	dir = "~/personel/vpn.nvim",
  },
  {
    dir = vim.fn.expand("~/personel/project-todos.nvim"),
    config = function()
      require("project_todos").setup()

      vim.keymap.set("n", "<leader>td", function()
        require("project_todos").toggle_ui()
      end, { desc = "Project todos" })

      vim.keymap.set("n", "<leader>ta", function()
        vim.ui.input({ prompt = "Todo: " }, function(text)
          if text and vim.trim(text) ~= "" then
            require("project_todos").add(text)
          end
        end)
      end, { desc = "Project todos: add" })
    end,
  }
}

return local_plugins
