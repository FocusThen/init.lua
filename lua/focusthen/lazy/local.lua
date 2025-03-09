local local_plugins = {
	{
		"floaterminal",
		dir = "~/personel/floaterminal.nvim",
	},
	{
		"musicPlayer",
		dir = "~/personel/music-player.nvim",
		config = function()
			require("music-player").setup({})
		end,
	},
}

return local_plugins
