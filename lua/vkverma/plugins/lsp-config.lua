return {
  {
    "williamboman/mason.nvim",
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
    opts = {
      auto_install = true,
    },
    -- handlers = {
    --   function(server_name)
    --     local cmp = require("cmp_nvim_lsp")
    --     local capabilities =  vim.tbl_deep_extend(
    --       "force",
    --       cmp.default_capabilities(),
    --       require("lspconfig")[server_name].capabilities
    --     )
    --     require("lspconfig")[server_name].setup {
    --       on_attach = on_attach,
    --       capabilities = capabilities
    --     }
    --   end
    -- },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local keymap = vim.keymap -- for conciseness

      local opts = { noremap = true, silent = true }
      local on_attach = function(client, bufnr)
        opts.buffer = bufnr

        --lsp keymaps
        keymap.set("n", "gl", function() vim.diagnostic.open_float() end,
          { desc = "Open floating diagnostic message" })
        keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
          { desc = "Go to previous diagnostic message" })
        keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
          { desc = "Go to next diagnostic message" })
        keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Lsp goto definition" })
        keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Lsp hover definition" })
        keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP Code action" })
        keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { desc = "LSP Code References " })
        keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "LSP Code Rename" })
        keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "LSP Signature Help" })
        keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "LSP Buffer Format" })
      end

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- configure html server
      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure zig server
      lspconfig["zls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })


      -- configure tsserver server
      lspconfig["tsserver"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure rust_analyzer server
      lspconfig["rust_analyzer"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { -- custom settings for lua
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
    end,
  }
}
