return {
	{
		"olimorris/codecompanion.nvim",
		event = "InsertEnter", -- or any other event that triggers the plugin
		config = function()
			require("codecompanion").setup({
				opts = {
					llm = "copilot", -- Specify Copilot as the LLM
					model = "copilot", --Specify Copilot model
				},
				strategies = {
					agent = { adapter = "copilot" },
					chat = {
						adapter = "copilot",
						variables = {
							["git diff"] = {
								callback = function()
									return string.format(
										[[
    ```diff
    %s
    ```
    ]],
										vim.fn.system("git diff --no-ext-diff HEAD")
									)
								end,
								description = "Share the current git diff with the LLM",
								opts = { contains_code = true, hide_reference = true },
							},
						},
					},
				},
			})
		end,
	},
}
