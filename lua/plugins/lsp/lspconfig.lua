return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
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
	opts = {},
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

				-- Document highlight under cursor (per-buffer, lightweight)
				if client and client.server_capabilities.documentHighlightProvider then
					local hl_group =
						vim.api.nvim_create_augroup("lsp_doc_highlight_" .. ev.buf, { clear = true })
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = ev.buf,
						group = hl_group,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						buffer = ev.buf,
						group = hl_group,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.diagnostic.config({
			virtual_text = {
				spacing = 2,
				source = "if_many",
			},
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

					if server_name == "biome" then
						server_config.filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact" }
						server_config.root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc", "package.json", ".git")
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
