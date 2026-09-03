return {
	"folke/which-key.nvim",
	cmd = "WhichKey",
	keys = { "<leader>", "<c-w>", '"', "'", "`", "g" },
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		preset = "helix",
		spec = {
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "Find" },
			{ "<leader>h", group = "Hunk" },
			{ "<leader>s", group = "Search" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>g", group = "Git" },
			{ "<leader>x", group = "Diagnostics / Trouble" },
		},
	},
}
