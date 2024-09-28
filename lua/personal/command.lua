vim.api.nvim_create_user_command("NvimConfig", function()
	vim.fn.chdir(vim.fn.stdpath("config"))
	vim.cmd.edit(vim.uv.cwd())
	-- local oil = require("oil")
	-- if oil ~= nil then
	-- 	oil.open()
	-- else
	-- 	vim.cmd.Ex()
	-- 	-- print("bruh")
	-- end
end, { desc = "cd to the neovim config directory" })

-- vim.api.nvim_create_user_command("DelSwaps", function() end, { desc = "deletes all swaps" })
vim.api.nvim_create_user_command("Swaps", function()
	local data_dir = vim.fs.normalize(vim.fn.stdpath("data"))
	vim.cmd.Ex(data_dir .. "/swap/")
end, { desc = "edit the swap directory" })
