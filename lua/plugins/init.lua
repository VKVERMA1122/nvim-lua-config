return {
  {
    "folke/tokyonight.nvim",
    enabled = false, -- Disable TokyoNight
  },
  {
    "wtfox/jellybeans.nvim",
    lazy = false, -- Load the plugin eagerly
    priority = 1000,
    config = function()
      require("jellybeans").setup({
        italics = false,
        flat_ui = false,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jellybeans", -- Set your desired theme here
    },
  },
}
