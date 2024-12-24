return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
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
