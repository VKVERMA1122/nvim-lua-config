vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local toggles = require("core.toggles")

local keymaps = {
  {
    mode = "i",
    lhs = "jk",
    rhs = "<ESC>",
    opts = { desc = "Exit insert mode with jk" },
  },
  {
    mode = "n",
    lhs = "<ESC>",
    rhs = ":nohl<CR>",
    opts = { desc = "Clear search highlights" },
  },

  -- Increment/decrement numbers
  {
    mode = "n",
    lhs = "<leader>+",
    rhs = "<C-a>",
    opts = { desc = "Increment number" },
  },
  {
    mode = "n",
    lhs = "<leader>-",
    rhs = "<C-x>",
    opts = { desc = "Decrement number" },
  },

  -- Splits
  { mode = "n", lhs = "|", rhs = "<cmd>vsplit<cr>", opts = { desc = "Vertical Split" } },
  {
    mode = "n",
    lhs = "\\",
    rhs = "<cmd>split<cr>",
    opts = { desc = "Horizontal Split" },
  },
  {
    mode = "n",
    lhs = "<leader>se",
    rhs = "<C-w>=",
    opts = { desc = "Make splits equal size" },
  },

  -- Splits navigation
  {
    mode = "n",
    lhs = "<C-h>",
    rhs = "<C-w>h",
    opts = { desc = "Move to left split" },
  },
  {
    mode = "n",
    lhs = "<C-j>",
    rhs = "<C-w>j",
    opts = { desc = "Move to below split" },
  },
  {
    mode = "n",
    lhs = "<C-k>",
    rhs = "<C-w>k",
    opts = { desc = "Move to above split" },
  },
  {
    mode = "n",
    lhs = "<C-l>",
    rhs = "<C-w>l",
    opts = { desc = "Move to right split" },
  },
  {
    mode = "n",
    lhs = "<C-Up>",
    rhs = "<cmd>resize -2<CR>",
    opts = { desc = "Resize split up" },
  },
  {
    mode = "n",
    lhs = "<C-Down>",
    rhs = "<cmd>resize +2<CR>",
    opts = { desc = "Resize split down" },
  },
  {
    mode = "n",
    lhs = "<C-Left>",
    rhs = "<cmd>vertical resize -2<CR>",
    opts = { desc = "Resize split left" },
  },
  {
    mode = "n",
    lhs = "<C-Right>",
    rhs = "<cmd>vertical resize +2<CR>",
    opts = { desc = "Resize split right" },
  },

  -- Terminal
  {
    mode = "t",
    lhs = "<C-x>",
    rhs = "<C-\\><C-N>",
    opts = { desc = "Terminal escape terminal mode" },
  },

  -- Tabs navigation (Commented out)
  -- { mode = "n", lhs = "<Tab>", rhs = "gt", opts = { desc = "Switch to next tab" } },
  -- { mode = "n", lhs = "<S-Tab>", rhs = "gT", opts = { desc = "Switch to previous tab" } },
  -- { mode = "n", lhs = "tc", rhs = "<cmd>:tabclose<cr>", opts = { desc = "Close current tab" } },
  -- { mode = "n", lhs = "<leader>tn", rhs = "<cmd>:tabnew<cr>", opts = { desc = "Create new tab" } },

  -- Refactor: Removed redundant <C-hjkl> mappings for terminal navigation.
  -- The mappings defined earlier (lines 26-29) using <C-w>h/j/k/l work universally for window navigation.

  -- Terminal escape
  {
    mode = "t",
    lhs = "<esc><esc>",
    rhs = "<c-\\><c-n>",
    opts = { desc = "Escape terminal mode" },
  }, -- Improvement: Added description

  -- Move selections
  {
    mode = "v",
    lhs = "J",
    rhs = ":m '>+1<CR>gv=gv",
    opts = { desc = "Shift visual selected line down" },
  },
  {
    mode = "v",
    lhs = "K",
    rhs = ":m '<-2<CR>gv=gv",
    opts = { desc = "Shift visual selected line up" },
  },


  -- Window navigation for centering the current line
  {
    mode = "n",
    lhs = "<C-d>",
    rhs = "<C-d>zz",
    opts = { desc = "Center line after scrolling down" },
  },
  {
    mode = "n",
    lhs = "<C-u>",
    rhs = "<C-u>zz",
    opts = { desc = "Center line after scrolling up" },
  },

  -- Buffer navigation handled by snacks.bufdelete (<leader>bd).
}

for _, map in ipairs(keymaps) do
  keymap.set(map.mode, map.lhs, map.rhs, map.opts)
end

-- Severity-aware diagnostic jumps (AstroNvim style).
keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Prev error" })
keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
keymap.set("n", "[w", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Prev warning" })
keymap.set("n", "]w", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Next warning" })

-- UI/UX toggles (<leader>u group).
keymap.set("n", "<leader>ud", toggles.diagnostics(), { desc = "Toggle diagnostics" })
keymap.set("n", "<leader>uv", toggles.virtual_text(), { desc = "Toggle virtual text" })
keymap.set("n", "<leader>uw", toggles.wrap(), { desc = "Toggle wrap" })
keymap.set("n", "<leader>us", toggles.spell(), { desc = "Toggle spell" })
keymap.set("n", "<leader>un", toggles.number(), { desc = "Toggle number" })
keymap.set("n", "<leader>ug", toggles.signcolumn(), { desc = "Toggle signcolumn" })
keymap.set("n", "<leader>ub", toggles.background(), { desc = "Toggle background" })
keymap.set("n", "<leader>uS", toggles.conceal(), { desc = "Toggle conceal" })
keymap.set("n", "<leader>uh", toggles.inlay_hints(false), { desc = "Toggle inlay hints (buffer)" })
keymap.set("n", "<leader>uH", toggles.inlay_hints(true), { desc = "Toggle inlay hints (global)" })
keymap.set("n", "<leader>uY", toggles.semantic_tokens(), { desc = "Toggle semantic tokens (buffer)" })
