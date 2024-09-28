local M = {}

M.open_projectile = "<leader>pp"
M.project_terminal = "<leader>pt"
-- M.project_chdir = "<leader>pd"
M.project_make = "<leader>pm"
local cfg_path = vim.fs.normalize(vim.fn.stdpath("config"))
local data_path = vim.fs.normalize(vim.fn.stdpath("data"))
local cache = string.format("%s/projectiles", data_path)
local project_paths = {}
local buffer_name = "[Projectile]"
local project_lua = "projectile.lua"
-- print(edit_regex)

local augroup = vim.api.nvim_create_augroup("Projectile", { clear = true })

local function _project_file(name, filepath)
	return vim.fs.dirname(vim.fs.find(name, { upward = true, path = filepath })[1])
end

local function get_project_dir(filepath)
	for dir in vim.fs.parents(filepath) do
		if vim.fs.normalize(dir) == cfg_path then
			return dir
		end
	end
	return _project_file(".git", filepath) or _project_file(project_lua, filepath)
end

local function load_cache()
	project_paths = {}
	local f = io.open(cache, "r")
	if f ~= nil then
		for line in f:lines() do
			table.insert(project_paths, line)
		end
	else
		f = io.open(cache, "a")
		project_paths = { cfg_path }
		f:write(cfg_path)
	end
	f:flush()
	f:close()
	return true
end

local function cache_project(path)
	local f = io.open(cache, "a")
	f:write("\n" .. vim.fs.normalize(path))
	f:flush()
	f:close()
	table.insert(project_paths, path)
end

local function has_project(path)
	for _, p in ipairs(project_paths) do
		if p == path then
			return true
		end
	end
	return false
end

-- local f = io.open(cache, "r")
-- if f ~= nil then
-- 	-- print("existing file")
-- 	for line in f:lines() do
-- 		print(line)
-- 		table.insert(project_paths, line)
-- 	end
-- else
-- 	f = io.open(cache, "a")
-- 	print("created file!")
-- end
-- f:flush()
-- f:close()

-- for _, v in ipairs(project_paths) do
-- 	print(k .. ": " .. v)
-- end
--
local function print_paths()
	for k, v in ipairs(project_paths) do
		print(k .. ": " .. v)
	end
end

local function project_buffer()
	for _, b_num in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.bufname(b_num) == buffer_name then
			return b_num
		end
	end
	local res = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(res, buffer_name)
	return res
end

local function populate_buffer(buffer)
	vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
	vim.api.nvim_buf_set_lines(buffer, 0, -1, true, project_paths)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
end

local function _enter_project()
	local dir = vim.api.nvim_get_current_line()
	vim.api.nvim_win_close(0, true)
	-- vim.fn.chdir(dir)
	vim.cmd.edit(dir)
	-- require("telescope.builtin").find_files()
	-- vim.cmd.edit(vim.uv.cwd())
	-- execute projectile.lua if it exists
	-- if vim.fn.filereadable(dir .. "/" .. project_lua) then -- NOTE: this is NOT working >:^(
	local src = dir .. "/" .. project_lua
	local f = io.open(src, "r")
	if f == nil then
		return
	end
	f:flush()
	f:close()
	vim.cmd.source(src)
end

M.enter_project = _enter_project

local function add_functionality(buffer)
	vim.keymap.set("n", "<CR>", M.enter_project, { buffer = buffer, silent = true, nowait = true })
	vim.keymap.set("n", "<TAB>", M.enter_project, { buffer = buffer, silent = true, nowait = true })
	vim.keymap.set("n", "<ESC>", function()
		vim.api.nvim_win_close(0, true)
	end, { buffer = buffer, silent = true, nowait = true })
	vim.keymap.set("n", "<C-c>", function()
		vim.api.nvim_win_close(0, true)
	end, { buffer = buffer, silent = true, nowait = true })
	vim.keymap.set("n", "<C-g>", function()
		vim.api.nvim_win_close(0, true)
	end, { buffer = buffer, silent = true, nowait = true })
	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = buffer,
		once = true,
		callback = function(_)
			vim.api.nvim_buf_delete(buffer, { force = true })
		end,
	})
end

local function create_project_buffer()
	local b = project_buffer()
	populate_buffer(b)
	add_functionality(b)
	return b
end

-- load_cache()
-- cache_project("lol lmao even")
-- print_paths()
-- create_project_buffer()
--

local function projectile()
	local b = create_project_buffer()
	local w = vim.api.nvim_open_win(b, true, {
		relative = "win",
		row = 14,
		col = 8,
		width = 80,
		height = 40,
		border = "rounded",
		style = "minimal",
		title = " Projectile ",
		title_pos = "center",
	})
	vim.api.nvim_win_set_option(w, "winhl", "Normal:Title")
	vim.opt.cursorline = true
	-- require("telescope.builtin").live_grep({
	--[[ require("telescope.builtin").find_files({
		cwd = data_path,
		-- search_dirs = { data_path },
		grep_open_files = false,
		glob_pattern = "projectiles",
		-- find_command = { "rg", "-g", "projectiles" },
		-- search_dirs = project_paths,
		-- find_command = { "fd", "--type", "d", "--color", "never" },
		-- find_command = { "fd", "--type", "d", "--color", "never" },
	}) ]]
end

local function chdir()
	local dir = get_project_dir(vim.fn.expand("%:p"))
	if dir == nil then
		return false
	end
	vim.cmd.chdir(dir)
	print("Projectile cd " .. dir)
	return true
end

local function terminal()
	if chdir() then
		vim.cmd.vsplit()
		vim.cmd.terminal()
	end
end

local function make()
	local scon = vim.fs.find("Sconstruct", { upward = true, path = vim.fn.expand("%:p") })[1]
	if scon ~= nil then
		print("Found: " .. scon)
		local handle, pid = vim.uv.spawn("scons", {
			cwd = vim.fs.dirname(scon),
			args = { "-Q" },
		}, function(code, signal)
			print("scons finished with code: " .. code)
		end)
		return
	end
end

M.setup = function(args)
	args = args or {}
	M = vim.tbl_deep_extend("force", M, args)
	load_cache()
	vim.api.nvim_create_user_command("Projectile", function(details)
		if details.args == "" then
			projectile()
		elseif string.match(details.args, "^[eE][dD]?[iI]?[tT]?") then
			vim.cmd.edit(cache)
		end
	end, { desc = "Open " .. buffer_name .. " floating window", force = true, nargs = "?" })
	vim.keymap.set("n", M.open_projectile, projectile, { desc = "Open the Projectile menu" })
	vim.keymap.set("n", M.project_terminal, terminal, { desc = "Open terminal in project root" })
	-- vim.keymap.set("n", M.project_chdir, chdir, { desc = "Chdir to project root" })
	vim.keymap.set("n", M.project_make, make, { desc = "Make the project" })
	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "Cache directory path if VCS detected",
		group = augroup,
		pattern = { "*" },
		callback = function(details)
			local dir = get_project_dir(details.file)
			if dir == nil or dir == "." or has_project(dir) then
				return
			end
			cache_project(dir)
			print("Project cached: " .. dir)
		end,
	})
	vim.api.nvim_create_autocmd("BufWritePost", {
		desc = "Update the loaded project table after editing the projectiles file",
		group = augroup,
		pattern = { cache },
		callback = function(_)
			load_cache()
			print("Projectile cache reloaded!")
		end,
	})
end

return M
