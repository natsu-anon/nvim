return { -- Fuzzy Finder (files, lsp, etc)teles
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			--build = 'make',
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		-- { "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		-- - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		local actions = require("telescope.actions")
		local lg_actions = require("telescope-live-grep-args.actions")
		-- local fb_actions = require("telescope").extensions.file_browser.actions
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				mappings = {
					i = {
						-- ["<c-enter>"] = "to_fuzzy_refine",
						["<C-g>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-CR>"] = actions.to_fuzzy_refine,
					},
				},
			},
			pickers = {
				builtin = {
					theme = "ivy",
				},
				colorscheme = {
					enable_preview = true,
					theme = "ivy",
				},
				current_buffer_fuzzy_find = {
					theme = "ivy",
					previewer = true,
				},
				buffers = {
					theme = "ivy",
					previewer = false,
				},
				oldfiles = {
					theme = "ivy",
					previewer = true,
				},
				find_files = {
					theme = "ivy",
					previewer = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
				git_files = {
					theme = "ivy",
					previewer = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				-- file_browser = {
				-- 	theme = "ivy",
				-- 	-- hijack_netrw = true, -- this doesn't seem to be working :(
				-- 	hijack_netrw = false,
				-- 	enable_preview = false,
				-- 	-- SEE: defaults.mappings
				-- 	-- mappings = {
				-- 	-- 	["i"] = {
				-- 	-- 		["<ESC>"] = actions.close,
				-- 	-- 		["<C-c>"] = actions.close,
				-- 	-- 		["<C-j>"] = actions.move_selection_next,
				-- 	-- 		["<C-k>"] = actions.move_selection_previous,
				-- 	-- 	},
				-- 	-- },
				-- },
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-s>"] = lg_actions.quote_prompt(),
							["<C-i>"] = lg_actions.quote_prompt({ postfix = " --iglob " }),
							["<C-CR>"] = actions.to_fuzzy_refine,
						},
					},
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "file_browser")
		pcall(require("telescope").load_extension, "live_grep_args")
		pcall(require("telescope").load_extension, "noice")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[F]ind Files" })
		vim.keymap.set("n", "<leader>r", builtin.oldfiles, { desc = '[R]ecent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[B]uffers" })
		vim.keymap.set("n", "<leader>m", builtin.marks, { desc = "[M]arks" })
		vim.keymap.set("n", "<A-q>", builtin.quickfix, { desc = "[Q]uickfix" })
		vim.keymap.set("n", "<leader>pf", builtin.git_files, { desc = "Search [P]roject [F]iles" })
		vim.keymap.set("n", "<leader>hf", builtin.help_tags, { desc = "[H]elp [F]ind" })
		vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "[H]elp [K]eymap" })
		vim.keymap.set("n", "<leader>tc", builtin.builtin, { desc = "[C]hoose [T]elescope" })
		vim.keymap.set("n", "<leader>w", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>s", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "search [D]iagnostics" })
		vim.keymap.set("n", "<leader>T", builtin.resume, { desc = "continue search" })
		vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "Search [T]reesitter for [S]ymbols" })
		vim.keymap.set("n", "<leader>tq", builtin.quickfix, { desc = "[S]earch [Q]uickfix" })
		vim.keymap.set("n", "<leader>tl", builtin.loclist, { desc = "[S]earch [L]oclist" })

		-- Slightly advanced example of overriding default behavior and theme
		-- vim.keymap.set("n", "<leader>j", function()
		-- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		-- 		winblend = 80,
		-- 		previewer = false,
		-- 	}))
		-- end, { desc = "Fuzzily search in current buffer" })
		vim.keymap.set("n", "<leader>j", builtin.current_buffer_fuzzy_find, { desc = "Fuzzily search in buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>J", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Fuzzily search in all open buffers" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>tn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search [N]eovim files" })

		-- local file_browser = require("telescope").extensions.file_browser
		-- vim.keymap.set("n", "<C-f>", file_browser.file_browser)
		--
		local function find_dirs(no_ignore)
			builtin.find_files({
				no_ignore = no_ignore,
				find_command = { "fd", "--type", "d", "--color", "never" },
			})
		end
		vim.keymap.set("n", "<C-f>", function()
			find_dirs(false)
		end, { desc = "Fuzzily Netrw into a dir (ignores)" })
		vim.keymap.set("n", "<A-f>", function()
			find_dirs(false)
		end, { desc = "Fuzzily Netrw into a dir (no ignores)" })
		-- vim.keymap.set("n", "-", file_browser.folder_browser)
		-- vim.keymap.set("n", "\\-", file_browser.browse_folders)

		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
		vim.keymap.set("n", "<leader>g", live_grep_args_shortcuts.grep_word_under_cursor)
		vim.keymap.set("v", "<leader>g", live_grep_args_shortcuts.grep_visual_selection)

		-- FIXME: bruh just let me enable the preview CMON
		--
		-- vim.api.nvim_create_user_command("Colorscheme", function()
		-- 	builtin.colorscheme({ { enable_preview = true } })
		-- end, { desc = "Preview & Change Colorschemes with Telescope" })
	end,
}
