return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (current)" },
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
}
