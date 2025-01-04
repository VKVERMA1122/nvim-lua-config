return {
	"echasnovski/mini.jump2d",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mini.jump2d").setup({
			init = function()
				vim.api.nvim_create_autocmd("User", {
					pattern = "MiniFilesWindowOpen",
					callback = function(args)
						local win_id = args.data.win_id
						vim.api.nvim_win_set_config(win_id, { border = "thick" })
					end,
				})
			end,
			view = {
				dim = true,
				-- n_steps_ahead = 2, -- Show more jump steps
			},
			mappings = {
				start_jumping = "<C-s>",
				jump_first = "<C-f>",
				jump_prev = "<C-b>",
			},
			allowed_lines = {
				blank = false,
				cursor_before = true,
				cursor_after = true,
			},
		})
	end,
}
