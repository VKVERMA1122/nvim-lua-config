return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/lsp-status.nvim", -- Optional: for more detailed LSP status
	},
	config = function()
		local lualine = require("lualine")

		-- Helper function to get LSP client names
		local function lsp_clients()
			local clients = vim.lsp.get_active_clients({ bufnr = 0 })
			if next(clients) == nil then
				return "No LSP"
			end
			return table.concat(
				vim.tbl_map(function(client)
					return client.name
				end, clients),
				", "
			)
		end

		-- Formatter status
		local function formatter_status()
			local formatters = require("conform").list_formatters(0)
			if #formatters == 0 then
				return "No Formatter"
			end
			return table.concat(
				vim.tbl_map(function(f)
					return f.name
				end, formatters),
				", "
			)
		end

		-- Linter status
		local function linter_status()
			local linters = require("lint").get_running()
			if #linters == 0 then
				return "No Linter"
			end
			return table.concat(linters, ", ")
		end

		lualine.setup({
			options = {
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
				theme = "auto",
				component_separators = { left = "", right = "" },
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
					"filename",
					{
						"diagnostics",
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = " ",
						},
					},

					{ "filetype" },
				},
				lualine_x = {
					{
						lsp_clients,
						icon = "LSP:",
						color = { fg = "#98be65" },
					},
					{
						formatter_status,
						icon = "󰉢:",
						color = { fg = "#ff6c6b" },
					},
					{
						linter_status,
						icon = "🔍:",
						color = { fg = "#51afef" },
					},
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict or {}
							return {
								added = gitsigns.added or 0,
								modified = gitsigns.changed or 0,
								removed = gitsigns.removed or 0,
							}
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "neo-tree", "lazy", "fzf" },
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
