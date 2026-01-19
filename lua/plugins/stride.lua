return {
	"jim-at-jibba/nvim-stride",
	event = "InsertEnter",
	config = function()
		require("stride").setup({
			api_key = "sadoeaifhdskjfdskj",
			endpoint = "https://kamallm.2025-05-25.sbs/v1/chat/completions",
			model = "gpt-oss-120b",
			accept_keymap = "<Tab>", -- Key to accept suggestion
			dismiss_keymap = "<Esc>", -- Key to dismiss suggestion (normal mode)
			mode = "both",
		})
	end,
}
