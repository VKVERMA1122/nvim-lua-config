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
  fillchars = { value = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:", type = "string", desc = "Fill characters" },
  foldcolumn = { value = "0", type = "string", desc = "Fold column width" },
  foldlevel = { value = 99, type = "number", desc = "Fold level" },
  foldlevelstart = { value = 99, type = "number", desc = "Fold level start" },
  foldenable = { value = true, type = "boolean", desc = "Enable folding" },
  backspace = { value = "indent,eol,start", type = "string", desc = "Backspace behavior" },
  splitright = { value = true, type = "boolean", desc = "Split vertical window to the right" },
  splitbelow = { value = true, type = "boolean", desc = "Split horizontal window to the bottom" },
  swapfile = { value = false, type = "boolean", desc = "Disable swapfile" },
}

-- Iterate through the options table and set them using vim.opt
for name, config in pairs(options) do
  local success, err = pcall(function()
    -- Refactor: Directly set vim.opt[name] based on type
    if config.type == "boolean" then
      opt[name] = config.value
    elseif config.type == "number" then
      opt[name] = tonumber(config.value) -- Ensure value is a number
    else                                 -- string
      opt[name] = tostring(config.value) -- Ensure value is a string
    end
  end)
  if not success then
    vim.api.nvim_err_writeln("Error setting option " .. name .. ": " .. err)
  end
end

-- Specific option settings
opt.statuscolumn = "%l%s"                           -- Status column on the right
-- Refactor: Removed redundant guifont setting, using opt consistently
vim.wo.foldmethod = "expr"                          -- Use window-local option for foldmethod
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use window-local option for foldexpr
opt.guifont = "FiraCode NFM:h14"                    -- Set preferred guifont

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local function set_powershell_options()
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
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
