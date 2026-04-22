return {
	"NeogitOrg/neogit",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"esmuellert/codediff.nvim",
	},
	cmd = { "Neogit" },
	opts = {
		integrations = {
			codediff = true,
		},
		mappings = {
			status = {
				["<C-d>"] = function()
					local status = require("neogit.buffers.status")
					local instance = status.instance()
					if instance and instance.buffer and instance.buffer.ui then
						local item = instance.buffer.ui:get_item_under_cursor()
						if item and item.absolute_path then
							-- Open file in a new tab first
							vim.cmd("tabedit " .. vim.fn.fnameescape(item.absolute_path))
							-- Compare current file against HEAD
							vim.cmd("CodeDiff file HEAD")
						end
					end
				end,
			},
			log = {
				["<C-d>"] = function()
					local log_view = require("neogit.buffers.log_view")
					-- Access the singleton instance
					if log_view.instance and log_view.instance.buffer and log_view.instance.buffer.ui then
						local oid = log_view.instance.buffer.ui:get_commit_under_cursor()
						if oid then
							vim.cmd("CodeDiff " .. oid)
						end
					end
				end,
			},
		},
	},
}
