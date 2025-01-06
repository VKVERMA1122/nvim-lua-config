return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "InsertLeave", "BufReadPost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biomejs" }, -- Consider adding eslint
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			["*"] = { "codespell" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				lint.try_lint()
				lint.try_lint("codespell")
			end,
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
