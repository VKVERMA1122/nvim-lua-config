local keymap = vim.keymap -- for conciseness

function is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

-- General Keymaps

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<ESC><ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

--buffer navigation
keymap.set("n", "[b", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })
keymap.set("n", "]b", "<cmd>bprev<cr>", { desc = "Switch to previous buffer" })
keymap.set("n", "'b", "<cmd>bd<cr>", { desc = "Switch close current buffer" })

--terminal navigation
keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })

--splits
keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- Splits navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize split up" })
keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize split down" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize split left" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize split right" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
