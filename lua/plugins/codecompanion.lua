local model_name = "gemini-2.0-pro-exp-02-05"
return {
	{
		"olimorris/codecompanion.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local config = require("/apis") -- Removed requiring the /apis file
			require("codecompanion").setup({
				diff_cache_duration = 60, -- seconds
				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							model = model_name,
							env = {
								api_key = config.gemini_api_key, -- Use environment variable
							},
						})
					end,
				},
				strategies = {
					agent = {
						adapter = "gemini",
						model = model_name,
					},
					chat = {
						adapter = "gemini",
						model = model_name,
						variables = {
							["git diff"] = {
								callback = function(opts)
									local diff_cache = {}
									local diff_cache_duration = opts.diff_cache_duration or 60 -- seconds
									local diff_command = "git diff --no-ext-diff HEAD"
									if vim.fn.executable("powershell") == 1 then
										diff_command = "powershell.exe -Command git diff --no-ext-diff HEAD"
									end
									local cache_key = diff_command
									if diff_cache[cache_key] and vim.loop.now() - diff_cache[cache_key].timestamp < diff_cache_duration * 1000 then
										return diff_cache[cache_key].output
									end
									local ok, diff_output = pcall(vim.fn.system, diff_command)
									if not ok then
										return "Error executing git diff command."
									end
									if diff_output == nil or diff_output == "" then
										return "No git diff available."
									else
										local formatted_output = string.format(
											[[
			                     ```
			                     %s
			                     ```
			                   ]],
											diff_output
										)
										diff_cache[cache_key] = {
											output = formatted_output,
											timestamp = vim.loop.now(),
										}
										return formatted_output
									end
								end,
								description = "Share the current git diff with the LLM",
								opts = { contains_code = true, hide_reference = true },
							},
						},
					},
					inline = {
						adapter = "gemini",
					},
				},
			})
		end,
	},
}
