-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

local custom_gruvbox = require'lualine.themes.gruvbox_dark'

-- Change the background of lualine_c section for normal mode
--custom_gruvbox.normal.c.bg = '#112233'
lualine.setup( {options = { theme  =  "auto"}})
