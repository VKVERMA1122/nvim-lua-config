return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			extensions = {
				fzf = {},
			},

			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<Enter>"] = "file_tab",
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
					n = {
						["<Enter>"] = "file_tab",
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
		keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>") -- list available colorscheme
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>") -- list available keymaps
		keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		keymap.set("n", "<leader><leader>", function()
			require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "Buffer search" })
		--telescope git keymap
		keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
		keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
		keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
		keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
