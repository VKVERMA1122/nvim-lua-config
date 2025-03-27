return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	config = function()
		local conform = require("conform")

		-- Improvement: Define common format options once (DRY)
		local format_opts = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		}

		-- BugFix: Corrected structure - single conform.setup call
		conform.setup({
			default_format_opts = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				lua = { "stylua" },
				go = { "gofumpt" },
			},
			format_on_save = format_opts, -- Reuse format_opts
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		})

		-- Use common format options for keymap
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format(format_opts) -- Reuse format_opts
		end, { desc = "Format file or range (in visual mode)" })

		-- Use common format options for user command
		vim.api.nvim_create_user_command("Format", function(args)
			-- Combine common options with range if provided
			local current_format_opts = vim.tbl_deep_extend("force", {}, format_opts)
			if args.range then
				current_format_opts.range = args.range
			end
			conform.format(current_format_opts)
		end, {
			desc = "Format file or range (in visual mode)",
			range = true, -- Allows command to work in visual mode
		})
	end,
}
