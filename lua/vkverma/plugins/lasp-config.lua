return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
    handlers = {
      function(server_name)
        require("lspconfig")[server_name].setup {}
      end
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities
      })

      lspconfig.zls.setup({
        capabilities = capabilities
      })

      --lsp keymaps
      vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end,
        { desc = "Open floating diagnostic message" })
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
        { desc = "Go to previous diagnostic message" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
        { desc = "Go to next diagnostic message" })
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Lsp goto definition" })
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Lsp hover definition" })
      vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP Code action" })
      vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { desc = "LSP Code References " })
      vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "LSP Code Rename" })
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "LSP Signature Help" })
      vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "LSP Buffer Format" })
    end,
  },
}
