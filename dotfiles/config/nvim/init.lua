-- ============================================================================
--  NVIM CONFIG — Orientado a réplica de Visual Studio Code
-- ============================================================================

-- 1. Bootstrapping de Lazy.nvim (instalación automática si no existe)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Asegurar que ~/.local/bin esté en el PATH (para tree-sitter, etc.)
vim.env.PATH = os.getenv('HOME') .. '/.local/bin:' .. vim.env.PATH

-- 2. Opciones globales (equivalente a 'set')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local o = vim.o
local opt = vim.opt

o.termguicolors = true            -- Colores 24-bit (necesario para temas modernos)
o.guifont = "AdwaitaMono Nerd Font:h16"

-- Interfaz
o.number = true
o.relativenumber = true
o.numberwidth = 5
o.signcolumn = 'yes:2'
o.cursorline = true
o.showmode = false                -- Lualine ya muestra el modo
o.scrolloff = 8
o.sidescrolloff = 8
o.mouse = 'a'
o.wrap = true
o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- Búsqueda
o.ignorecase = true
o.smartcase = true

-- Edición
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.cindent = true
o.textwidth = 300
o.undofile = true
o.swapfile = false
o.backup = false
o.writebackup = false
o.hidden = true                   -- Cambiar de buffer sin guardar (como VS Code)
o.clipboard = 'unnamedplus'
o.timeoutlen = 400
o.updatetime = 200
o.history = 50

-- Ventanas / splits
o.splitright = true
o.splitbelow = true
o.jumpoptions = 'view'
o.splitkeep = 'screen'
opt.diffopt:append('linematch:60')

-- Scroll suave y pum (menú de completado)
o.smoothscroll = true
o.pumheight = 10
o.completeopt = 'menu,menuone,noselect'

-- ============================================================================
--  3. Helpers compartidos (LSP)
-- ============================================================================
local function lsp_on_attach(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
end

-- ============================================================================
--  4. Plugins
-- ============================================================================
require("lazy").setup({
  ------------------------
  -- Tema
  ------------------------
  { 'mhartington/oceanic-next', priority = 1000 },

  ------------------------
  -- UI: statusline, pestañas, árbol de archivos
  ------------------------
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          globalstatus = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { { 'mode', fmt = function(m) return m:sub(1, 1) end } },
          lualine_b = { 'branch', 'diff' },
          lualine_c = { { 'filename', path = 1, file_status = true }, 'diagnostics' },
          lualine_x = { 'filetype', 'encoding', 'fileformat' },
          lualine_y = { 'progress' },
          lualine_z = { { 'location' } },
        },
        extensions = { 'quickfix', 'nvim-tree' },
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'buffers',
          show_close_icon = false,
          separator_style = 'slant',
          diagnostics = 'nvim_lsp',
          offsets = {
            { filetype = 'NvimTree', text = 'Explorador de Archivos', highlight = 'Directory', separator = true },
          },
        },
      })
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        diagnostics = { enable = true },
        update_focused_file = { enable = true },
        view = { width = 35, side = 'left' },
        filters = { custom = { '.git$', 'node_modules$', '^target$' } },
        git = { ignore = false },
        actions = { open_file = { window_picker = { enable = false } } },
        renderer = {
          icons = { show = { git = true, folder = true, file = true, folder_arrow = false } },
          indent_markers = { enable = true },
        },
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        indent = { char = '│' },
        scope = { enabled = true },
      })
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({})
      local wk = require('which-key')
      wk.add({
        { '<leader>f', group = 'Buscar' },
        { '<leader>g', group = 'Git' },
        { '<leader>t', group = 'Terminal' },
        { '<leader>x', group = 'Problemas (Trouble)' },
      })
    end,
  },

  ------------------------
  -- Sintaxis: Treesitter (semantic highlighting)
  ------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })
      require('nvim-treesitter').install({
        'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'tsx',
        'python', 'html', 'css', 'json', 'yaml', 'bash',
        'markdown', 'markdown_inline', 'dockerfile', 'toml',
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  ------------------------
  -- LSP + Mason (como las extensiones de VS Code)
  ------------------------
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({ ui = { border = 'single' } })
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    event = 'VeryLazy',
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'lua_ls', 'pyright', 'ts_ls', 'html', 'cssls', 'jsonls',
          'bashls', 'yamlls', 'marksman', 'dockerls',
          'prettierd', 'black', 'isort', 'stylua', 'shfmt',
        },
        auto_update = false,
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    event = 'VeryLazy',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls', 'pyright', 'ts_ls', 'html', 'cssls', 'jsonls',
          'bashls', 'yamlls', 'marksman', 'dockerls',
        },
        automatic_enable = true,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Configuración global para todos los servidores LSP
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = lsp_on_attach,
      })

      -- Ajustes específicos para lua_ls
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { 'vim' } },
          },
        },
      })
    end,
  },

  ------------------------
  -- Completado, snippets (IntelliSense)
  ------------------------
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'zbirenbaum/copilot-cmp',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'path' },
          { name = 'buffer' },
        }),
        formatting = {
          format = function(entry, vim_item)
            local kinds = {
              Copilot = '', Text = '', Method = '', Function = '', Constructor = '',
              Field = 'ﰠ', Variable = '', Class = 'ﴯ', Interface = '', Module = '',
              Property = 'ﰠ', Unit = '塞', Value = '', Enum = '', Keyword = '',
              Snippet = '', Color = '', File = '', Reference = '', Folder = '',
              EnumMember = '', Constant = '', Struct = 'פּ', Event = '', Operator = '',
              TypeParameter = '',
            }
            vim_item.kind = (kinds[vim_item.kind] or '') .. ' ' .. vim_item.kind
            local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
            vim_item.kind = (kinds[kind] or '') .. ' ' .. vim_item.kind
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              luasnip = '[Snip]',
              buffer = '[Buf]',
              path = '[Path]',
              copilot = '[Copilot]',
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- Integración con autopairs
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    build = (function()
      if vim.fn.has('win32') == 1 then return nil end
      return "make install_jsregexp"
    end)(),
  },

  ------------------------
  -- Formateo (como "Format on Save" de VS Code)
  ------------------------
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          javascript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          json = { 'prettierd' },
          jsonc = { 'prettierd' },
          html = { 'prettierd' },
          css = { 'prettierd' },
          scss = { 'prettierd' },
          less = { 'prettierd' },
          yaml = { 'prettierd' },
          markdown = { 'prettierd' },
          sh = { 'shfmt' },
          bash = { 'shfmt' },
        },
        format_on_save = { timeout_ms = 2000, lsp_format = 'fallback' },
      })
    end,
  },

  ------------------------
  -- Git (como Source Control de VS Code)
  ------------------------
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,          -- Git blame inline (como VS Code)
        current_line_blame_opts = { delay = 500, virt_text_pos = 'eol' },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map('n', ']h', function() gs.next_hunk() end)
          map('n', '[h', function() gs.prev_hunk() end)
          map('n', '<leader>gp', gs.preview_hunk)
          map('n', '<leader>gs', gs.stage_hunk)
          map('n', '<leader>gu', gs.undo_stage_hunk)
          map('n', '<leader>gr', gs.reset_hunk)
          map('n', '<leader>gd', gs.diffthis)
        end,
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  ------------------------
  -- Búsqueda (Ctrl+P, Ctrl+Shift+F, Command Palette)
  ------------------------
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local actions = require('telescope.actions')
      local lactions = require('telescope.actions.layout')

      require('telescope').setup({
        defaults = {
          prompt_prefix = ' ❯ ',
          initial_mode = 'insert',
          sorting_strategy = 'ascending',
          layout_config = { prompt_position = 'top' },
          mappings = {
            i = {
              ['<ESC>'] = actions.close,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<TAB>'] = actions.toggle_selection + actions.move_selection_next,
              ['<C-s>'] = actions.send_selected_to_qflist,
              ['<C-q>'] = actions.send_to_qflist,
              ['<C-h>'] = lactions.toggle_preview,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')
    end,
  },

  ------------------------
  -- Diagnósticos / Problems panel (Trouble)
  ------------------------
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    config = function()
      require('trouble').setup({
        focus = true,
        use_diagnostic_signs = true,
      })
    end,
  },
  {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    config = true,
  },

  ------------------------
  -- Terminal integrado (como Ctrl+` de VS Code)
  ------------------------
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        size = 15,
        direction = 'horizontal',
        shade_terminals = true,
        open_mapping = '<F7>',
      })
    end,
  },

  ------------------------
  -- Edición
  ------------------------
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        map_c_w = false,
      })
    end,
  },
  { 'tpope/vim-surround', event = 'BufReadPost' },
  { 'tpope/vim-repeat' },
  { 'wellle/targets.vim', event = 'BufReadPost' },
  { 'AndrewRadev/splitjoin.vim', event = 'VeryLazy' },
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = { 'smoka7/hydra.nvim' },
    config = function()
      require('multicursors').setup({})
    end,
  },
  {
    'sudo-tee/opencode.nvim',
    config = function()
      require('opencode').setup({})
    end,
    dependencies = {
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'markdown', 'opencode_output' },
        },
        ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
      },
    },
  },
  { 'mattn/emmet-vim' },
  { 'metakirby5/codi.vim', cmd = 'Codi' },
  { 'tpope/vim-sensible' },
  { 'smoka7/hop.nvim', event = 'BufReadPost', config = true },

  ------------------------
  -- Zen mode
  ------------------------
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    config = function()
      require('zen-mode').setup({
        window = {
          backdrop = 0.95,
          width = 110,
        },
      })
    end,
  },

  ------------------------
  -- Color swatches (como el color picker de VS Code)
  ------------------------
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufReadPost',
    config = function()
      require('colorizer').setup()
    end,
  },

  ------------------------
  -- Copilot (como GitHub Copilot en VS Code)
  ------------------------
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = '<M-l>',
            accept_word = '<M-w>',
            accept_line = '<M-e>',
          },
        },
        panel = { enabled = true },
        filetypes = { markdown = true, help = false },
      })
    end,
  },
  { 'zbirenbaum/copilot-cmp', config = true },

  ------------------------
  -- VimWiki
  ------------------------
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/Nextcloud/Notas/',
          syntax = 'markdown',
          ext = '.md',
        },
      }
    end,
    cmd = { 'VimwikiIndex', 'VimwikiDiaryIndex' },
    keys = { '<leader>ww', '<leader>wi' },
  },
}, {
  ui = { border = 'single' },
})

-- ============================================================================
--  5. Colores
-- ============================================================================
vim.cmd('colorscheme OceanicNext')

-- ============================================================================
--  6. Keymaps (atajos estilo VS Code)
-- ============================================================================
local key = vim.keymap.set

-- Explorador de archivos (VS Code: Ctrl+B)
key('n', '<F6>', ':NvimTreeToggle<CR>')
key('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Terminal integrado (VS Code: Ctrl+`)
key('n', '<leader>t', ':ToggleTerm<CR>')
key('t', '<leader>t', '<C-\\><C-n>:ToggleTerm<CR>')

-- Mover líneas arriba/abajo (VS Code: Alt+Up/Alt+Down)
key({ 'n', 'v' }, '<C-Up>', ':m -2<CR>')
key({ 'n', 'v' }, '<C-k>', ':m -2<CR>')
key({ 'n', 'v' }, '<C-Down>', ':m +1<CR>')
key({ 'n', 'v' }, '<C-j>', ':m +1<CR>')
key('i', '<C-j>', '<ESC>:m .+1<CR>==gi')
key('i', '<C-k>', '<ESC>:m .-2<CR>==gi')

-- Borrado sin tocar el registro (tu preferencia)
key('n', 'd', '"_d')
key('n', 'x', '"_x')

-- Comentarios con Comment.nvim (VS Code: Ctrl+/)
key('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)')
key('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)<CR>gv')

-- Guardar / salir (VS Code: Ctrl+S)
key('n', '<leader>w', '<CMD>update<CR>')
key('n', '<leader>W', '<CMD>wall<CR>')
key('n', '<C-S>', '<CMD>update<CR>')
key('i', '<C-S>', '<ESC><CMD>update<CR>')
key('n', '<C-Q>', '<CMD>q<CR>')

-- Insertar línea en blanco debajo/encima
key('n', '<leader>o', 'o<ESC>')
key('n', '<leader>O', 'O<ESC>')

-- Pegar desde el registro yank (VS Code-like)
key({ 'n', 'x' }, '<leader>p', '"0p')

-- Navegación de buffers (VS Code: Ctrl+Tab)
key('n', '<leader>[', '<CMD>bp<CR>')
key('n', '<leader>]', '<CMD>bn<CR>')
key('n', "''", '<CMD>b#<CR>')

-- Splits (VS Code: Ctrl+\)
key('n', '<C-\\>', '<CMD>vsplit<CR>')
key('n', '<A-\\>', '<CMD>split<CR>')

-- Mantener el cursor centrado al buscar
key('n', '*', '*N')
key('n', 'n', 'nzz')
key('n', 'N', 'Nzz')

-- Movimiento tipo shell en modo insert
key('i', '<C-E>', '<C-o>$')
key('i', '<C-A>', '<C-o>^')

-- Seleccionar todo el buffer (VS Code: Ctrl+A)
key('o', 'A', ':<C-U>normal! mzggVG<CR>`z')
key('x', 'A', ':<C-U>normal! ggVG<CR>')

-- Telescope (VS Code: Ctrl+P, Ctrl+Shift+F, Ctrl+Shift+P)
local Telescope = setmetatable({}, {
  __index = function(_, k)
    if vim.bo.filetype == 'NvimTree' then
      vim.cmd.wincmd('l')
    end
    return require('telescope.builtin')[k]
  end,
})

key('n', '<C-P>', function()
  local ok = pcall(Telescope.git_files, { show_untracked = true })
  if not ok then
    Telescope.find_files()
  end
end)
key('n', '<leader>ff', Telescope.find_files)
key('n', '<leader>fg', Telescope.live_grep)
key('n', '<leader>fb', Telescope.buffers)
key('n', '<leader>fh', Telescope.help_tags)
key('n', '<leader>fr', Telescope.oldfiles)
key('n', '<leader>fs', Telescope.git_status)
key('n', '<leader>H', Telescope.help_tags)
key('n', "'b", Telescope.buffers)
key('n', "'r", Telescope.live_grep)
key('n', "'c", Telescope.git_status)
key('n', '<leader>sp', function()
  Telescope.symbols({ sources = { 'emoji' } })
end)
key('n', '<C-S-P>', function()
  Telescope.commands()
end)

-- Trouble (VS Code: Problems panel)
key('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>')
key('n', '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>')
key('n', '<leader>xq', '<Cmd>Trouble quickfix toggle<CR>')
key('n', '<leader>xl', '<Cmd>Trouble loclist toggle<CR>')
key('n', 'gR', '<Cmd>Trouble lsp_references toggle<CR>')

-- Outline de símbolos (VS Code: Outline panel)
key('n', '<leader>o', ':SymbolsOutline<CR>')

-- Zen mode (VS Code: Zen)
key('n', '<leader>z', ':ZenMode<CR>')

-- Hop (salto rápido)
key('n', '<leader>j', ':HopChar1<CR>')
key('n', '<leader>J', ':HopWord<CR>')

-- Diffview (VS Code: Git diff)
key('n', '<leader>gg', ':DiffviewOpen<CR>')
key('n', '<leader>gh', ':DiffviewFileHistory<CR>')

-- ============================================================================
--  7. Autocmds
-- ============================================================================
local A = vim.api
local num_au = A.nvim_create_augroup('NUMTOSTR', { clear = true })

-- Tipos de archivo personalizados
vim.filetype.add({
  extension = {
    conf = 'conf',
    mdx = 'markdown',
    mjml = 'html',
    kicad_mod = 'scheme',
  },
  pattern = {
    ['.*%.env.*'] = 'sh',
    ['ignore$'] = 'conf',
  },
  filename = {
    ['yup.lock'] = 'yaml',
  },
})

-- Resaltar la región al yankear
A.nvim_create_autocmd('TextYankPost', {
  group = num_au,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 150 })
  end,
})

-- Terminal: sin números de línea y entra en INSERT
A.nvim_create_autocmd('TermOpen', {
  group = num_au,
  callback = function(data)
    if not string.find(vim.bo[data.buf].filetype, '^[fF][tT]erm') then
      A.nvim_set_option_value('number', false, { scope = 'local' })
      A.nvim_set_option_value('relativenumber', false, { scope = 'local' })
      A.nvim_set_option_value('signcolumn', 'no', { scope = 'local' })
      vim.cmd('startinsert')
    end
  end,
})

-- Volver a la última posición al abrir un archivo
A.nvim_create_autocmd('BufReadPost', {
  group = num_au,
  callback = function(data)
    local last_pos = A.nvim_buf_get_mark(data.buf, '"')
    if last_pos[1] > 0 and last_pos[1] <= A.nvim_buf_line_count(data.buf) then
      A.nvim_win_set_cursor(0, last_pos)
    end
  end,
})

-- Emmet: activar en filetypes comunes (VS Code incluye Emmet)
vim.g.user_emmet_leader_key = '<C-e>'
vim.g.user_emmet_install_global = 0
local emmet_au = A.nvim_create_augroup('EMMET', { clear = true })
for _, ft in ipairs({ 'html', 'css', 'scss', 'less', 'sass', 'jsx', 'tsx', 'xml', 'htmldjango' }) do
  A.nvim_create_autocmd('FileType', {
    group = emmet_au,
    pattern = ft,
    command = 'EmmetInstall',
  })
end

-- Activar spell en Markdown y texto
A.nvim_create_autocmd('FileType', {
  group = num_au,
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.api.nvim_set_option_value('spell', true, { scope = 'local' })
  end,
})

-- Treesitter: highlighting semántico (lo activa Neovim si hay parser)
A.nvim_create_autocmd('FileType', {
  group = num_au,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
