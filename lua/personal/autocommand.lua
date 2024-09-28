-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Clear trailing write save before saving a buffer",
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Run a .projectile.lua in the pwd if it exists (for setting project-specific options--think makeprg)",
	callback = function()
		local fname = ".projectile.lua"
		if vim.fn.filereadable(fname) == 1 then
			vim.cmd.luafile(fname)
		end
	end,
})

-- THANKS, PROJECTILE
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	desc = "Change directory to project root if VCS detected",
-- 	pattern = { "*" },
-- 	callback = function(details)
-- 		local project_root = vim.fs.dirname(vim.fs.find(".git", { upward = true, path = details.file })[1])
-- 		if project_root ~= nil then
-- 			project_root = vim.fs.normalize(project_root)
-- 			vim.cmd.chdir(project_root)
-- 			print(string.format("cd %s", project_root))
-- 		end
-- 	end,
-- })
