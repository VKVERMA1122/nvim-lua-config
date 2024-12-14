return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			transparent = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
				functions = {},
				variables = {},
				sidebars = "transparent",
				floats = "transparent",
			},
			hide_inactive_statusline = true,
			dim_inactive = true,
			lualine_bold = false,
		})
		vim.cmd("colorscheme tokyonight-night")
	end,
}
