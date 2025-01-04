return {
	"echasnovski/mini.statusline",
	version = "*",
	event = "VeryLazy",
	config = function()
		local statusline = require("mini.statusline")
		statusline.setup({
			use_icons = true,
			set_vim_settings = true,
		})

		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
