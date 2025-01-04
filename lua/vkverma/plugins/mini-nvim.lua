return {
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			require("mini.files").setup()
			require("mini.jump").setup()
			require("mini.jump2d").setup({
				-- Options for visual effects
				view = {
					-- Whether to dim lines with at least one jump spot
					dim = true,

					-- How many steps ahead to show. Set to big number to show all steps.
					n_steps_ahead = 0,
				},
				-- Which lines are used for computing spots
				allowed_lines = {
					blank = false, -- Blank line (not sent to spotter even if `true`)
					cursor_before = true, -- Lines before cursor line
					cursor_at = false, -- Cursor line
					cursor_after = true, -- Lines after cursor line
					fold = true, -- Start of fold (not sent to spotter even if `true`)
				},

				-- Which windows from current tabpage are used for visible lines
				allowed_windows = {
					current = true,
					not_current = false,
				},
				mappings = {
					start_jumping = "<c-s>",
				},
			})
			require("mini.tabline").setup({
				tabpage_section = "none",
			})
			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
}
