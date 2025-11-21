-- Comprehensive Heirline.nvim setup with enhanced statusline components
return {
	"rebelot/heirline.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- "SmiteshP/nvim-navic", -- For code context
	},
	config = function()
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Define colors with fallbacks
		local function get_hl_fg(name, fallback)
			local hl = utils.get_highlight(name)
			return (hl and hl.fg) or fallback
		end

		local function get_hl_bg(name, fallback)
			local hl = utils.get_highlight(name)
			return (hl and hl.bg) or fallback
		end

		local colors = {
			bright_bg = get_hl_bg("Folded", "#3b4261"),
			bright_fg = get_hl_fg("Folded", "#c0caf5"),
			red = get_hl_fg("DiagnosticError", "#f7768e"),
			dark_red = get_hl_bg("DiffDelete", "#914c54"),
			green = get_hl_fg("String", "#9ece6a"),
			blue = get_hl_fg("Function", "#7aa2f7"),
			gray = get_hl_fg("NonText", "#545c7e"),
			orange = get_hl_fg("DiagnosticWarn", "#e0af68"),
			purple = get_hl_fg("Statement", "#bb9af7"),
			cyan = get_hl_fg("Special", "#2ac3de"),
			diag_warn = get_hl_fg("DiagnosticWarn", "#e0af68"),
			diag_error = get_hl_fg("DiagnosticError", "#f7768e"),
			diag_hint = get_hl_fg("DiagnosticHint", "#1abc9c"),
			diag_info = get_hl_fg("DiagnosticInfo", "#0db9d7"),
			git_del = get_hl_fg("GitSignsDelete", "#f7768e"),
			git_add = get_hl_fg("GitSignsAdd", "#9ece6a"),
			git_change = get_hl_fg("GitSignsChange", "#e0af68"),
		}

		--------------------------------------------------------------------------
		-- STATUSLINE COMPONENTS
		--------------------------------------------------------------------------

		-- Vim Mode
		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = "NORMAL",
					no = "O-PENDING",
					nov = "O-PENDING",
					noV = "O-PENDING",
					["no\22"] = "O-PENDING",
					niI = "NORMAL",
					niR = "NORMAL",
					niV = "NORMAL",
					nt = "NORMAL",
					v = "VISUAL",
					vs = "VISUAL",
					V = "V-LINE",
					Vs = "V-LINE",
					["\22"] = "V-BLOCK",
					["\22s"] = "V-BLOCK",
					s = "SELECT",
					S = "S-LINE",
					["\19"] = "S-BLOCK",
					i = "INSERT",
					ic = "INSERT",
					ix = "INSERT",
					R = "REPLACE",
					Rc = "REPLACE",
					Rx = "REPLACE",
					Rv = "V-REPLACE",
					Rvc = "V-REPLACE",
					Rvx = "V-REPLACE",
					c = "COMMAND",
					cv = "EX",
					r = "...",
					rm = "MORE",
					["r?"] = "CONFIRM",
					["!"] = "SHELL",
					t = "TERMINAL",
				},
				mode_colors = {
					n = "blue",
					i = "green",
					v = "cyan",
					V = "cyan",
					["\22"] = "cyan",
					c = "orange",
					s = "purple",
					S = "purple",
					["\19"] = "purple",
					R = "orange",
					r = "orange",
					["!"] = "red",
					t = "red",
				},
			},
			provider = function(self)
				return " %2(" .. self.mode_names[self.mode] .. "%) "
			end,
			hl = function(self)
				local mode = self.mode:sub(1, 1)
				return { fg = "black", bg = self.mode_colors[mode], bold = true }
			end,
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		-- Git Branch
		local Git = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,
			hl = { fg = "orange" },
			{
				provider = function(self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = "git_add" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = "git_del" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = "git_change" },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
			},
		}

		-- File name and icons
		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local FileName = {
			init = function(self)
				self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
				if self.lfilename == "" then
					self.lfilename = "[No Name]"
				end
			end,
			hl = { fg = "cyan" },
			flexible = 2,
			{
				provider = function(self)
					return self.lfilename
				end,
			},
			{
				provider = function(self)
					return vim.fn.pathshorten(self.lfilename)
				end,
			},
		}

		local FileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " [+]",
				hl = { fg = "green" },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = " ",
				hl = { fg = "orange" },
			},
		}

		local FileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
			FileIcon,
			FileName,
			FileFlags,
			{ provider = " " },
		}

		-- File Last Modified
		local FileLastModified = {
			condition = function()
				local filename = vim.api.nvim_buf_get_name(0)
				return filename ~= "" and vim.fn.filereadable(filename) == 1
			end,
			provider = function()
				local filename = vim.api.nvim_buf_get_name(0)
				local ftime = vim.fn.getftime(filename)
				if ftime > 0 then
					return " " .. os.date("%Y-%m-%d %H:%M", ftime)
				end
				return ""
			end,
			hl = { fg = "gray" },
		}

		-- File encoding and format
		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
				return enc ~= "utf-8" and enc:upper() or ""
			end,
		}

		local FileFormat = {
			provider = function()
				local fmt = vim.bo.fileformat
				return fmt ~= "unix" and fmt:upper() or ""
			end,
		}

		local FileType = {
			provider = function()
				return string.upper(vim.bo.filetype)
			end,
			hl = { fg = "blue", bold = true },
		}

		local FileSize = {
			provider = function()
				local suffix = { "b", "k", "M", "G", "T", "P", "E" }
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				fsize = (fsize < 0 and 0) or fsize
				if fsize < 1024 then
					return fsize .. suffix[1]
				end
				local i = math.floor((math.log(fsize) / math.log(1024)))
				return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
			end,
		}

		-- Diagnostics
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = {
				error_icon = " ",
				warn_icon = " ",
				info_icon = "󰋇 ",
				hint_icon = "󰌵 ",
			},
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors)
				end,
				hl = { fg = "diag_error" },
			},
			{
				condition = function(self)
					return self.errors > 0 and self.warnings > 0
				end,
				provider = " ",
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings)
				end,
				hl = { fg = "diag_warn" },
			},
			{
				condition = function(self)
					return (self.errors > 0 or self.warnings > 0) and self.info > 0
				end,
				provider = " ",
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info)
				end,
				hl = { fg = "diag_info" },
			},
			{
				condition = function(self)
					return (self.errors > 0 or self.warnings > 0 or self.info > 0) and self.hints > 0
				end,
				provider = " ",
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = "diag_hint" },
			},
		}

		-- LSP Active Clients
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return " [" .. table.concat(names, " ") .. "]"
			end,
			hl = { fg = "green", bold = true },
		}

		-- Formatter Status (conform.nvim)
		local FormatterStatus = {
			condition = function()
				local ok, conform = pcall(require, "conform")
				if not ok then
					return false
				end
				local formatters = conform.list_formatters(0)
				return #formatters > 0
			end,
			provider = function()
				local conform = require("conform")
				local formatters = conform.list_formatters(0)
				local names = vim.tbl_map(function(f)
					return f.name
				end, formatters)
				return " [" .. table.concat(names, " ") .. "]"
			end,
			hl = { fg = "orange", bold = true },
		}

		-- Linter Status (nvim-lint)
		local LinterStatus = {
			condition = function()
				local ok, lint = pcall(require, "lint")
				if not ok then
					return false
				end
				-- Get linters for current filetype
				local linters = lint.linters_by_ft[vim.bo.filetype]
				if not linters then
					return false
				end
				-- Handle both table and function return values
				if type(linters) == "function" then
					linters = linters()
				end
				return linters and #linters > 0
			end,
			provider = function()
				local lint = require("lint")
				local linters = lint.linters_by_ft[vim.bo.filetype] or {}
				-- Handle function return
				if type(linters) == "function" then
					linters = linters()
				end
				if linters and #linters > 0 then
					return "󱉶 [" .. table.concat(linters, " ") .. "]"
				end
				return ""
			end,
			hl = { fg = "cyan", bold = true },
			update = { "BufEnter", "FileType" },
		}

		-- Navic (breadcrumbs)
		-- local Navic = {
		-- 	condition = function()
		-- 		return require("nvim-navic").is_available()
		-- 	end,
		-- 	static = {
		-- 		type_hl = {
		-- 			File = "Directory",
		-- 			Module = "@include",
		-- 			Namespace = "@namespace",
		-- 			Package = "@include",
		-- 			Class = "@structure",
		-- 			Method = "@method",
		-- 			Property = "@property",
		-- 			Field = "@field",
		-- 			Constructor = "@constructor",
		-- 			Enum = "@field",
		-- 			Interface = "@type",
		-- 			Function = "@function",
		-- 			Variable = "@variable",
		-- 			Constant = "@constant",
		-- 			String = "@string",
		-- 			Number = "@number",
		-- 			Boolean = "@boolean",
		-- 			Array = "@field",
		-- 			Object = "@type",
		-- 			Key = "@keyword",
		-- 			Null = "@comment",
		-- 			EnumMember = "@field",
		-- 			Struct = "@structure",
		-- 			Event = "@keyword",
		-- 			Operator = "@operator",
		-- 			TypeParameter = "@type",
		-- 		},
		-- 		enc = function(line, col, winnr)
		-- 			return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
		-- 		end,
		-- 		dec = function(c)
		-- 			local line = bit.rshift(c, 16)
		-- 			local col = bit.band(bit.rshift(c, 6), 1023)
		-- 			local winnr = bit.band(c, 63)
		-- 			return line, col, winnr
		-- 		end,
		-- 	},
		-- 	init = function(self)
		-- 		local data = require("nvim-navic").get_data() or {}
		-- 		local children = {}
		-- 		for i, d in ipairs(data) do
		-- 			local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
		-- 			local child = {
		-- 				{
		-- 					provider = d.icon,
		-- 					hl = self.type_hl[d.type],
		-- 				},
		-- 				{
		-- 					provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
		-- 					on_click = {
		-- 						minwid = pos,
		-- 						callback = function(_, minwid)
		-- 							local line, col, winnr = self.dec(minwid)
		-- 							vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
		-- 						end,
		-- 						name = "heirline_navic",
		-- 					},
		-- 				},
		-- 			}
		-- 			if #data > 1 and i < #data then
		-- 				table.insert(child, {
		-- 					provider = " > ",
		-- 					hl = { fg = "bright_fg" },
		-- 				})
		-- 			end
		-- 			table.insert(children, child)
		-- 		end
		-- 		self.child = self:new(children, 1)
		-- 	end,
		-- 	provider = function(self)
		-- 		return self.child:eval()
		-- 	end,
		-- 	hl = { fg = "gray" },
		-- 	update = "CursorMoved",
		-- }

		-- Ruler (cursor position)
		local Ruler = {
			provider = " %7(%l/%3L%):%2c %P",
			hl = { fg = "blue", bold = true },
		}

		-- Scrollbar
		local ScrollBar = {
			static = {
				sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
			},
			provider = function(self)
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
				return string.rep(self.sbar[i], 2)
			end,
			hl = { fg = "blue", bg = "bright_bg" },
		}

		-- Spacers
		local Space = { provider = " " }
		local Align = { provider = "%=" }

		--------------------------------------------------------------------------
		-- ASSEMBLE STATUSLINE
		--------------------------------------------------------------------------
		local DefaultStatusline = {
			ViMode,
			Space,
			Git,
			Space,
			-- FileLastModified,
			Diagnostics,
			Align,
			Space,
			Space,
			Space,
			Space,
			Space,
			Space,
			Space,
			Space,
			FileNameBlock,
			-- Navic,
			Align,
			LSPActive,
			Space,
			FormatterStatus,
			Space,
			LinterStatus,
			-- FileEncoding,
			-- FileFormat,
			-- FileType,
			-- FileSize,
			Space,
			Ruler,
			Space,
			ScrollBar,
		}

		local InactiveStatusline = {
			condition = conditions.is_not_active,
			FileNameBlock,
			Align,
		}

		local SpecialStatusline = {
			condition = function()
				return conditions.buffer_matches({
					buftype = { "nofile", "prompt", "help", "quickfix" },
					filetype = { "^git.*", "fugitive" },
				})
			end,
			FileType,
			Space,
			Align,
		}

		local StatusLines = {
			hl = function()
				if conditions.is_active() then
					return "StatusLine"
				else
					return "StatusLineNC"
				end
			end,
			fallthrough = false,
			SpecialStatusline,
			InactiveStatusline,
			DefaultStatusline,
		}

		--------------------------------------------------------------------------
		-- WINBAR CONFIGURATION
		--------------------------------------------------------------------------
		local FileIcon_Winbar = {
			init = function(self)
				local filename = vim.api.nvim_buf_get_name(0)
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_hl =
					require("nvim-web-devicons").get_icon_by_filetype(extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return self.icon_hl
			end,
		}

		local FilePath = {
			provider = function()
				local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
				if path == "" then
					return "[No Name]"
				end
				return path
			end,
		}

		-- Navic for Winbar (more visible here)
		local NavicWinbar = {
			condition = function()
				return require("nvim-navic").is_available()
			end,
			provider = function()
				return require("nvim-navic").get_location()
			end,
			hl = { fg = "gray" },
			update = "CursorMoved",
		}

		local winbar = {
			condition = function()
				return not conditions.buffer_matches({
					buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
					filetype = { "^git.*", "fugitive" },
				})
			end,
			hl = function()
				if not conditions.is_active() then
					return { fg = "gray", bg = "NONE" }
				end
			end,
			FileIcon_Winbar,
			FilePath,
			{ provider = " > " },
			NavicWinbar,
		}

		--------------------------------------------------------------------------
		-- TABLINE CONFIGURATION (BUFFERS)
		--------------------------------------------------------------------------
		local TablineBufnr = {
			provider = function(self)
				return tostring(self.bufnr) .. ". "
			end,
			hl = "Comment",
		}

		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
				return filename
			end,
			hl = function(self)
				return { bold = self.is_active or self.is_visible, italic = true }
			end,
		}

		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				provider = "[+]",
				hl = { fg = "green" },
			},
			{
				condition = function(self)
					return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
						or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
				end,
				provider = function(self)
					if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
						return "  "
					else
						return ""
					end
				end,
				hl = { fg = "orange" },
			},
		}

		local TablineFileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			hl = function(self)
				if self.is_active then
					return "TabLineSel"
				else
					return "TabLine"
				end
			end,
			on_click = {
				callback = function(_, minwid, _, button)
					if button == "m" then
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
						end)
					else
						vim.api.nvim_win_set_buf(0, minwid)
					end
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_tabline_buffer_callback",
			},
			TablineBufnr,
			TablineFileName,
			TablineFileFlags,
		}

		local BufferLine = utils.make_buflist(
			TablineFileNameBlock,
			{ provider = " ", hl = { fg = "gray" } },
			{ provider = " ", hl = { fg = "gray" } }
		)

		local Tabpage = {
			provider = function(self)
				return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
			end,
			hl = function(self)
				if not self.is_active then
					return "TabLine"
				else
					return "TabLineSel"
				end
			end,
		}

		local TabPages = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{ provider = "%=" },
			utils.make_tablist(Tabpage),
		}

		local tabline = { BufferLine, TabPages }

		--------------------------------------------------------------------------
		-- STATUSCOLUMN CONFIGURATION
		--------------------------------------------------------------------------
		local statuscolumn = {
			init = function(self)
				self.bufnr = vim.api.nvim_get_current_buf()
				if not self.bufnr then return end

				self.diagnostics = vim.diagnostic.get(self.bufnr, { lnum = (vim.v.lnum or 1) - 1 })
				local signs = vim.fn.sign_getplaced(self.bufnr, { group = "gitsigns", lnum = (vim.v.lnum or 1) })[1]
				self.gitsign = signs and #signs.signs > 0 and signs.signs[1] or nil
			end,
			{
				provider = function(self)
					return self.gitsign and self.gitsign.text or " "
				end,
				hl = function(self)
					if self.gitsign then
						return { fg = self.gitsign.texthl }
					end
				end,
			},
			{
				provider = function(self)
					if self.diagnostics and #self.diagnostics > 0 then
						local severity = self.diagnostics[1].severity
						if severity == vim.diagnostic.severity.ERROR then return "" end
						if severity == vim.diagnostic.severity.WARN then return "" end
					end
					return " "
				end,
				hl = function(self)
					if self.diagnostics and #self.diagnostics > 0 then
						local severity = self.diagnostics[1].severity
						if severity == vim.diagnostic.severity.ERROR then
							return { fg = "#f7768e" }
						elseif severity == vim.diagnostic.severity.WARN then
							return { fg = "#e0af68" }
						end
					end
				end,
			},
			{
				-- MANUAL CALCULATION PROVIDER (Crash-proof)
				provider = function()
					local lnum = vim.v.lnum
					if not lnum then return "    " end

					-- Check if relative numbers are enabled
					if vim.wo.relativenumber then
						-- Get the cursor line manually
						local cursor = vim.fn.line('.')
						-- Calculate relative distance (Math.abs)
						local rel = math.abs(lnum - cursor)

						-- Logic: If current line (0 distance), show real line number.
						-- Otherwise, show the distance.
						if rel == 0 then
							return string.format("%3d", lnum)
						else
							return string.format("%3d", rel)
						end
					else
						-- If relative numbers are off, just show absolute
						return string.format("%3d", lnum)
					end
				end,
				hl = function()
					local lnum = vim.v.lnum or 0
					local cursor = vim.fn.line('.')
					local rel = math.abs(lnum - cursor)

					-- Highlight current line (distance 0) differently
					if rel == 0 then
						return { fg = "blue", bold = true }
					else
						return { fg = "gray" }
					end
				end,
			},
			{ provider = " " },
		}

		--------------------------------------------------------------------------
		-- FINAL SETUP
		--------------------------------------------------------------------------
		heirline.setup({
			statusline = StatusLines,
			winbar = winbar,
			tabline = tabline,
			statuscolumn = statuscolumn,
			opts = {
				colors = colors,
			},
		})

		-- Refresh colors on colorscheme change
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = "Heirline",
			callback = function()
				utils.on_colorscheme(colors)
			end,
		})

		-- Enable tabline and statuscolumn
		vim.o.showtabline = 2 -- Always show tabline
		vim.o.statuscolumn = "%!v:lua.require'heirline'.eval_statuscolumn()"
	end,
}
