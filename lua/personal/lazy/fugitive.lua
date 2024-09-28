return {
	"tpope/vim-fugitive",
	config = function()
		-- vim.keymap.set({ "n", "i", "v" }, "\\g", vim.cmd.Git)
		vim.keymap.set({ "n", "i", "v" }, "<C-x>g", function()
			vim.cmd("vert Git")
		end)
	end,
}
