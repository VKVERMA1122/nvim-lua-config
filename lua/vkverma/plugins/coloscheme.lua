return {
	"metalelf0/jellybeans-nvim",
	lazy = false,
	priority = 1000,
	dependencies = {
		"rktjmp/lush.nvim",
	},
	config = function()
		-- vim.opt.background = "dark" -- set this to dark or light
		vim.cmd.colorscheme("jellybeans-nvim")
	end,
}
