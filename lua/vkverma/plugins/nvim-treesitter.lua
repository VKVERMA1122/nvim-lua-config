return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      opts = { enable_close_on_slash = false },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    build = ":TSUpdate",
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")
      local ts_context_commentstring = require("ts_context_commentstring")
      ts_context_commentstring.setup {}
      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = {
          enable = true,
        },
        -- ensure these language parsers are installed
        ensure_installed = {},
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      })
    end,
    -- cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    -- build = ":TSUpdate",
    -- init = function(plugin)
    --   -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    --   -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    --   -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    --   -- Luckily, the only thins that those plugins need are the custom queries, which we make available
    --   -- during startup.
    --   -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
    --   require("lazy.core.loader").add_to_rtp(plugin)
    --   require "nvim-treesitter.query_predicates"
    -- end,
    -- opts = function()
    --   return {
    --         autotag = { enable = true },
    --         context_commentstring = { enable = true, enable_autocmd = false },
    --         -- HACK: force install of shipped neovim parsers since TSUpdate doesn't correctly update them
    --         ensure_installed = {},
    --         highlight = {
    --           enable = true,
    --           disable = function(_, bufnr) return vim.b[bufnr].large_buf end,
    --         },
    --         incremental_selection = {
    --           enable = true,
    --           keymaps = {
    --             init_selection = "<C-space>",
    --             node_incremental = "<C-space>",
    --             scope_incremental = false,
    --             node_decremental = "<bs>",
    --           },
    --         },
    --         indent = { enable = true },
    --
    --       },
    --       {
    --         "windwp/nvim-ts-autotag",
    --         event = "LazyFile",
    --         opts = {},
    --       }
    -- end,
  },
}
