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
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Hunk" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>u", group = "UI/UX Toggle" },
			{ "<leader>x", group = "Diagnostics / Lists" },
			{ "<leader>n", group = "Notifier" },
		},
	},
}
