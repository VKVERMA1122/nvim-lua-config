return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")

		-- -- LSP Clients (only show if clients are active)
		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			return #clients > 0
					and table.concat(
						vim.tbl_map(function(client)
							return client.name
						end, clients),
						", "
					)
				or nil
		end
		--
		-- -- Formatter status (only show if formatters exist)
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
		--
		-- -- Diagnostics status using LSP
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
		--
		-- -- Linting status using nvim-lint (correct implementation)
		local function lint_status()
			local diagnostics = vim.diagnostic.get(0) -- Uses Neovim's built-in diagnostic API.
			local lint_error_count = 0
			local lint_warning_count = 0

			for _, diagnostic in ipairs(diagnostics) do
				if diagnostic.source == "nvim-lint" then -- Filter only nvim-lint diagnostics.
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
				theme = "auto",
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
							error = " ",
							warn = " ",
							hint = " ",
							info = " ",
						},
					},
					{ "filetype" },
				},
				lualine_x = {
					{
						lsp_clients,
						icon = "LSP:",
						color = { fg = "#98be65" },
						cond = function()
							return lsp_clients() ~= nil
						end,
					},
					{
						formatter_status,
						icon = "󰉢:",
						color = { fg = "#ff6c6b" },
						cond = function()
							return formatter_status() ~= nil
						end,
					},
					{
						lint_status, -- Display linting status here.
						icon = "🔍:",
						color = { fg = "#ffcc00" },
						cond = function()
							return lint_status() ~= nil
						end,
					},
					{
						diagnostics_status,
						icon = "🔧:",
						color = { fg = "#51afef" },
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
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "neo-tree", "lazy", "fzf", "mason", "trouble" },
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

-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	event = "VeryLazy",
-- 	dependencies = {
-- 		"kyazdani42/nvim-web-devicons",
-- 		"lewis6991/gitsigns.nvim",
-- 		"tpope/vim-fugitive",
-- 	},
-- 	config = function()
-- 		require("lualine").setup({
-- 			options = {
-- 				disabled_filetypes = {
-- 					statusline = {
-- 						"dashboard",
-- 						"alpha",
-- 						"ministarter",
-- 						"snacks_dashboard",
-- 					},
-- 				},
-- 				icons_enabled = true,
-- 				theme = "auto",
-- 				component_separators = { left = "", right = "" },
-- 				section_separators = { left = "", right = "" },
-- 				always_divide_middle = true,
-- 				globalstatus = true,
-- 			},
-- 			sections = {
-- 				lualine_a = {
-- 					{
-- 						"mode",
-- 						fmt = function(str)
-- 							return str:sub(1, 1):upper() -- Show only first letter for mode
-- 						end,
-- 						separator = { left = "", right = "" },
-- 						color = { bg = "#89dceb", fg = "#1a1b26", gui = "bold" },
-- 						padding = { left = 1, right = 1 },
-- 					},
-- 				},
-- 				lualine_b = {
-- 					{
-- 						"branch",
-- 						icon = "",
-- 						color = { fg = "#bb9af7", gui = "bold" },
-- 						separator = { left = "", right = "" },
-- 					},
-- 					{
-- 						"diff",
-- 						symbols = {
-- 							added = " ",
-- 							modified = " ",
-- 							removed = " ",
-- 						},
-- 						diff_color = {
-- 							added = { fg = "#9ece6a" },
-- 							modified = { fg = "#e0af68" },
-- 							removed = { fg = "#f7768e" },
-- 						},
-- 						source = function()
-- 							local gitsigns = vim.b.gitsigns_status_dict
-- 							if gitsigns then
-- 								return {
-- 									added = gitsigns.added,
-- 									modified = gitsigns.changed,
-- 									removed = gitsigns.removed,
-- 								}
-- 							end
-- 						end,
-- 					},
-- 					{
-- 						"diagnostics",
-- 						sources = { "nvim_diagnostic" },
-- 						symbols = {
-- 							error = " ",
-- 							warn = " ",
-- 							info = " ",
-- 							hint = " ",
-- 						},
-- 						colored = true,
-- 						update_in_insert = false,
-- 						always_visible = false,
-- 					},
-- 				},
-- 				lualine_c = {
-- 					{
-- 						"filename",
-- 						path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
-- 						symbols = {
-- 							modified = " ●",
-- 							readonly = " ",
-- 							unnamed = " ",
-- 							newfile = " ",
-- 						},
-- 						color = { fg = "#7aa2f7", gui = "bold" },
-- 					},
-- 					{
-- 						"lsp_progress",
-- 						display_components = { "lsp_client_name", "spinner" },
-- 						colors = {
-- 							percentage = "#bb9af7",
-- 							title = "#7aa2f7",
-- 							message = "#c0caf5",
-- 							spinner = "#ff9e64",
-- 							lsp_client_name = "#2ac3de",
-- 						},
-- 						separators = {
-- 							component = " ",
-- 							progress = " | ",
-- 							message = { pre = "(", post = ")" },
-- 							percentage = { pre = "", post = "%% " },
-- 							title = { pre = "", post = ": " },
-- 							lsp_client_name = { pre = "[", post = "]" },
-- 							spinner = { pre = "", post = "" },
-- 						},
-- 						timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
-- 						spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
-- 					},
-- 				},
-- 				lualine_x = {
-- 					{
-- 						"encoding",
-- 						fmt = function(str)
-- 							return str:upper()
-- 						end,
-- 						cond = function()
-- 							return vim.bo.fileencoding ~= "utf-8"
-- 						end,
-- 					},
-- 					"fileformat",
-- 					"filetype",
-- 					{
-- 						"overseer",
-- 						label = " ", -- Gear icon
-- 						colored = true,
-- 						color = { fg = "#ff9e64" },
-- 						cond = function()
-- 							return package.loaded.overseer ~= nil
-- 						end,
-- 					},
-- 				},
-- 				lualine_y = {
-- 					{
-- 						"progress",
-- 						color = { fg = "#c0caf5" },
-- 					},
-- 					{
-- 						"location",
-- 						color = { fg = "#9d7cd8" },
-- 					},
-- 				},
-- 				lualine_z = {
-- 					{
-- 						"datetime",
-- 						style = "%H:%M",
-- 						color = { bg = "#f7768e", fg = "#1a1b26", gui = "bold" },
-- 						separator = { left = "", right = "" },
-- 						padding = { left = 1, right = 1 },
-- 					},
-- 				},
-- 			},
-- 			inactive_sections = {
-- 				lualine_a = {},
-- 				lualine_b = {},
-- 				lualine_c = { "filename" },
-- 				lualine_x = { "location" },
-- 				lualine_y = {},
-- 				lualine_z = {},
-- 			},
-- 			extensions = { "fugitive", "nvim-tree", "toggleterm", "quickfix" },
-- 		})
-- 	end,
-- }
