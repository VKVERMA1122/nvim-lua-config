return {
	"smoka7/multicursors.nvim",
	dependencies = {
		"nvimtools/hydra.nvim",
	},
	opts = {},
	-- Load plugin when its commands are executed
	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	keys = {
		{
			mode = { "v", "n" },
			"<Leader>m",
			"<cmd>MCstart<cr>",
			desc = "Create a selection for selected text or word under the cursor",
		},
	},
}
