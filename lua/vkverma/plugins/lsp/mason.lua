return {
	"williamboman/mason.nvim",
	-- event = { "BufReadPre", "BufNewFile" },
	cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"codespell",
			},
		})
	end,
}
