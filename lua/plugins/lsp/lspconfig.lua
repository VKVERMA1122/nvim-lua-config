return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"rafamadriz/friendly-snippets",
		{
			"Saghen/blink.cmp",
		},
		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({})
			end,
		},
		-- Add nvim-navic dependency
		{
			"SmiteshP/nvim-navic",
			opts = {
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
			},
		},
	},
	opts = {
		diagnostics = {
			virtual_text = { spacing = 0 },
			signs = {},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local navic = require("nvim-navic")

		local keymap = vim.keymap
		local bufopts = { silent = true, buffer = true }

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				-- Attach navic to LSP if it supports documentSymbolProvider
				if client and client.server_capabilities.documentSymbolProvider then
					navic.attach(client, ev.buf)
				end

				bufopts.buffer = ev.buf
				keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts)
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, bufopts)
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, bufopts)
				keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", { silent = true })
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"biome",
				"ts_ls",
				"lua_ls",
				"prismals",
			},
			handlers = {
				function(server_name)
					local server_config = {
						capabilities = capabilities,
					}

					if server_name == "lua_ls" then
						server_config.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						}
					end

					if opts.servers and opts.servers[server_name] then
						server_config = vim.tbl_deep_extend("force", server_config, opts.servers[server_name])
					end

					lspconfig[server_name].setup(server_config)
				end,
			},
		})
	end,
}
