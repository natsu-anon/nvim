-- NOTE: run `nvim-qt -qwindowgeometry WIDTHxHEIGHT` to launch nvim-qt with whatever dims you want
require("personal")
if vim.fn.filereadable("lua/local/init.lua") == 1 then
	require("local")
end

-- vim.cmd.colorscheme("monokai-pro-default")
vim.cmd.colorscheme("rose-pine-main")
-- vim.cmd.colorscheme("rose-pine-moon")
-- vim.cmd.colorscheme("rose-pine-dawn")
