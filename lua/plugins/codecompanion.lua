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
			})
		end,
	},
}
