vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
    -- essential plugins
    use("tpope/vim-surround") -- add, delete, change surroundings (it"s awesome)
    -- commenting with gc
    use("numToStr/Comment.nvim")
    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
    use("VonHeikemen/lsp-zero.nvim")
    -- LSP Support
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    -- Autocompletion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    -- Snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")
    use("ellisonleao/gruvbox.nvim")
    use("navarasu/onedark.nvim")
    -- treesitter configuration
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    })
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    })
    use("nvim-tree/nvim-web-devicons")
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    })
    --    use ("akinsho/toggleterm.nvim")
    use({
        "goolord/alpha-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("vkverma.plugins.alpha")
        end,
    })
    use("lukas-reineke/indent-blankline.nvim")
    if packer_bootstrap then
        require("packer").sync()
    end

    local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
        group = packer_group,
        pattern = vim.fn.expand "$MYVIMRC",
    })
end)
