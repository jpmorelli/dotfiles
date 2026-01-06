-- 1. Bootstrapping (Instalación automática de Lazy)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Configuración de plugins
require("lazy").setup({
    ---------------------
    -- Required plugins --
    ---------------------
    { 'nvim-lua/plenary.nvim' },

    ----------------------------------------
    -- Theme, Icons, Statusbar, Bufferbar --
    ----------------------------------------
    {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup()
        end,
    },

    {
        'numToStr/Sakura.nvim',
        config = function()
            require('numToStr.plugins.sakura')
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'numToStr/Sakura.nvim' },
        event = 'BufEnter',
        config = function()
            require('numToStr.plugins.lualine')
        end,
    },

    -----------------------------------
    -- Treesitter: Better Highlights --
    -----------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-refactor',
            'windwp/nvim-ts-autotag',
        },
        config = function()
            require('numToStr.plugins.treesitter')
        end,
    },

    --------------------------
    -- Editor UI Niceties --
    --------------------------
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.indentline')
        end,
    },

    {
        'norcalli/nvim-colorizer.lua',
        event = 'VeryLazy',
        config = function()
            require('colorizer').setup()
        end,
    },

    ---------------
    -- Git Stuff --
    ---------------
    {
        'lewis6991/gitsigns.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.gitsigns')
        end,
    },

    { 'rhysd/git-messenger.vim', event = 'BufReadPost' }, -- Config se suele cargar solo en .vim

    {
        'sindrets/diffview.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.diffview')
        end,
    },

    ---------------------------------
    -- Navigation and Fuzzy Search --
    ---------------------------------
    {
        'nvim-tree/nvim-tree.lua',
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require('numToStr.plugins.nvim-tree')
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-symbols.nvim' },
        },
        config = function()
            require('numToStr.plugins.telescope')
            require('telescope').load_extension('fzf')
        end,
    },

    {
        'numToStr/Navigator.nvim',
        event = 'VeryLazy',
        config = function()
            require('numToStr.plugins.navigator')
        end,
    },

    {
        'smoka7/hop.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.hop')
        end,
    },

    {
        'karb94/neoscroll.nvim',
        event = 'WinScrolled',
        config = function()
            require('neoscroll').setup({ hide_cursor = false })
        end,
    },

    -------------------------
    -- Editing --
    -------------------------
    {
        'numToStr/Comment.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.comment')
        end,
    },

    { 'numToStr/prettierrc.nvim' },

    {
        'tpope/vim-surround',
        dependencies = { 'tpope/vim-repeat' },
        event = 'BufReadPost',
    },

    { 'wellle/targets.vim', event = 'BufReadPost' },

    { 'AndrewRadev/splitjoin.vim', event = 'VeryLazy' },

    {
        'numToStr/Buffers.nvim',
        event = 'BufReadPost',
        config = function()
            require('numToStr.plugins.buffers')
        end,
    },

    {
        'numToStr/FTerm.nvim',
        cmd = { 'FTermToggle', 'FTermOpen' },
        config = function()
            require('numToStr.plugins.fterm')
        end,
    },

    -----------------------------------
    -- LSP, Completions and Snippets --
    -----------------------------------
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'hrsh7th/cmp-nvim-lsp' },
        config = function()
            require('numToStr.plugins.lsp.servers')
        end,
    },

    {
        'jose-elias-alvarez/null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('numToStr.plugins.lsp.null-ls')
        end,
    },

    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('numToStr.plugins.lsp.nvim-cmp')
            require('numToStr.plugins.lsp.luasnip')
        end,
    },

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('numToStr.plugins.pairs')
        end,
    },

    {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup()
        end,
    },
}, {
    -- Configuración de la UI de Lazy (reemplaza al display de Packer)
    ui = {
        border = "single",
    },
})
