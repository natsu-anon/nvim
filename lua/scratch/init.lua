local augroup = vim.api.nvim_create_augroup("Scratch", { clear = true })
local buffer_name = "[Scratch]"

local function create_scratch_buffer()
	local res = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_name(res, buffer_name)
	-- local version = vim.version()
	-- local version_str = (version.major .. "." .. version.minor .. "." .. version.patch)
	-- vim.api.nvim_buf_set_lines(res, 0, -1, true, {
	-- 	"-- Welcome to Neovim v" .. version_str,
	-- 	"-- :so[urce] to execute lua here",
	-- 	"",
	-- })
	return res
end

local function show_scratch_buffer(b, filetype)
	vim.api.nvim_win_set_buf(0, b)
	if filetype ~= nil then
		vim.api.nvim_set_option_value("filetype", filetype, { buf = b })
	end
	vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(b), 0 })
end

local function scratch_buffer(filetype)
	for _, b_num in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.bufname(b_num) == buffer_name then
			return show_scratch_buffer(b_num, filetype)
		end
	end
	show_scratch_buffer(create_scratch_buffer(), filetype)
end

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	desc = "Create a scratch lua buffer on load",
-- 	group = augroup,
-- 	once = true,
-- 	callback = function(_)
-- 		if vim.fn.argc() == 0 then
-- 			scratch_buffer()
-- 		end
-- 		return true
-- 	end,
-- })
vim.api.nvim_create_user_command("Scratch", function(details)
	-- print(details.args)
	if details.args == "" then
		scratch_buffer()
	else
		scratch_buffer(details.args)
	end
end, { desc = "Switch to " .. buffer_name .. " buffer", nargs = "?" })

return { setup = function(_) end }
