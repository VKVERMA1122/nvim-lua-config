return {
	"folke/which-key.nvim",
	cmd = "WhichKey",
	keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {},
}
