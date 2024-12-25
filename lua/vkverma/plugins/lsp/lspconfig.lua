return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"rafamadriz/friendly-snippets", -- Optional, for snippet support with blink.cmp
			{
				"Saghen/blink.cmp",
				checkout = "fuzzy.prebuilt_binaries.force_version", -- Use a specific release tag with pre-built binaries
			},
			{ "j-hui/fidget.nvim", opts = {} },
		},
		opts = {
			-- Optional: You can define default server configurations here
			servers = {
				-- Example:
				-- rust_analyzer = {
				--   settings = {
				--     ["rust-analyzer"] = { checkOnSave = { command = "clippy" } }
				--   }
				-- },
			},
		},
		config = function(_, opts) -- Access opts from lazy.nvim
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			local keymap = vim.keymap

			-- LSP mappings (in LspAttach autocmd)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local bufopts = { buffer = ev.buf, silent = true }

					bufopts.desc = "Show LSP references"
					keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", bufopts)
					bufopts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
					bufopts.desc = "Show LSP definitions"
					keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", bufopts)
					bufopts.desc = "Show LSP implementations"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts)
					bufopts.desc = "Show LSP type definitions"
					keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", bufopts)
					bufopts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
					bufopts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					bufopts.desc = "Show buffer diagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", bufopts)
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
			local signs = { Error = "󰅙 ", Warn = " ", Hint = "󰠠 ", Info = "󰋼 " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- mason-lspconfig setup
			mason_lspconfig.setup_handlers({
				-- Default handler for all servers
				function(server_name)
					local server_config = {
						capabilities = capabilities, -- Use enhanced capabilities globally
					}

					-- Special settings for individual servers (example: lua_ls)
					if server_name == "lua_ls" then
						server_config.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								-- completion = { callSnippet = "Replace" }, -- Probably not needed without completion engine
							},
						}
					end

					-- Override with per-server configs from opts.servers if they exist
					if opts.servers and opts.servers[server_name] then
						server_config = vim.tbl_deep_extend("force", server_config, opts.servers[server_name])
						-- If a server has its own capabilities defined in opts.servers,
						-- enhance those individually with blink.cmp
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
