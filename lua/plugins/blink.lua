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
			cmdline = {
				enabled = false,
			},
			-- cmdline = {
			-- 	keymap = {
			-- 		preset = "super-tab",
			-- 		["<C-k>"] = { "select_prev", "fallback" },
			-- 		["<C-j>"] = { "select_next", "fallback" },
			-- 	},
			-- 	sources = function()
			-- 		local type = vim.fn.getcmdtype()
			-- 		-- Search forward and backward
			-- 		if type == "/" or type == "?" then
			-- 			return { "buffer" }
			-- 		end
			-- 		-- Commands
			-- 		if type == ":" then
			-- 			return { "cmdline" }
			-- 		end
			-- 		return {}
			-- 	end,
			-- },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "supermaven" },
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
