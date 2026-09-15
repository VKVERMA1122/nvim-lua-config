return {
	"mason-org/mason.nvim",
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = { "stylua", "golangci-lint" },
			auto_update = false,
			run_on_start = true,
			start_delay = 3000,
		})
	end,
}
