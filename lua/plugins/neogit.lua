return {
	"NeogitOrg/neogit",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	cmd = { "Neogit" },
	opts = {
		integrations = {
			diffview = true,
		},
	},
}
