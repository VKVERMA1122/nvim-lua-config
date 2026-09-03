return {
	"williamboman/mason.nvim",
	config = function()
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

		-- require("mason-tool-installer").setup({
		-- 	ensure_installed = { "cspell" },
		-- })
	end,
}
