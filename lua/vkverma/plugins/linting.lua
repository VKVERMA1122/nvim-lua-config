return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "InsertLeave", "BufReadPost" },
	config = function()
		local lint = require("lint")
		lint.linters.cspell = {
			command = "cspell",
			args = { "--quiet", "--no-summary", "${file}" },
			parser = function(output)
				local diagnostics = {}
				for line in output:gmatch("[^\r\n]+") do
					local parts = vim.split(line, ":")
					if #parts >= 3 then
						local lnum = tonumber(parts[2]) - 1
						local col = tonumber(parts[3]) - 1
						local msg = table.concat(parts, ":", 4)
						table.insert(diagnostics, {
							source = "cspell",
							message = msg,
							severity = vim.diagnostic.severity.WARN,
							lnum = lnum,
							col = col,
						})
					end
				end
				return diagnostics
			end,
		}
		lint.linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			markdown = { "cspell" },
			text = { "cspell" },
			["*"] = { "cspell" }, -- Apply to all filetypes
		}

		-- Automatic linting
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
			callback = function()
				pcall(lint.try_lint)
			end,
		})
	end,
}
