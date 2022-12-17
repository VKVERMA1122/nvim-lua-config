-- local status, _ = pcall(vim.cmd, "colorscheme gruvbox")
-- if not status then
--   print("Colorscheme not found!") -- print error if colorscheme not installed
--   return
-- end
--
local status, colorscheme= pcall(require, "onedark")
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end

colorscheme.setup {
    style = "cool"
}
colorscheme.load();

--vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
