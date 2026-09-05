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
	config = function()
		local navic = require("nvim-navic")

		-- Broadcast blink.cmp capabilities to ALL LSP clients.
		-- Must be set before servers are enabled so they pick up the capabilities.
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		-- Per-server overrides. These merge with the bundled lsp/<name>.lua
		-- defaults shipped by nvim-lspconfig (auto-loaded on the runtimepath).
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			},
		})

		vim.lsp.config("biome", {
			filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact" },
			root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
		})

		-- mason-lspconfig v2: auto-enable any servers you've installed manually
		-- via :Mason / :LspInstall. `automatic_enable` only calls
		-- vim.lsp.enable() for already-installed servers — it does NOT install
		-- anything. (The old `handlers`/`ensure_installed` auto-install API was
		-- removed in v2.)
		require("mason-lspconfig").setup({
			automatic_enable = true,
		})

		-- Diagnostics
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

		-- Keymaps, navic attach and document highlight on LSP attach.
		local keymap = vim.keymap
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local bufopts = { silent = true, buffer = ev.buf }

				-- Attach navic to LSP if it supports documentSymbolProvider
				if client and client.server_capabilities.documentSymbolProvider then
					navic.attach(client, ev.buf)
				end

				-- LSP actions grouped under <leader>l (AstroNvim style).
				keymap.set("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
				keymap.set("v", "<leader>la", vim.lsp.buf.code_action, bufopts)
				keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
				keymap.set("n", "<leader>ld", vim.diagnostic.open_float, bufopts)
				keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", bufopts)
				keymap.set("n", "<leader>lR", ":LspRestart<CR>", { silent = true })
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, bufopts)
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, bufopts)
				keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

				-- Word-under-cursor reference highlighting is handled by
				-- snacks.words (enabled in snacks.lua): same documentHighlight
				-- LSP method, debounced + multi-client aware. No manual
				-- CursorHold/CursorMoved autocmd here (would double-highlight).
			end,
		})
	end,
}
