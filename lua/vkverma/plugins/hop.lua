return {
	{
		"smoka7/hop.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
		config = function()
			local hop = require("hop")
			local directions = require("hop.hint").HintDirection

			hop.setup()

			-- Simplified mapping function to reduce repetition
			local function map_hop_key(mode, key, direction, opts)
				opts = opts or {}
				vim.keymap.set(mode, key, function()
					hop.hint_char1({
						direction = direction,
						current_line_only = opts.current_line_only or false,
						hint_offset = opts.hint_offset or 0,
					})
				end, { remap = true })
			end

			-- Main hop character search
			vim.keymap.set("n", "<c-s>", ":HopChar1<CR>", { noremap = true, silent = true })

			-- Enhanced directional character hints
			map_hop_key("", "f", directions.AFTER_CURSOR, { current_line_only = true })
			map_hop_key("", "F", directions.BEFORE_CURSOR, { current_line_only = true })
			map_hop_key("", "t", directions.AFTER_CURSOR, { current_line_only = true, hint_offset = -1 })
			map_hop_key("", "T", directions.BEFORE_CURSOR, { current_line_only = true, hint_offset = 1 })
		end,
	},
}
