return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local conform = require("conform")

    -- Single source of truth for format options. `format_on_save` uses a
    -- shorter timeout so saves stay snappy; manual format falls back to the
    -- defaults below (more forgiving for large files).
    conform.setup({
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
        stop_after_first = true,
      },
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        lua = { "stylua" },
        go = { "gofmt" },
      },
      format_on_save = { lsp_format = "fallback", timeout_ms = 1000 },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    })

    -- Manual format: rely on default_format_opts (timeout_ms = 3000).
    -- Grouped under <leader>l (LSP/format) to match the rest of the config.
    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format({ lsp_format = "fallback" })
    end, { desc = "Format file or range (in visual mode)" })

    vim.api.nvim_create_user_command("Format", function(args)
      local opts = { lsp_format = "fallback" }
      if args.range then
        opts.range = args.range
      end
      conform.format(opts)
    end, {
      desc = "Format file or range (in visual mode)",
      range = true, -- Allows command to work in visual mode
    })
  end,
}
