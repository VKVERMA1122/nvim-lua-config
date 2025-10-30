-- Simple Heirline.nvim setup mirroring the lualine layout.
-- Plugin spec (lazy loaded) for your plugin manager.
return {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Helpers (trim)
		local function trim(s)
			if s == nil then
				return nil
			end
			return s:match("^%s*(.-)%s*$")
		end

		-- LSP client (first only)
		local lsp_client = {
			provider = function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients > 0 then
					local name = trim(clients[1].name or "")
					name = name:gsub("_", "-")
					name = name:gsub("^%l", string.upper)
					return " " .. name
				end
				return nil
			end,
			condition = function()
				return #vim.lsp.get_clients({ bufnr = 0 }) > 0
			end,
			hl = { fg = "#98be65", bold = true },
		}

		-- Formatter status (conform)
		local formatter_status = {
			provider = function()
				local ok, formatters = pcall(require("conform").list_formatters, 0)
				if ok and #formatters > 0 then
					local names = vim.tbl_map(function(f)
						return f.name
					end, formatters)
					return table.concat(names, ", ")
				end
				return nil
			end,
			condition = function()
				local ok, formatters = pcall(require("conform").list_formatters, 0)
				return ok and #formatters > 0
			end,
			hl = { fg = "#ff6c6b" },
		}

		-- Lint status (nvim-lint via diagnostics)
		local lint_status = {
			provider = function()
				local diagnostics = vim.diagnostic.get(0)
				local e, w = 0, 0
				for _, d in ipairs(diagnostics) do
					if d.source == "nvim-lint" then
						if d.severity == vim.diagnostic.severity.ERROR then
							e = e + 1
						end
						if d.severity == vim.diagnostic.severity.WARN then
							w = w + 1
						end
					end
				end
				if e + w > 0 then
					return string.format("L:%d W:%d", e, w)
				end
				return nil
			end,
			condition = function()
				local diagnostics = vim.diagnostic.get(0)
				for _, d in ipairs(diagnostics) do
					if d.source == "nvim-lint" then
						return true
					end
				end
				return false
			end,
			hl = { fg = "#ffcc00" },
		}

		-- Diagnostics summary
		local diagnostics_status = {
			provider = function()
				local diagnostics = vim.diagnostic.get(0)
				local e, w = 0, 0
				for _, d in ipairs(diagnostics) do
					if d.severity == vim.diagnostic.severity.ERROR then
						e = e + 1
					end
					if d.severity == vim.diagnostic.severity.WARN then
						w = w + 1
					end
				end
				if e + w > 0 then
					return string.format("E:%d W:%d", e, w)
				end
				return nil
			end,
			condition = function()
				local diagnostics = vim.diagnostic.get(0)
				return #diagnostics > 0
			end,
			hl = { fg = "#51afef" },
		}

		-- Git diff component (uses gitsigns if available)
		local git_diff = {
			init = function(self)
				self.gitsigns = vim.b.gitsigns_status_dict
			end,
			provider = function(self)
				if not self.gitsigns then
					return ""
				end
				local added = self.gitsigns.added or 0
				local changed = self.gitsigns.changed or 0
				local removed = self.gitsigns.removed or 0
				return string.format("+%d ~%d -%d", added, changed, removed)
			end,
			condition = function()
				return vim.b.gitsigns_status_dict ~= nil
			end,
			hl = { fg = "#9ece6a" },
		}

		-- File info
		local filename = {
			provider = function()
				return vim.fn.expand("%:t")
			end,
			hl = { fg = "#7aa2f7" },
		}

		-- Mode (simple)
		local mode = {
			provider = function()
				return vim.fn.mode():sub(1, 1):upper()
			end,
			hl = function()
				local m = vim.fn.mode()
				if m == "n" then
					return { fg = "#89dceb" }
				end
				return { fg = "#c0caf5" }
			end,
		}

		-- Clock
		local clock = {
			provider = function()
				return os.date("%R")
			end,
			hl = { fg = "#c0caf5" },
		}

		-- Advanced diagnostics component (icons + counts) — commented out for now
		--[[
		local diagnostics_detailed = {
			provider = function()
				local diagnostics = vim.diagnostic.get(0)
				local errors, warns = 0, 0
				for _, d in ipairs(diagnostics) do
					if d.severity == vim.diagnostic.severity.ERROR then errors = errors + 1 end
					if d.severity == vim.diagnostic.severity.WARN then warns = warns + 1 end
				end
				if errors + warns == 0 then return nil end
				return string.format(' %d  %d', errors, warns)
			end,
			condition = function()
				return #vim.diagnostic.get(0) > 0
			end,
			hl = { fg = '#f7768e' },
		}
		]]

		-- Assemble the heirline statusline (components reordered: lsp/formatter/lint/git before filename)
		local left = {
			mode,
			{ provider = " " },
			{
				provider = function()
					return vim.b.gitsigns_head or ""
				end,
				hl = { fg = "#bb9af7" },
			},
			{ provider = " " },
			filename,
		}

		local right = {
			lsp_client,
			{ provider = " " },
			formatter_status,
			{ provider = " " },
			lint_status,
			{ provider = " " },
			git_diff,
			{ provider = " " },
			clock,
			{ provider = " " },
			{
				provider = function()
					return string.format("%s/%s", vim.fn.line("."), vim.fn.line("$"))
				end,
			},
		}

		local statusline = {}
		for _, v in ipairs(left) do
			table.insert(statusline, v)
		end
		table.insert(statusline, { provider = "%=" })
		for _, v in ipairs(right) do
			table.insert(statusline, v)
		end
		heirline.setup({ statusline = statusline })
	end,
}
