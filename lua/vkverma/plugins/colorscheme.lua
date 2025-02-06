return {
	"timmypidashev/darkbox.nvim",
	lazy = false,
	config = function()
		require("darkbox").setup({
			italic = {
				strings = false,
				emphasis = false,
				comments = false,
				operators = false,
				folds = false,
			},
			transparent_mode = false,
		})
		vim.cmd("colorscheme darkbox")
	end,
}
