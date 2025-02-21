return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		cond = function()
			-- Optional: Add a condition for loading
			return not vim.g.started_by_firenvim
		end,
		keys = {
			{
				"<leader><leader>",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			-- find
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			-- git
			{
				"<leader>gc",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			-- Grep
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			-- search
			{
				"<leader>fd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>ft",
				function()
					Snacks.picker.colorschemes({ layout = "ivy" })
				end,
				desc = "Colorschemes",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			-- LSP
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			-- Other
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},

			-- Notifications history
			{
				"<leader>nn",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notifier history",
			},
		},
		opts = {
			picker = {
				enabled = true,
				layout = {
					-- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
					cycle = false,
				},
				files = {
					find_args = {
						exclude = { ".git", "node_modules", "__pycache__" }, -- Add your patterns
					},
				},
			},
			notifier = {
				enabled = true,
				style = "compact", -- "compact" uses less space
				top_down = true, -- Notifications appear from top to bottom
			},
			dashboard = {
				enabled = true,
				width = 60,
				row = nil, -- dashboard position. nil for center
				col = nil, -- dashboard position. nil for center
				pane_gap = 4, -- empty columns between vertical panes
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
				-- These settings are used by some built-in sections
				preset = {
					-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
					---@type fun(cmd:string, opts:table)|nil
					pick = nil,
					-- Used by the `keys` section to show keymaps.
					-- Set your custom keymaps here.
					-- When using a function, the `items` argument are the default keymaps.
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.picker.files()",
						},
						-- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					-- Used by the `header` section
					header = [[
██╗   ██╗██╗  ██╗██╗   ██╗███████╗██████╗ ███╗   ███╗ █████╗
██║   ██║██║ ██╔╝██║   ██║██╔════╝██╔══██╗████╗ ████║██╔══██╗
██║   ██║█████╔╝ ██║   ██║█████╗  ██████╔╝██╔████╔██║███████║
╚██╗ ██╔╝██╔═██╗ ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║
 ╚████╔╝ ██║  ██╗ ╚████╔╝ ███████╗██║  ██║██║ ╚═╝ ██║██║  ██║
  ╚═══╝  ╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
                      ]],
				},
				-- item field formatters
				formats = {
					icon = function(item)
						if item.file and item.icon == "file" or item.icon == "directory" then
							return M.icon(item.file, item.icon)
						end
						return { item.icon, width = 2, hl = "icon" }
					end,
					footer = { "%s", align = "center" },
					header = { "%s", align = "center" },
					file = function(item, ctx)
						local fname = vim.fn.fnamemodify(item.file, ":~")
						fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
						if #fname > ctx.width then
							local dir = vim.fn.fnamemodify(fname, ":h")
							local file = vim.fn.fnamemodify(fname, ":t")
							if dir and file then
								file = file:sub(-(ctx.width - #dir - 2))
								fname = dir .. "/…" .. file
							end
						end
						local dir, file = fname:match("^(.*)/(.+)$")
						return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
							or { { fname, hl = "file" } }
					end,
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
					{ section = "session" }, -- Add this if you have session functionality
				},
			},
			indent = {
				enabled = true,
				char = "▏",
				animate = {
					enabled = false,
				},
			},
			scroll = { enabled = true },
			lazygit = {
				enabled = vim.fn.executable("lazygit") == 1,
			},
			-- image = {
			-- 	enabled = true,
			-- },
		},
	},
}
