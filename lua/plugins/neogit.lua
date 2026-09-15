return {
	"NeogitOrg/neogit",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim",
	},
	cmd = { "Neogit" },
	opts = {
		-- Use Diffview.nvim as the diff viewer (codediff 3.0.0's neogit
		-- integration is incompatible and has been removed).
		integrations = {
			diffview = true,
			codediff = false,
		},
		diff_viewer = "diffview",
	},
}
