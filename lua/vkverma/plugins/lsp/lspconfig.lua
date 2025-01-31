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
			servers = {
				ts_ls = {},
				biome = {},
				lua_ls = {},
				prismals = {},
				codespell = {},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			local keymap = vim.keymap

			-- LSP mappings (in LspAttach autocmd)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local bufopts = { buffer = ev.buf, silent = true }
					bufopts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
					bufopts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					bufopts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts)
					bufopts.desc = "Go to previous diagnostic"
					keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
					bufopts.desc = "Go to next diagnostic"
					keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
					bufopts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
					bufopts.desc = "Restart LSP"
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", bufopts)
				end,
			})

			-- Global capabilities (enhanced by blink.cmp)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Diagnostic sign definitions
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- mason-lspconfig setup
			mason_lspconfig.setup({
				ensure_installed = {
					"biome",
					"ts_ls",
					"lua_ls",
					"prismals",
					"codespell",
				},
			})

			mason_lspconfig.setup_handlers({
				-- Default handler for all servers
				function(server_name)
					local server_config = {
						capabilities = capabilities,
					}

					-- Special settings for individual servers
					if server_name == "lua_ls" then
						server_config.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						}
					end

					-- Override with per-server configs from opts.servers if they exist
					if opts.servers and opts.servers[server_name] then
						server_config = vim.tbl_deep_extend("force", server_config, opts.servers[server_name])

						if opts.servers[server_name].capabilities then
							server_config.capabilities =
								require("blink.cmp").get_lsp_capabilities(opts.servers[server_name].capabilities)
						end
					end

					lspconfig[server_name].setup(server_config)
				end,
			})
		end,
	},
}
