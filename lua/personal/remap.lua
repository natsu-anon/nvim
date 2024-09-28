vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "-", vim.cmd.Ex) -- TODO: dired THAT WORKS pls :(

-- emacs brainrot
-- vim.keymap.set({ "n", "i", "v" }, "<C-g>", "<Esc>")
vim.keymap.set({ "n", "v" }, "<A-x>", ":")
vim.keymap.set("i", "<A-x>", "<C-o>:")
-- vim.keymap.set({ "n", "i", "v" }, "<C-x>d", vim.cmd.Ex)
local quick_help = function(word)
	if word ~= nil then
		vim.cmd("vert help " .. word)
	end
end
vim.keymap.set("n", "<leader>hw", function()
	quick_help(vim.fn.expand("<cword>"))
end)
vim.keymap.set("n", "<leader>hW", function()
	quick_help(vim.fn.expand("<cWORD>"))
end)
vim.keymap.set({ "n", "v" }, "<C-c>h", ":help ")
vim.keymap.set("i", "<C-c>h", "<C-o>:help ")
-- vim.keymap.set("n", "<leader>hi", ":vert help ")
-- this is also Emacs but its BRAINGROWTH
vim.keymap.set("i", "<A-BS>", "<C-o>diw")
vim.keymap.set("n", "[b", vim.cmd.bprevious, { desc = "Previous buffer" })
vim.keymap.set("n", "]b", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set({ "n", "v" }, "<C-c>r", vim.cmd.make, { desc = "Run make" })
vim.keymap.set("n", "g c", vim.cmd.copen, { desc = "Open the Quicklist" })
vim.keymap.set("n", "<C-c>s", ":grep ", { desc = "grep and jump to the first result" })

-- SEE lazy/autocomplete.lua
--vim.keymap.set("i", "<C-CR>", "<C-y>")
--vim.keymap.set("i", "<C-BS>", "<C-e>")
--vim.keymap.set("i", "<C-j>", "<C-n>")
--vim.keymap.set("i", "<C-k>", "<C-p>")

-- enable some basic moving about to facilitate navigating autopairings
--vim.keymap.set("i", "<C-l>", "<C-o>e")
--vim.keymap.set("i", "<C-h>", "<C-o>b")
-- NOTE: moved to treesitter (see treesitter textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
-- haha thats a lie haha

-- vim.api.nvim_get_selection()

-- trad Y
vim.keymap.set("n", "Y", "V y")

-- simple quick add surrounding
vim.keymap.set("v", "<leader>'", "c'<C-r>\"'")
vim.keymap.set("v", '<leader>"', 'c"<C-r>""')
vim.keymap.set("v", "<leader>}", 'c{<C-r>"}')
vim.keymap.set("v", "<leader>]", 'c[<C-r>"]')
vim.keymap.set("v", "<leader>)", 'c(<C-r>")')
vim.keymap.set("v", "<leader>>", 'c<<C-r>">')

-- interact with system clipboard
vim.keymap.set("v", "<leader>xy", '"+y')
vim.keymap.set("v", "<leader>xp", '"+p')
vim.keymap.set("n", "<leader>xp", '"+p')
vim.keymap.set("n", "<leader>xP", '"+P')

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<C-c>d", vim.diagnostic.open_float, { desc = "Show [D]iagnostic error messages" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { desc = "Previous Error/Grep" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Error/Grep" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set({ "n", "v" }, "<C-c>q", vim.cmd.copen, { desc = "Open the Quicklist" })
vim.keymap.set("n", "[l", vim.cmd.lprevious, { desc = "Previous Location" })
vim.keymap.set("n", "]l", vim.cmd.lnext, { desc = "Next Location" })
vim.keymap.set({ "n", "v" }, "<C-c>l", vim.cmd.lopen, { desc = "Open the Location List" })
-- bruh

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` fo a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- vim.keymap.set("n", "\\t", function()
-- 	vim.cmd.vsplit()
-- 	vim.cmd.terminal()
-- end)
vim.keymap.set("n", "<C-c>t", vim.cmd.tabnew, { desc = "tabnew" })
-- vim.keymap.set("n", "<leader>cd", function()
-- 	local dir = vim.fs.normalize(vim.fs.dirname(vim.fn.expand("%:p")))
-- 	vim.fn.chdir(dir)
-- 	print("cd " .. dir)
-- end)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
