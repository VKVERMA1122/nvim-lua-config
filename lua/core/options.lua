local opt = vim.opt

-- Define Vim options in a table for clarity and easy management
-- Refactor: Simplified option setting by directly applying values using vim.opt
local options = {
	relativenumber = { value = true, type = "boolean", desc = "Enable relative line numbers" },
	number = { value = true, type = "boolean", desc = "Enable absolute line numbers" },
	tabstop = { value = 2, type = "number", desc = "Tab width" },
	shiftwidth = { value = 2, type = "number", desc = "Indent width" },
	expandtab = { value = true, type = "boolean", desc = "Expand tabs to spaces" },
	autoindent = { value = true, type = "boolean", desc = "Copy indent from current line" },
	wrap = { value = false, type = "boolean", desc = "Disable line wrapping" },
	ignorecase = { value = true, type = "boolean", desc = "Ignore case in searches" },
	smartcase = { value = true, type = "boolean", desc = "Smart case in searches" },
	cursorline = { value = true, type = "boolean", desc = "Enable cursor line" },
	termguicolors = { value = true, type = "boolean", desc = "Enable true color support" },
	cmdheight = { value = 0, type = "number", desc = "Reduce command line height" },
	numberwidth = { value = 3, type = "number", desc = "Number column width" },
	signcolumn = { value = "yes", type = "string", desc = "Automatic sign column width" },
	fillchars = {
		value = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:",
		type = "string",
		desc = "Fill characters",
	},
	foldcolumn = { value = "0", type = "string", desc = "Fold column width" },
	foldlevel = { value = 99, type = "number", desc = "Fold level" },
	foldlevelstart = { value = 99, type = "number", desc = "Fold level start" },
	foldenable = { value = true, type = "boolean", desc = "Enable folding" },
	backspace = { value = "indent,eol,start", type = "string", desc = "Backspace behavior" },
	splitright = { value = true, type = "boolean", desc = "Split vertical window to the right" },
	splitbelow = { value = true, type = "boolean", desc = "Split horizontal window to the bottom" },
	swapfile = { value = false, type = "boolean", desc = "Disable swapfile" },
	clipboard = { value = "unnamedplus", type = "string", desc = "Enable system clipboard integration" },
	mouse = { value = "a", type = "string", desc = "Mouse support" },
	showmode = { value = false, type = "boolean", desc = "Show mode in command line" },
}

-- Iterate through the options table and set them using vim.opt
for name, config in pairs(options) do
	local success, err = pcall(function()
		-- Refactor: Directly set vim.opt[name] based on type
		if config.type == "boolean" then
			opt[name] = config.value
		elseif config.type == "number" then
			opt[name] = tonumber(config.value) -- Ensure value is a number
		else -- string
			opt[name] = tostring(config.value) -- Ensure value is a string
		end
	end)
	if not success then
		vim.api.nvim_err_writeln("Error setting option " .. name .. ": " .. err)
	end
end

-- Specific option settings
opt.statuscolumn = "%l%s" -- Status column on the right
-- Refactor: Removed redundant guifont setting, using opt consistently
vim.wo.foldmethod = "expr" -- Use window-local option for foldmethod
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use window-local option for foldexpr
opt.guifont = "FiraCode NFM:h14" -- Set preferred guifont

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local function set_powershell_options()
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}
	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
end

--setting shell to powershell
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 or vim.fn.has("win16") == 1 then
	set_powershell_options()
end

--neovide
if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.o.guifont = "FiraCode NFM:h10.5"
	vim.g.neovide_padding_top = 0
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	vim.g.neovide_cursor_antialiasing = true
	-- vim.g.neovide_fullscreen = true
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_theme = "auto"
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_cursor_animation_length = 0
end

--terminal options
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("term_options", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

--lsp cmp
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldmethod = "expr"
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

vim.api.nvim_create_autocmd("LspDetach", { command = "setl foldexpr<" })
vim.diagnostic.config({ virtual_text = true })

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- Found a supporting client, no need to check others
				end
			end

			-- 3. Proceed only if an LSP is active AND supports the feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
