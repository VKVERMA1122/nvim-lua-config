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
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		---@diagnostic disable: missing-fields
		opts = {
			keymap = {
				preset = "default",
				["<return>"] = { "select_and_accept", "fallback" },
				-- cmdline = {
				-- 	preset = "enter",
				-- 	["<CR>"] = {},
				-- },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
				cmdline = {
					preset = "none", -- Disable all keymaps in command line mode
				},
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
				cmdline = {},
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
