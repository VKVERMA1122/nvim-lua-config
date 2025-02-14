return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saghen/blink.compat",
		},
		event = "InsertEnter",
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<return>"] = { "select_and_accept", "fallback" },
				-- Enable cmdline completion and auto-select the first candidate by using the "enter" preset.
				cmdline = {
					preset = "enter",
					["<CR>"] = { "select_and_accept", "fallback" },
				},
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},
			signature = { enabled = true },
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "supermaven" },
				-- Activate cmdline sources as needed (empty here means no cmdline-specific sources)
				-- cmdline = {},
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink.compat.source",
						score_offset = 3,
					},
				},
			},
		},
	},
}
