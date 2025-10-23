return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	init = function()
		require("tokyonight").setup({
			style = "night",
			transparent = true, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			styles = {
				comments = { italic = false },
				sidebars = "transparent", -- style for sidebars, see below
				floats = "transparent", -- style for floating windows
			},
		})
		-- Refactor: Use vim.opt.colorscheme for consistency
		vim.cmd([[colorscheme tokyonight]])
	end,
}

-- return {
-- 	"hzchirs/vim-material",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.g.material_style = "oceanic"
-- 		vim.cmd([[colorscheme vim-material]])
-- 	end,
-- }

-- return {
-- 	"makestatic/oblique.nvim",
-- 	commit = "b6c40c0c04a756efb2ff42f4fffde352e05eac96",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme oblique")
-- 	end,
-- }
