return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	cmd = { "Neogit" },
	config = {
		integrations = {
			diffview = true,
		},
	},
}
