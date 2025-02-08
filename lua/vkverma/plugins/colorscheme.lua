-- return {
-- 	"timmypidashev/darkbox.nvim",
-- 	lazy = false,
-- 	config = function()
-- 		require("darkbox").setup({
-- 			italic = {
-- 				strings = false,
-- 				emphasis = false,
-- 				comments = false,
-- 				operators = false,
-- 				folds = false,
-- 			},
-- 			transparent_mode = false,
-- 		})
-- 		vim.cmd("colorscheme darkbox")
-- 	end,
-- }

return {
	{
		"wtfox/jellybeans.nvim",
		priority = 1000,
		config = function()
			require("jellybeans").setup({
				italics = false,
				flat_ui = false, -- toggles "flat UI" for pickers
			})
			vim.cmd.colorscheme("jellybeans")
		end,
	},
}
