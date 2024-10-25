local M = {}

local augroup = vim.api.nvim_create_augroup("coil", { clear = true })

--- @alias coil.bin string
--- @alias coil.ambiguous_ext_type string
--- @alias coil.coil_yank_keybind string
--- @alias coil.coil_put_keybind string
--- @alias coil.coil_register string
M.bin = "coil"
M.ambiguous_ext_type = "C"
M.coil_yank_keybind = "<C-c>y"
M.coil_put_keybind = "<C-c>p"
M.coil_register = "c" -- paste from the coil register with "<coil_register>p

local function get_ext(filename)
	local res = ""
	for _ in string.gmatch(filename, "[^.]+") do
		res = _
	end
	return res
end

local coil_region_c = function(p0, p1)
	local cmd = M.bin .. " "
	cmd = cmd .. '"' .. table.concat(vim.fn.getregion(p0, p1), " ") .. '"'
	-- print(cmd)
	vim.fn.setreg(M.coil_register, vim.fn.system(cmd))
end

local coil_region_cpp = function(filename, b0, b1)
	-- print(filename .. ": " .. ext)
	local cmd = M.bin .. " -p -o " .. filename .. " " .. b0 .. " " .. b1
	-- print(cmd)
	vim.fn.setreg(M.coil_register, vim.fn.system(cmd))
end

-- NOTE: this isn't working for some reason (probably because filename isn't relative)
local coil_file = function(filename, ext)
	local cmd = M.bin .. " -i "
	if ext == "hpp" or (ext == "h" and M.ambiguous_ext_type ~= "C") then
		cmd = cmd .. "-p "
	end
	cmd = cmd .. "-o " .. filename
	vim.fn.setreg(M.coil_register, vim.fn.system(cmd))
end

M.setup = function(args)
	M = vim.tbl_deep_extend("force", M, args)
	vim.api.nvim_create_user_command("Coil", function()
		local name = vim.api.nvim_buf_get_name(0)
		coil_file(name, get_ext(name))
	end, { desc = "run coil on file & output to register " .. M.coil_register })
	vim.keymap.set("n", M.coil_yank_keybind, function()
		local name = vim.api.nvim_buf_get_name(0)
		coil_file(name, get_ext(name))
	end, { desc = "expand all function declarations in file" })
	vim.keymap.set("v", M.coil_yank_keybind, function()
		local visual_start = vim.fn.getpos("v")
		local cursor_pos = vim.fn.getpos(".")
		local ext = get_ext(vim.api.nvim_buf_get_name(0))
		if ext == "hpp" or (M.ambiguous_ext_type ~= "C") then
			local offsets = {
				vim.fn.line2byte(visual_start[2]) + visual_start[3],
				vim.fn.line2byte(cursor_pos[2]) + cursor_pos[3],
			}
			coil_region_cpp(vim.api.nvim_buf_get_name(0), vim.fn.min(offsets), vim.fn.max(offsets))
		else
			coil_region_c(visual_start, cursor_pos)
		end
		vim.api.nvim_input("<Esc>")
	end, { desc = "expand all function declarations in visual selection" })
	vim.keymap.set(
		{ "n", "v" },
		M.coil_put_keybind,
		'"' .. M.coil_register .. "p",
		{ desc = "paste from the coil register (" .. M.coil_register .. ")" }
	)
end

return M
