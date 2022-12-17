
local opt = vim.opt
local g = vim.g
opt.relativenumber = true
opt.number = true

-- line wrapping
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


-- split windows
g.splitright = true -- split vertical window to the right
g.splitbelow = true -- split horizontal window to the bottom
g.netrw_banner=0
g.netrw_altv=1
g.netrw_browse_split=4
g.netrw_liststyle=3
g.netrw_winsize = 25
vim.o.updatetime = 100
vim.o.lazyredraw = true
vim.o.cmdheight = 0
vim.opt.shell = vim.fn.executable "pwsh" and "pwsh" or "powershell"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
