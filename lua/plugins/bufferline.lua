return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  version = "*",
  keys = {
    { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "bc", "<cmd>bdelete<cr>", desc = "Close Buffer" },
  },
  opts = {},
}
