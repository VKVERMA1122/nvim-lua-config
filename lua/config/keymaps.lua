-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

--splits
keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height

-- Splits navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize split up" })
keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize split down" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize split left" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize split right" })

-- terminal
keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

--terminal navigation
keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })
keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
