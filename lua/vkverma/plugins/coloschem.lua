return {
	"timmypidashev/darkbox.nvim",
	lazy = false,
	config = function()
		require("darkbox").setup({
			transparent_mode = true,
		})
		vim.cmd("colorscheme darkbox")
	end,
}
