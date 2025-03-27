return {
	"echasnovski/mini.statusline",
	enabled = false,
	version = false,
	config = function()
		require("mini.statusline").setup({
			content = {
				active = function()
					local mode = MiniStatusline.section_mode({ trunc_width = 80 })
					local git = MiniStatusline.section_git({ trunc_width = 75 })
					local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
					local filename = MiniStatusline.section_filename({ trunc_width = 75 })
					local lsp = MiniStatusline.section_lsp({ trunc_width = 100 })
					local location = MiniStatusline.section_location({ trunc_width = 50 })
					local diff = MiniStatusline.section_diff({ trunc_width = 50 })

					return MiniStatusline.combine_groups({
						{ hl = "MiniStatuslineMode",    strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
						"%<", -- Ensures truncation on overflow
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=", -- Aligns next sections to the right
						{ hl = "MiniStatuslineFileinfo", strings = { lsp, diff } },
						{ hl = "MiniStatuslineLocation", strings = { location } },
					})
				end,
			},
			use_icons = true,
			set_vim_settings = true, -- Ensures statusline is always visible
		})
	end,
}
