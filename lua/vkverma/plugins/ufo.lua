return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async", -- Add this explicit dependency
		"nvim-treesitter/nvim-treesitter", -- Ensure treesitter is available
	},
	event = "BufReadPre",
	config = function()
		local ufo = require("ufo")
		ufo.setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			fold_virt_text_handler = require("ufo").defaultFoldTextHandler,
		})

		-- Optional: Set folding keymaps
		vim.keymap.set("n", "zR", ufo.openAllFolds)
		vim.keymap.set("n", "zM", ufo.closeAllFolds)
	end,
}
