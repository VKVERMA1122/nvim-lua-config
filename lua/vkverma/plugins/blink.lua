return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<return>"] = { "select_and_accept", "fallback" },
				cmdline = {
					preset = "enter",
					["<CR>"] = {},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "normal",
			},
			completion = {
				list = { selection = { preselect = true, auto_insert = true } },
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
				},
				menu = {
					cmdline_position = function()
						if vim.g.ui_cmdline_pos ~= nil then
							local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
							return { pos[1] - 1, pos[2] }
						end
						local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
						return { vim.o.lines - height, 0 }
					end,
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind" } },
						treesitter = { "lsp" },
					},
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
			},
			signature = { enabled = true },
			snippets = { preset = "luasnip" },
			sources = {
				cmdline = {},
				default = { "lsp", "snippets", "path", "buffer" },
			},
		},
	},
}
