-- NOTE: move to set when you're done with this tomofoolery

vim.opt.foldenable = false -- start off witht things folded vim.opt.foldmethod = "expr"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- v:foldstart
-- v:foldend
-- v:folddashes
function MyFoldText()
	-- return vim.fn.getline(vim.v.foldstart)
	--local line = vim.fn.getline(vim.v.foldstart)
	local start = vim.fn.getline(vim.v.foldstart)
	local close = vim.fn.getline(vim.v.foldend)
	local count = vim.v.foldend - vim.v.foldstart - 1
	--local sub = vim.fn.substitute(line, "/*|*/|{{{d=", "", "g")
	return vim.v.folddashes .. start .. "  +" .. count .. " lines  " .. close
end

vim.opt.foldtext = "v:lua.MyFoldText()"

vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "style folds sensibly",
	callback = function()
		local cl = vim.api.nvim_get_hl(0, { name = "CursorLineNr" })
		vim.api.nvim_set_hl(0, "FoldedIcon", { fg = cl.bg })
		vim.api.nvim_set_hl(0, "FoldedText", { bg = cl.bg, fg = cl.fg, italic = true })
	end,
})
