return {
	{
		"olimorris/codecompanion.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							model = "gemini-2.0-flash", -- Specify model version here
							env = {
								api_key = "AIzaSyDYSoicKbtiBmh9f6bQbvPJbixS5AKzXhY",
							},
						})
					end,
				},
				strategies = {
					agent = {
						adapter = "gemini",
						model = "gemini-2.0-flash", -- Per-strategy override
					},
					chat = {
						adapter = "gemini",
						model = "gemini-2.0-flash", -- Default model for chat
						variables = {
							["git diff"] = {
								callback = function()
									-- Windows-compatible git diff
									local diff_command = "git diff --no-ext-diff HEAD"
									if vim.fn.executable("powershell") == 1 then
										diff_command = "powershell.exe -Command git diff --no-ext-diff HEAD"
									end
									return string.format(
										[[
                    ```
                    %s
                    ```
                    ]],
										vim.fn.system(diff_command)
									)
								end,
								description = "Share the current git diff with the LLM",
								opts = { contains_code = true, hide_reference = true },
							},
						},
					},
					inline = {
						adapter = "gemini",
						model = "gemini-2.0-flash", -- Faster model for inline
					},
				},
			})
		end,
	},
}
