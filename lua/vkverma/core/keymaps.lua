vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<ESC><ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
-- keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab


keymap.set("n", "<leader>gl", function() vim.diagnostic.open_float() end, { desc = "Open floating diagnostic message" })
keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { desc = "Go to previous diagnostic message" })
keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { desc = "Go to next diagnostic message" })

keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Lsp goto definition" })
keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Lsp hover definition" })
keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP Code action" })
keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { desc = "LSP Code References " })
keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "LSP Code Rename" })
keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "LSP Signature Help" })
keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "LSP Buffer Format" })


--toggle terminal
-- keymap.set("n", "<C-/>", "ToggleTerm size=10 direction=horizontal<cr>", { desc = "ToggleTerm horizontal" })
--
-- Improved Terminal Navigation

keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "LSP Buffer Format" })

keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })

--folds
--keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
--keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
--vim.keymap.set("n", "K", function()
--   local winid = require("ufo").peekFoldedLinesUnderCursor()
--   if not winid then
--       -- choose one of coc.nvim and nvim lsp
--       vim.fn.CocActionAsync("definitionHover") -- coc.nvim
--       vim.lsp.buf.hover()
--   end
--end)
