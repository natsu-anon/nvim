-- TODO: replace vim.uv.spawn with vim.system -- it throws an error if cmd CANNOT be run which is BETTER!

local M = {}

local augroup = vim.api.nvim_create_augroup("GDScript", { clear = true })

--- @alias gdscript.verbose boolean
--- @alias gdscript.port integer
--- @alias gdscript.bin string? default godot version to use
--- @alias gdscript.lsp_port integer
--- @alias gdscript.lsp_cmd string command to attach to the GDScript LSP (doesn't include host:port)
--- @alias gdscript.start_headless string keybind
--- @alias gdscript.kill_headless string keybind
--- @alias gdscript.restart_headless string keybind
--- @alias gdscript.edit_project string keybind
--- @alias gdscript.search_docs string keybind
--- @alias sys_obj vim.SystemObj?
M.verbose = false
M.headless_port = 6008
M.bin = "godot"
M.lsp_port = 6008
M.dap_port = 6009
M.lsp_cmd = "nc"
M.start_headless = "<C-c>gs"
M.kill_headless = "<C-c>gq"
-- M.restart_headless = "<C-c>gr"
M.edit_project = "<C-c>ge"
M.search_docs = "<C-c>gk"
M.change_port = "<C-c>gp"
local sys_obj = nil

local function project_file(file)
	local res = vim.fs.find("project.godot", { upward = true, path = file })[1]
	if res == nil then
		return nil
	end
	return vim.fs.normalize(res)
end

local function _start(godot_project, port, bin)
	return vim.system({ bin, "-e", "--headless", "--lsp-port", port, godot_project }, { detach = false })
end

local function kill()
	if sys_obj ~= nil then
		sys_obj.kill("sigint")
		sys_obj = nil
	end
end

local function start_godot_process(godot_project)
	kill()
	if M.bin == nil then
		print("No Godot binary set!")
		return
	end
	sys_obj = _start(godot_project, M.headless_port, M.bin)
	if M.verbose then
		print("Launched Godot on port:" .. M.headless_port)
	end
end

M.start = function()
	local project = project_file(vim.fn.expand("%:p"))
	if project == nil then
		if M.verbose then
			print("No Godot project found!")
		end
		return
	end
	start_godot_process(project)
end

local edit = function()
	if M.bin == nil then
		if M.verbose then
			print("No Godot binary set!")
		end
		return
	end
	local project = project_file(vim.fn.expand("%:p"))
	if project == nil then
		if M.verbose then
			print("No Godot project found!")
		end
		return
	end
	vim.system({ M.bin, "-e", "project" }, { detach = true })
end

local configure_lsp = function(port)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
	local config = require("lspconfig")
	local util = config.util
	config.gdscript.setup({
		name = "gdscript",
		cmd = { M.lsp_cmd, "localhost", port },
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities()),
		root_dir = util.root_pattern("project.godot", ".git"),
	})
end

local change_port = function()
	local port = vim.fn.input({
		prompt = "new GDScript LSP port: ",
		default = M.lsp_port,
		cancelreturn = M.lsp_port,
	})
	if port == M.lsp_port then
		return
	end
	configure_lsp(port)
	M.lsp_port = port
end

local search_docs = function(query)
	local q = query:gsub(" ", "+")
	vim.ui.open("https://docs.godotengine.org/en/stable/search.html?q=" .. q .. "&check_keywords=yes&area=default")
end

M.setup = function(args)
	M = vim.tbl_deep_extend("force", M, args)
	configure_lsp(M.lsp_port)
	vim.api.nvim_create_user_command(
		"GDScriptStart",
		M.start,
		{ desc = "(Re)start Godot headlessly on port " .. M.headless_port }
	)
	vim.api.nvim_create_user_command("GDScriptKill", kill, { desc = "Kill an existing headless Godot process" })
	vim.api.nvim_create_user_command("GDScriptPort", change_port, { desc = "Change the port GDScript LSP client uses" })
	vim.api.nvim_create_user_command("Godot", edit, { desc = "Edit project in Godot" })
	vim.keymap.set("n", M.start_headless, M.start, { desc = "(Re)start Godot headlessly on port: " .. M.headless_port })
	vim.keymap.set("n", M.kill_headless, kill, { desc = "Kill an existing headless Godot process" })
	vim.keymap.set("n", M.edit_project, edit, { desc = "Edit project in Godot" })
	vim.keymap.set({ "n", "v" }, M.search_docs, function()
		local query = vim.fn.input({
			prompt = "Search Godot Docs: ",
			default = vim.fn.expand("<cword>"),
		})
		if query == "" then
			return
		end
		search_docs(query)
	end, { desc = "Search Godot Documentation" })
	vim.keymap.set("n", M.change_port, change_port, { desc = "Change the port GDScript LSP client uses" })
end

return M
