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

-- --tabs navigation
-- keymap.set("n", "<Tab>", "gt", { desc = "Switch to next tab" })
-- keymap.set("n", "<S-Tab>", "gT", { desc = "Switch to previous tab" })
-- keymap.set("n", "tc", "<cmd>:tabclose<cr>", { desc = "Close current tab" })
-- keymap.set("n", "<leader>tn", "<cmd>:tabnew<cr>", { desc = "Create new tab" })

--terminal navigation
keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })
keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- move selections
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Shift visual selected line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Shift visual selected line up

-- spell check
vim.keymap.set("n", "<leader>ll", ":setlocal spell spelllang=en_us<CR>")

-- window navigation for centering the current line
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--buffer navigation
vim.keymap.set("n", "<tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-tab>", ":bprevious<CR>")
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")
