-- nvim-treesitter shells out to the `tree-sitter` CLI to build parsers.
-- On Windows it defaults to MSVC (`cl.exe`), which isn't installed here.
-- The `cc` crate used by tree-sitter respects the `CC` env var, so point it
-- at `gcc` (available via scoop) when MSVC is missing.
if vim.fn.has("win32") == 1 and vim.fn.executable("cl") == 0 and vim.fn.executable("gcc") == 1 then
	vim.env.CC = "gcc"
end

require("core.options")
require("core.keymaps")
