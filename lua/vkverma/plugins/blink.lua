local kind_icons = {
	Text = " ",
	Method = "󰆧 ",
	Function = "󰊕 ",
	Constructor = " ",
	Field = "󰇽 ",
	Variable = "󰂡 ",
	Class = "󰠱 ",
	Interface = " ",
	Module = " ",
	Property = "󰜢 ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = "",
	Keyword = "󰌋 ",
	Snippet = " ",
	Color = "󰏘 ",
	File = "󰈙 ",
	Reference = " ",
	Folder = "󰉋 ",
	EnumMember = " ",
	Constant = "󰏿 ",
	Struct = " ",
	Event = " ",
	Operator = "󰆕 ",
	TypeParameter = "󰅲 ",
	supermaven = " ",
	Supermaven = " ",
}
return {
	{
		"saghen/blink.cmp",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"supermaven-inc/supermaven-nvim",
			"saghen/blink.compat",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		version = "v0.*",
		opts = {
			keymap = {
				-- set to 'none' to disable the 'default' preset
				preset = "default",
				["<return>"] = { "select_and_accept", "fallback" },
				cmdline = {
					preset = "enter",
					["<CR>"] = {},
				},
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				-- nerd_font_variant = "mono",
				nerd_font_variant = "normal",
				kind_icons = kind_icons,
			},
			completion = {
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
						treesitter = { "lsp" },
					},
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = { enabled = true },
			sources = {
				default = { "luasnip", "lsp", "path", "buffer", "supermaven" },
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink.compat.source",
						async = true,
					},
				},
			},
		},
	},
}
