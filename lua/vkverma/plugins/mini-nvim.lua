return {
	{
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			-- Statusline Configuration
			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = true, -- Enable Nerd Font icons
				set_vim_settings = true, -- Automatically set Vim settings
			})

			-- Custom Location Section
			statusline.section_location = function()
				return "%2l:%-2v" -- Line:Column format
			end

			-- Files Explorer Configuration
			require("mini.files").setup({
				windows = {
					preview = false, -- Enable file preview
					width_focus = 30, -- Width of focused window
					width_nofocus = 20, -- Width of non-focused windows
				},
				options = {
					permanent_delete = false, -- Safer file deletion
					use_as_default_explorer = true, -- Replace netrw
				},
			})

			-- Enhanced Jump Configuration
			require("mini.jump2d").setup({
				init = function()
					vim.api.nvim_create_autocmd("User", {
						pattern = "MiniFilesWindowOpen",
						callback = function(args)
							local win_id = args.data.win_id
							vim.api.nvim_win_set_config(win_id, { border = "thick" })
						end,
					})
				end,
				view = {
					dim = true,
					-- n_steps_ahead = 2, -- Show more jump steps
				},
				mappings = {
					start_jumping = "<C-s>",
					jump_first = "<C-f>",
					jump_prev = "<C-b>",
				},
				allowed_lines = {
					blank = false,
					cursor_before = true,
					cursor_after = true,
				},
			})

			-- Tabline Configuration
			require("mini.tabline").setup({
				tabpage_section = "none",
			})
			-- Additional Mini Modules
			require("mini.comment").setup() -- Easy commenting
			require("mini.pairs").setup() -- Auto-pair brackets
			require("mini.indentscope").setup({ -- Indent visualization
				draw = {
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
		end,
	},
}
