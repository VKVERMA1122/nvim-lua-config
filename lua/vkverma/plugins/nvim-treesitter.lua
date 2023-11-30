return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", commit = "6c30f3c8915d7b31c3decdfe6c7672432da1809d" },
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- HACK: remove when https://github.com/windwp/nvim-ts-autotag/issues/125 closed.
      { "windwp/nvim-ts-autotag",                      opts = { enable_close_on_slash = false } },
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    build = ":TSUpdate",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    opts = function()
      return {
        autotag = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        -- HACK: force install of shipped neovim parsers since TSUpdate doesn't correctly update them
        ensure_installed = {
          "c",
          "lua",
        },
        highlight = {
          enable = true,
          disable = function(_, bufnr) return vim.b[bufnr].large_buf end,
        },
        incremental_selection = { enable = true },
        indent = { enable = true },
      }
    end,
  }
}
