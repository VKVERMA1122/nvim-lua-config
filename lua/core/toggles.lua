-- UI/UX toggle helpers, inspired by AstroNvim's astrocore.toggles.
-- Each function returns a toggle that can be bound to a keymap and is
-- stateless (reads current option, flips it). A couple remember their
-- previous value so toggling back restores it exactly.
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
local function notify_option(option, value, silent)
	if silent then
		return
	end
	local message = option .. " " .. (value and "enabled" or "disabled")
	vim.notify(message, vim.log.levels.INFO, { title = "Toggle" })
end

-- Toggle a boolean option, optionally setting a custom value pair.
function M.option(option, silent, values)
	local function get()
		return vim.opt_local[option]:get()
	end
	local function set(value)
		vim.opt_local[option] = value
		notify_option(option, value, silent)
	end
	return {
		get = get,
		set = set,
		toggle = function()
			local current = get()
			if values then
				set(vim.deep_equal(current, values[1]) and values[2] or values[1])
			else
				set(not current)
			end
		end,
	}
end

-- Toggle `wrap`.
function M.wrap()
	return M.option("wrap").toggle
end

-- Toggle `spell`.
function M.spell()
	return M.option("spell").toggle
end

-- Toggle `conceallevel` between 0 and the current (or 2).
function M.conceal()
	local previous = {}
	return function()
		local win = vim.api.nvim_get_current_win()
		local conceallevel = vim.opt_local.conceallevel:get()
		if conceallevel == 0 then
			vim.opt_local.conceallevel = previous[win] or 2
		else
			previous[win] = conceallevel
			vim.opt_local.conceallevel = 0
		end
		notify_option("conceal", vim.opt_local.conceallevel:get() ~= 0)
	end
end

-- Cycle number/relativenumber: none -> absolute -> relative.
function M.number()
	return function()
		local number = vim.opt_local.number:get()
		local relativenumber = vim.opt_local.relativenumber:get()
		if not number and not relativenumber then
			vim.opt_local.number = true
		elseif number and not relativenumber then
			vim.opt_local.relativenumber = true
		else
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		end
		local state = vim.opt_local.relativenumber:get() and "rel" or vim.opt_local.number:get() and "abs" or "off"
		vim.notify("number " .. state, vim.log.levels.INFO, { title = "Toggle" })
	end
end

-- Cycle signcolumn: no -> yes -> auto.
function M.signcolumn()
	return function()
		local signcolumn = vim.opt_local.signcolumn:get()
		if signcolumn == "no" then
			vim.opt_local.signcolumn = "yes"
		elseif signcolumn == "yes" then
			vim.opt_local.signcolumn = "auto"
		else
			vim.opt_local.signcolumn = "no"
		end
		vim.notify("signcolumn " .. vim.opt_local.signcolumn:get(), vim.log.levels.INFO, { title = "Toggle" })
	end
end

-- Toggle background dark/light.
function M.background()
	return function()
		vim.o.background = vim.o.background == "dark" and "light" or "dark"
		vim.notify("background " .. vim.o.background, vim.log.levels.INFO, { title = "Toggle" })
	end
end

-- Toggle diagnostics globally, remembering the virtual_text config so it
-- restores exactly when re-enabled.
local diag_cache
function M.diagnostics()
	return function()
		local enabled = vim.diagnostic.is_enabled()
		if enabled then
			diag_cache = vim.diagnostic.config().virtual_text
			vim.diagnostic.enable(false)
		else
			vim.diagnostic.enable(true)
			if diag_cache ~= nil then
				vim.diagnostic.config({ virtual_text = diag_cache })
			end
		end
		vim.notify("diagnostics " .. (not enabled and "enabled" or "disabled"), vim.log.levels.INFO, { title = "Toggle" })
	end
end

-- Toggle diagnostic virtual_text only.
function M.virtual_text()
	return function()
		local vt = vim.diagnostic.config().virtual_text
		if type(vt) == "table" or vt == true then
			vim.diagnostic.config({ virtual_text = false })
		else
			vim.diagnostic.config({ virtual_text = true })
		end
		vim.notify(
			"virtual_text " .. (vim.diagnostic.config().virtual_text ~= false and "enabled" or "disabled"),
			vim.log.levels.INFO,
			{ title = "Toggle" }
		)
	end
end

-- Toggle LSP inlay hints (buffer-local by default, global with `true`).
---@param global? boolean
function M.inlay_hints(global)
	return function()
		local filter = global and nil or { bufnr = 0 }
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
		vim.notify(
			"inlay hints "
				.. (global and "global" or "buffer")
				.. " "
				.. (vim.lsp.inlay_hint.is_enabled(filter) and "enabled" or "disabled"),
			vim.log.levels.INFO,
			{ title = "Toggle" }
		)
	end
end

-- Toggle LSP semantic tokens (buffer-local).
function M.semantic_tokens()
	return function()
		local bufnr = 0
		local enabled = vim.lsp.semantic_tokens.is_enabled({ bufnr = bufnr })
		vim.lsp.semantic_tokens.enable(not enabled, { bufnr = bufnr })
		-- Force refresh of attached clients.
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
			if client:supports_method("textDocument/semanticTokens/full") then
				vim.lsp.semantic_tokens.force_refresh(bufnr)
			end
		end
		vim.notify(
			"semantic tokens " .. (not enabled and "enabled" or "disabled"),
			vim.log.levels.INFO,
			{ title = "Toggle" }
		)
	end
end

return M
