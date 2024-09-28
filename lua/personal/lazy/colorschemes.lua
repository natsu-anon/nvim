return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight-night")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		-- config = function()
		-- 	require("rose-pine").setup({
		-- 		disable_background = false,
		-- 	})
		-- end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		name = "monokai-pro",
		-- config = function()
		-- 	require("monokai-pro").setup({
		-- 		disable_background = false,
		-- 	})
		-- end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		conig = function()
			require("solarized-osaka").setup({
				transparent = false,
			})
		end,
	},
}
