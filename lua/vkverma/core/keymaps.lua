vim.g.mapleader = " "

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

--lsp keymaps
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

--buffer navigation
keymap.set("n", "[b", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })
keymap.set("n", "]b", "<cmd>bprev<cr>", { desc = "Switch to previous buffer" })
keymap.set("n", "'b", "<cmd>bd<cr>", { desc = "Switch close current buffer" })

--terminal navigation
keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })
keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- GitSigns
-- keymap.set("n", "<leader>g", secteons.g)
keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next Git hunk" })
keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous Git hunk" })
keymap.set("n", "<leader>gl", function() require("gitsigns").blame_line() end, { desc = "View Git blame" })
keymap.set("n", "<leader>gL", function() require("gitsigns").blame_line { full = true } end,
  { desc = "View full Git blame" })
keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview Git hunk" })
keymap.set("n", "<leader>gh", function() require("gitsigns").reset_hunk() end, { desc = "Reset Git hunk" })
keymap.set("n", "<leader>gr", function() require("gitsigns").reset_buffer() end, { desc = "Reset Git buffer" })
keymap.set("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Git hunk" })
keymap.set("n", "<leader>gS", function() require("gitsigns").stage_buffer() end, { desc = "Stage Git buffer" })
keymap.set("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Unstage Git hunk" })
keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "View Git diff" })

--ToggleTerm 
keymap.set("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
  { desc = "ToggleTerm horizontal split" })
keymap.set("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical split" })
keymap.set("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap.set("t", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap.set("n", "<C-z>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" }) -- requires terminal that supports binding <C-'>
keymap.set("t", "<C-z>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" }) -- requires terminal that supports binding <C-'>

-- Smart Splits
if is_available "smart-splits.nvim" then
  keymap.set("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, { desc = "Move to left split" })
  keymap.set("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, { desc = "Move to below split" })
  keymap.set("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, { desc = "Move to above split" })
  keymap.set("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move to right split" })
  keymap.set("n", "<C-Up>", function() require("smart-splits").resize_up() end, { desc = "Resize split up" })
  keymap.set("n", "<C-Down>", function() require("smart-splits").resize_down() end, { desc = "Resize split down" })
  keymap.set("n", "<C-Left>", function() require("smart-splits").resize_left() end, { desc = "Resize split left" })
  keymap.set("n", "<C-Right>", function() require("smart-splits").resize_right() end, { desc = "Resize split right" })
else
  keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
  keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
  keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
  keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
  keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize split up" })
  keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize split down" })
  keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize split left" })
  keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize split right" })
end

--hop navigation
keymap.set("n","<leader>hw","<cmd>HopWord<cr>",{desc = "Hop word"})
