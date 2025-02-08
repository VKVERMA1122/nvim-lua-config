return {
  {
    "folke/tokyonight.nvim",
    enabled = false, -- Disable TokyoNight
  },
  -- {
  --   "wtfox/jellybeans.nvim",
  --   lazy = false, -- Load the plugin eagerly
  --   priority = 1000,
  --   config = function()
  --     require("jellybeans").setup({
  --       italics = false,
  --       flat_ui = false,
  --     })
  --   end,
  -- },
  -- {
  --   "timmypidashev/darkbox.nvim",
  --   lazy = false,
  --   config = function()
  --     require("darkbox").setup({
  --       italic = {
  --         strings = false,
  --         emphasis = false,
  --         comments = false,
  --         operators = false,
  --         folds = false,
  --       },
  --       transparent_mode = false,
  --     })
  --     vim.cmd("colorscheme darkbox")
  --   end,
  -- },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({})

      vim.cmd("colorscheme github_dark_default")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
    },
  },
}
