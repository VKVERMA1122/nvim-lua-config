local opt = vim.opt
local g = vim.g
local o = vim.o
opt.guicursor = ""
opt.relativenumber = true
opt.number = true
opt.wrap = false -- disable line wrapping
opt.tabstop = 2
opt.shiftwidth = 4
opt.tabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.clipboard:append("unnamedplus")
opt.shell = vim.fn.executable "pwsh" and "pwsh" or "powershell"
opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
opt.shellquote = ""
opt.shellxquote = ""
opt.updatetime = 50
-- split windows
g.splitright = true -- split vertical window to the right
g.splitbelow = true -- split horizontal window to the bottom

g.netrw_banner = 0
g.netrw_altv = 1
g.netrw_browse_split = 4
g.netrw_liststyle = 3
g.netrw_winsize = 25


o.lazyredraw = true
o.cmdheight = 0
o.completeopt = 'menu,noselect'

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
