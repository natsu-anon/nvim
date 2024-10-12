-- UPDATE:it does NOT work well with git, unfortunately
return {}

--[[ return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function()
		local noice = require("noice")
		noice.setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			cmdline = {
				enabled = true, -- enables the Noice cmdline UI
				-- view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
				view = "cmdline",
				format = {
					help = { pattern = "^:%s*he?l?p?%s+", icon = "help" },
					-- lua = false, -- to disable a format, set to `false`
				},
			},
			messages = {
				view = "mini",
				view_error = "mini",
				view_warn = "mini",
			},
			-- NOTE: if you're not using mini for messages you're GOING to want this
			-- routes = {
			-- 	{
			-- 		filter = {
			-- 			event = "msg_show",
			-- 			kind = "",
			-- 			find = "written",
			-- 		},
			-- 		opts = { skip = true },
			-- 	},
			-- },
		})
		vim.keymap.set("n", "<leader>ne", function()
			noice.cmd("error")
		end)
		vim.keymap.set("n", "<leader>nd", function()
			noice.cmd("dismiss")
		end)
		vim.keymap.set("n", "<leader>nl", function()
			noice.cmd("last")
		end)
		vim.keymap.set("n", "<leader>nh", function()
			noice.cmd("history")
		end)
	end,
} ]]
