return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "InsertLeave", "BufReadPost" },
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for code actions
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			go = { "golangcilint" },
			text = { "cspell" },
			--lua = { "selene" },
			["*"] = { "cspell" }, -- Apply to all filetypes
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Integrate code actions (if your linters support them)
		vim.keymap.set("n", "<leader>la", function()
			lint.try_lint()
			vim.cmd("copen") -- Open quickfix list to see lint results
		end, { desc = "Lint and show all errors" })

		-- Code action keymap (requires plenary.nvim)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, { desc = "Show available code actions" })
	end,
}

-- return {
-- 	"nvimtools/none-ls.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	dependencies = { "mason.nvim", "nvim-lspconfig" },
-- 	config = function()
-- 		local null_ls = require("null-ls")
--
-- 		null_ls.setup({
-- 			sources = {
-- 				-- Diagnostics (Linters)
-- 				null_ls.builtins.diagnostics.biome,
-- 				null_ls.builtins.diagnostics.cspell,
--
-- 				-- Code Actions
-- 				-- Example:  These may overlap with formatters, depending on the tool
-- 				-- null_ls.builtins.code_actions.biomejs,
--
-- 				-- Formatting (conform.nvim will handle these, but you *could* also
-- 				-- configure formatting here if you prefer)
-- 				-- null_ls.builtins.formatting.stylua,
-- 				-- null_ls.builtins.formatting.black,
-- 			},
-- 			-- Debugging (optional)
-- 			debug = false, -- set to true to see verbose logs in the Neovim message area
-- 		})
-- 	end,
-- }
