vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

local function set_keymap(mode, lhs, rhs, opts)
  local success, err = pcall(keymap.set, mode, lhs, rhs, opts)
  if not success then
    vim.api.nvim_err_writeln("Error setting keymap " .. lhs .. ": " .. err)
  end
end

local keymaps = {
  { mode = "i", lhs = "jk", rhs = "<ESC>", opts = { desc = "Exit insert mode with jk" } },
  { mode = "n", lhs = "<ESC>", rhs = ":nohl<CR>", opts = { desc = "Clear search highlights" } },

  -- Increment/decrement numbers
  { mode = "n", lhs = "<leader>+", rhs = "<C-a>", opts = { desc = "Increment number" } },
  { mode = "n", lhs = "<leader>-", rhs = "<C-x>", opts = { desc = "Decrement number" } },

  -- Splits
  { mode = "n", lhs = "|", rhs = "<cmd>vsplit<cr>", opts = { desc = "Vertical Split" } },
  { mode = "n", lhs = "\\", rhs = "<cmd>split<cr>", opts = { desc = "Horizontal Split" } },
  { mode = "n", lhs = "<leader>se", rhs = "<C-w>=", opts = { desc = "Make splits equal size" } },

  -- Splits navigation
  { mode = "n", lhs = "<C-h>", rhs = "<C-w>h", opts = { desc = "Move to left split" } },
  { mode = "n", lhs = "<C-j>", rhs = "<C-w>j", opts = { desc = "Move to below split" } },
  { mode = "n", lhs = "<C-k>", rhs = "<C-w>k", opts = { desc = "Move to above split" } },
  { mode = "n", lhs = "<C-l>", rhs = "<C-w>l", opts = { desc = "Move to right split" } },
  { mode = "n", lhs = "<C-Up>", rhs = "<cmd>resize -2<CR>", opts = { desc = "Resize split up" } },
  { mode = "n", lhs = "<C-Down>", rhs = "<cmd>resize +2<CR>", opts = { desc = "Resize split down" } },
  { mode = "n", lhs = "<C-Left>", rhs = "<cmd>vertical resize -2<CR>", opts = { desc = "Resize split left" } },
  { mode = "n", lhs = "<C-Right>", rhs = "<cmd>vertical resize +2<CR>", opts = { desc = "Resize split right" } },

  -- Terminal
  { mode = "t", lhs = "<C-x>", rhs = "<C-\\><C-N>", opts = { desc = "Terminal escape terminal mode" } },

  -- Tabs navigation
  -- { mode = "n", lhs = "<Tab>", rhs = "gt", opts = { desc = "Switch to next tab" } },
  -- { mode = "n", lhs = "<S-Tab>", rhs = "gT", opts = { desc = "Switch to previous tab" } },
  -- { mode = "n", lhs = "tc", rhs = "<cmd>:tabclose<cr>", opts = { desc = "Close current tab" } },
  -- { mode = "n", lhs = "<leader>tn", rhs = "<cmd>:tabnew<cr>", opts = { desc = "Create new tab" } },

  -- Terminal navigation
  { mode = "n", lhs = "<C-h>", rhs = "<cmd>wincmd h<cr>", opts = { desc = "Terminal left window navigation" } },
  { mode = "n", lhs = "<C-j>", rhs = "<cmd>wincmd j<cr>", opts = { desc = "Terminal down window navigation" } },
  { mode = "n", lhs = "<C-k>", rhs = "<cmd>wincmd k<cr>", opts = { desc = "Terminal up window navigation" } },
  { mode = "n", lhs = "<C-l>", rhs = "<cmd>wincmd l<cr>", opts = { desc = "Terminal right window navigation" } },

  -- Terminal escape
  { mode = "t", lhs = "<esc><esc>", rhs = "<c-\\><c-n>"},

  -- Move selections
  { mode = "v", lhs = "J", rhs = ":m '>+1<CR>gv=gv", opts = { desc = "Shift visual selected line down" } },
  { mode = "v", lhs = "K", rhs = ":m '<-2<CR>gv=gv", opts = { desc = "Shift visual selected line up" } },

  -- Spell check
  { mode = "n", lhs = "<leader>ll", rhs = ":setlocal spell spelllang=en_us<CR>", opts = { desc = "Set spell check to en_us" } },

  -- Window navigation for centering the current line
  { mode = "n", lhs = "<C-d>", rhs = "<C-d>zz", opts = { desc = "Center line after scrolling down" } },
  { mode = "n", lhs = "<C-u>", rhs = "<C-u>zz", opts = { desc = "Center line after scrolling up" } },

  -- Buffer navigation
  { mode = "n", lhs = "<tab>", rhs = ":bnext<CR>", opts = { desc = "Go to next buffer" } },
  { mode = "n", lhs = "<S-tab>", rhs = ":bprevious<CR>", opts = { desc = "Go to previous buffer" } },
  { mode = "n", lhs = "<leader>bd", rhs = ":bdelete<CR>", opts = { desc = "Delete current buffer" } },
}

for _, map in ipairs(keymaps) do
  set_keymap(map.mode, map.lhs, map.rhs, map.opts)
end
