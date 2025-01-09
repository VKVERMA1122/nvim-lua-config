return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	version = "*",
	keys = {
		{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<leader>bc", "<cmd>BufferLineClose<cr>", desc = "Close Buffer" },
	},
	opts = {
		options = {
			filetype_exclude = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
			mode = "buffer",
			diagnostics = "nvim_lsp",
			diagnostics_update_on_event = true, -- use nvim's diagnostic handler
			buffer_close_icon = "󰅖",
			modified_icon = "● ",
			close_icon = " ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
}
