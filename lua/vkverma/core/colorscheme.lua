local status, _ = pcall(vim.cmd, "colorscheme onedark")
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end
vim.api.nvim_command("hi Normal guibg=none ctermbg=none")
vim.api.nvim_command("hi LineNr guibg=none ctermbg=none")
vim.api.nvim_command("hi Folded guibg=none ctermbg=none")
vim.api.nvim_command("hi NonText guibg=none ctermbg=none")
vim.api.nvim_command("hi SpecialKey guibg=none ctermbg=none")
vim.api.nvim_command("hi VertSplit guibg=none ctermbg=none")
vim.api.nvim_command("hi SignColumn guibg=none ctermbg=none")
vim.api.nvim_command("hi EndOfBuffer guibg=none ctermbg=none")
