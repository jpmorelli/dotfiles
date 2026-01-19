-- 1. Bootstrapping de Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Helpers para VS Code
local g = vim.g
local o = vim.o
local map = vim.keymap.set

-- Función para llamar a comandos de VS Code
local function action(cmd)
    return function()
        return vim.fn.VSCodeNotify(cmd)
    end
end

-- 3. Settings (Opciones)
g.mapleader = ' '
g.maplocalleader = ' '
o.clipboard = 'unnamedplus'
o.timeoutlen = 500
o.updatetime = 200
o.undofile = true
-- No necesarios en VS Code pero buenos por seguridad:
o.backup = false
o.writebackup = false
o.swapfile = false

-- 4. Keybindings de Navegación y Edición
map('n', '0', '^')
map('n', '<leader>o', 'o<ESC>')
map('n', '<leader>O', 'O<ESC>')

-- Mover líneas (Lógica nativa de Neovim)
map('n', '<C-j>', '<CMD>move .+1<CR>')
map('n', '<C-k>', '<CMD>move .-2<CR>')
map('x', '<C-j>', ":move '>+1<CR>gv=gv")
map('x', '<C-k>', ":move '<-2<CR>gv=gv")

-- Acciones enviadas a VS Code
map({ 'n', 'x' }, '<leader>w', action('workbench.action.files.save'))
map({ 'n', 'x' }, '<leader>W', action('workbench.action.files.saveAll'))
map('n', '<leader>q', action('workbench.action.closeActiveEditor'))
map('n', '<leader>[', action('workbench.action.previousEditor'))
map('n', '<leader>]', action('workbench.action.nextEditor'))

-- Comentarios (Usando el motor de VS Code)
map('n', 'gcc', '<Plug>VSCodeCommentaryLine')
map({ 'n', 'x', 'o' }, 'gc', '<Plug>VSCodeCommentary')

-- Folds (Pliegues)
map('n', 'za', action('editor.toggleFold'))

-- Navegación de ventanas (Grupos de VS Code)
map({ 'n', 'x' }, '<A-h>', action('workbench.action.focusLeftGroup'))
map({ 'n', 'x' }, '<A-j>', action('workbench.action.focusBelowGroup'))
map({ 'n', 'x' }, '<A-k>', action('workbench.action.focusAboveGroup'))
map({ 'n', 'x' }, '<A-l>', action('workbench.action.focusRightGroup'))

-- 5. Autocomandos
local num_au = vim.api.nvim_create_augroup('NUMTOSTR', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = num_au,
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
})

-- 6. Plugins con Lazy.nvim
require("lazy").setup({
    {
        'phaazon/hop.nvim',
        event = 'VeryLazy',
        config = function()
            require('hop').setup()
            map('n', '<S-j>', '<CMD>HopWordAC<CR>')
            map('n', '<S-k>', '<CMD>HopWordBC<CR>')
        end,
    },
    
    -- Si quieres re-activar surround en el futuro:
    -- {
    --     'tpope/vim-surround',
    --     dependencies = { 'tpope/vim-repeat' },
    --     event = 'BufReadPre',
    -- },
}, {
    -- Configuración de UI para la ventana de Lazy
    ui = { border = "single" }
})
