return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	version = "*",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs",
				diagnostics = "nvim_lsp",
				diagnostics_update_on_event = true,
				buffer_close_icon = "󰅖",
				modified_icon = "● ",
				close_icon = " ",
				left_trunc_marker = " ",
				right_trunc_marker = " ",
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		})
		vim.cmd("set showtabline=0")
		-- More robust method to handle Alpha
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = "alpha",
			callback = function()
				vim.cmd("set showtabline=0")
			end,
		})

		vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
			pattern = "alpha",
			callback = function()
				vim.cmd("set showtabline=2")
			end,
		})
	end,
}
