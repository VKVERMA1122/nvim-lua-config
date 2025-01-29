return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
		},
		cmd = { "Neogit" },
		config = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
					fzf_lua = true,
					telescope = nil,
				},
			})
		end,
	},
}
