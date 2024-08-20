
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.relativenumber = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'neovim/nvim-lspconfig',
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.5',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            'folke/trouble.nvim',
            dependencies = {'nvim-tree/nvim-web-devicons'},
        },
        {
            'Julian/lean.nvim',
            event = {'BufReadPre *.lean', 'BufNewFile *.lean'},
            dependencies = {
                'neovim/nvim-lspconfig',
                'nvim-lua/plenary.nvim',
            },
            opt = {
                lsp = {},
                mappings = true,
            }
        },
	{'catppuccin/nvim', name= 'catppuccin'},
    }
)

-- colorscheme
vim.cmd.colorscheme 'catppuccin'
vim.api.nvim_set_hl(0,'LineNrAbove', {fg = '#b0b000'})
vim.api.nvim_set_hl(0,'LineNr', {fg = '#ffff00'})
vim.api.nvim_set_hl(0,'LineNrBelow', {fg = '#b0b000'})

local cmp = require'cmp'

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.clangd.setup {
    capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
    capabilities = capabilities
}

--lspconfig.pyright.setup {
--    capabilities = capabilities
--}

lspconfig.pylsp.setup {
    capabilities = capabilities
}

lspconfig.als.setup{
    capabilities = capabilities
}

lspconfig.leanls.setup{
    capabilities = capabilities
}

lspconfig.hls.setup{
    capabilities = capabilities,
    filetypes = {'haskell', 'lhaskell', 'cabal'},
}

lspconfig.futhark_lsp.setup{
    --capabilities = capabilities
}

-- telescope
local tel_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tel_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', tel_builtin.live_grep, {})

-- lsp keys

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>ws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- other mappings
vim.keymap.set('n', '<space>gf', vim.diagnostic.open_float, {})


