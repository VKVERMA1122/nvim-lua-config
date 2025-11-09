return {
	"developedbyed/marko.nvim",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
	config = function()
		require("marko").setup({
			width = 100,
			height = 100,
			border = "rounded",
			title = " Marks ",
		})
	end,
}
