return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"rafamadriz/friendly-snippets",
			{
				"Saghen/blink.cmp",
				checkout = "fuzzy.prebuilt_binaries.force_version",
			},
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup()
				end,
			},
		},
		opts = {
			diagnostics = {
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
					numhl = {
						[vim.diagnostic.severity.WARN] = "WarningMsg",
						[vim.diagnostic.severity.ERROR] = "ErrorMsg",
						[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
						[vim.diagnostic.severity.HINT] = "DiagnosticHint",
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			local keymap = vim.keymap

			-- Key mappings for LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local bufopts = { buffer = ev.buf, silent = true }
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts)
					keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
					keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
					keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", bufopts)
				end,
			})

			-- Set LSP capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Define diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Ensure LSP servers are installed
			mason_lspconfig.setup({
				ensure_installed = {
					"biome",
					"ts_ls",
					"lua_ls",
					"prismals",
				},
			})

			-- Setup handlers for LSP servers
			mason_lspconfig.setup_handlers({
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

					-- Apply custom server configurations (if any)
					if opts.servers and opts.servers[server_name] then
						server_config = vim.tbl_deep_extend("force", server_config, opts.servers[server_name])
					end

					lspconfig[server_name].setup(server_config)
				end,
			})
		end,
	},
}
