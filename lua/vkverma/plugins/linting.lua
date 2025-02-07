return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "InsertLeave", "BufReadPost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			markdown = { "codespell" },
			text = { "codespell" },
			["*"] = { "codespell" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				pcall(function()
					lint.try_lint()
					lint.try_lint("codespell")
				end)
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			pcall(lint.try_lint)
		end, { desc = "Trigger linting for current file" })
	end,
}
