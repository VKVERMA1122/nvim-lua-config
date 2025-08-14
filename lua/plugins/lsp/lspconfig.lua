return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"rafamadriz/friendly-snippets",
		{
			"Saghen/blink.cmp",
			-- It seems you might have a custom branch/tag name here.
			-- Standard for prebuilt binaries was often related to a version or commit.
			-- If "fuzzy.prebuilt_binaries.force_version" is not a valid git ref,
			-- you might want to check the plugin's documentation for the correct one,
			-- or remove it if you intend to use the default branch.
			-- For example, it might have been a temporary workaround.
			-- If it's intentional and correct, you can leave it.
			-- checkout = "fuzzy.prebuilt_binaries.force_version", -- Verify this line if issues persist with blink.cmp
		},
		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup()
			end,
		},
	},
	opts = {
		-- Refactor: Use virtual_text to hide diagnostic signs
		diagnostics = {
			virtual_text = { spacing = 0 },
			signs = {
				-- Note: 'numhl' for signs is not a standard vim.diagnostic.config option.
				-- Highlighting for signs is typically handled by 'texthl' in sign_define.
				-- The 'numhl' within signs = { numhl = ... } seems to be a custom structure
				-- that your sign definition loop below is trying to use, but it's not
				-- directly used by vim.diagnostic.config({ signs = { numhl = ... } }).
				-- The actual highlighting of signs is handled by `vim.fn.sign_define` later.
				-- This 'numhl' block under diagnostics.signs might not have any effect here.
				-- Consider removing if it's not used by another part of your config.
				-- Example:
				-- numhl = {
				-- 	[vim.diagnostic.severity.WARN] = "WarningMsg",
				-- 	[vim.diagnostic.severity.ERROR] = "ErrorMsg",
				-- 	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				-- 	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				-- },
			},
		},
		-- You can define server-specific configurations here, which the handler can use.
		-- For example:
		-- servers = {
		--   lua_ls = {
		--     settings = {
		--       Lua = {
		--         runtime = { version = "LuaJIT" }
		--       }
		--     }
		--   },
		--   ts_ls = { -- previously tsserver
		--     -- specific settings for typescript-language-server
		--   }
		-- }
	},
	config = function(_, opts) -- 'opts' here are the opts from the plugin spec (this file)
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")

		local keymap = vim.keymap
		local bufopts = { silent = true, buffer = true } -- Defined once for reuse

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				bufopts.buffer = ev.buf
				keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts)
				keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
				keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
				keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", { silent = true }) -- bufopts not ideal for LspRestart
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
				"ts_ls", -- if you meant typescript-language-server
				"lua_ls",
				"prismals",
			},
			handlers = {
				-- This function will be called for each server installed by Mason.
				-- It serves as the default handler.
				function(server_name)
					local server_config = {
						capabilities = capabilities,
					}

					-- Server-specific settings can be defined directly here
					if server_name == "lua_ls" then
						server_config.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						}
					end

					-- Apply custom server configurations from the plugin's 'opts.servers' table
					if opts.servers and opts.servers[server_name] then
						server_config = vim.tbl_deep_extend("force", server_config, opts.servers[server_name])
					end

					lspconfig[server_name].setup(server_config)
				end,

				-- You can also add specific handlers for servers if needed, for example:
				-- ["pyright"] = function()
				--   lspconfig.pyright.setup({
				--     capabilities = capabilities,
				--     -- other pyright specific settings
				--   })
				-- end,
			},
		})
	end,
}
