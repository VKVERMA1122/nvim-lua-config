return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")

		-- LSP Clients (show all active clients)
		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients > 0 then
				local names = {}
				for _, client in ipairs(clients) do
					table.insert(names, client.name)
				end
				return table.concat(names, ", ")
			else
				return nil
			end
		end

		-- Formatter status (only show if formatters exist)
		local function formatter_status()
			local ok, formatters = pcall(require("conform").list_formatters, 0)
			return ok
					and #formatters > 0
					and table.concat(
						vim.tbl_map(function(f)
							return f.name
						end, formatters),
						", "
					)
				or nil
		end

		-- Diagnostics status using LSP
		local function diagnostics_status()
			local diagnostics = vim.diagnostic.get(0)
			local error_count = 0
			local warning_count = 0

			for _, diagnostic in ipairs(diagnostics) do
				if diagnostic.severity == vim.diagnostic.severity.ERROR then
					error_count = error_count + 1
				elseif diagnostic.severity == vim.diagnostic.severity.WARN then
					warning_count = warning_count + 1
				end
			end

			if error_count > 0 or warning_count > 0 then
				return string.format("E:%d W:%d", error_count, warning_count)
			else
				return nil
			end
		end

		-- Linting status using nvim-lint
		local function lint_status()
			local diagnostics = vim.diagnostic.get(0)
			local lint_error_count = 0
			local lint_warning_count = 0

			for _, diagnostic in ipairs(diagnostics) do
				if diagnostic.source == "nvim-lint" then
					if diagnostic.severity == vim.diagnostic.severity.ERROR then
						lint_error_count = lint_error_count + 1
					elseif diagnostic.severity == vim.diagnostic.severity.WARN then
						lint_warning_count = lint_warning_count + 1
					end
				end
			end

			if lint_error_count > 0 or lint_warning_count > 0 then
				return string.format("L:%d W:%d", lint_error_count, lint_warning_count)
			else
				return nil
			end
		end

		lualine.setup({
			options = {
				theme = "gruvbox",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = {
					statusline = {
						"dashboard",
						"alpha",
						"ministarter",
						"snacks_dashboard",
					},
				},
				icons_enabled = true,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filename",
						path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
						},
					},
					{
						"diagnostics",
						symbols = {
							error = " ",
							warn = " ",
							hint = " ",
							info = " ",
						},
					},
					{ "searchcount" },
				},
				lualine_x = {
					{
						lsp_clients,
						icon = "",
						color = { fg = "#98be65" },
						padding = { left = 1, right = 1 },
						separator = " ",
						cond = function()
							return lsp_clients() ~= nil
						end,
					},
					-- {
					-- 	formatter_status,
					-- 	icon = "",
					-- 	color = { fg = "#ff6c6b" },
					-- 	padding = { left = 1, right = 1 },
					-- 	separator = " ",
					-- 	cond = function()
					-- 		return formatter_status() ~= nil
					-- 	end,
					-- },
					{
						lint_status,
						icon = "",
						color = { fg = "#ffcc00" },
						padding = { left = 1, right = 1 },
						separator = " ",
						cond = function()
							return lint_status() ~= nil
						end,
					},
					{
						diagnostics_status,
						icon = "",
						color = { fg = "#51afef" },
						padding = { left = 1, right = 1 },
						separator = " ",
						cond = function()
							return diagnostics_status() ~= nil
						end,
					},
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
						diff_color = {
							added = { fg = "#9ece6a" },
							modified = { fg = "#e0af68" },
							removed = { fg = "#f7768e" },
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%H:%M")
					end,
				},
			},
			extensions = { "neo-tree", "lazy", "fzf", "mason", "trouble" },
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
