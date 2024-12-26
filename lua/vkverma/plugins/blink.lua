return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		version = "v0.*",
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
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind" } },
						treesitter = { "lsp" },
					},
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "luasnip", "snippets", "path", "buffer" },
			},
		},
	},
}
