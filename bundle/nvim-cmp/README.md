# nvim-cmp

A completion engine plugin for neovim written in Lua.
Completion sources are installed from external repositories and "sourced".

<video src="https://user-images.githubusercontent.com/629908/139000570-3ac39587-a88b-43c6-b35e-207489719359.mp4" width="100%"></video>

Readme!
====================

1. nvim-cmp's breaking changes are documented [here](https://github.com/hrsh7th/nvim-cmp/issues/231).
2. This is my hobby project. You can support me via GitHub sponsors.
3. Bug reports are welcome, but I might not fix if you don't provide a minimal reproduction configuration and steps.
4. The nvim-cmp documents is [here](./doc/cmp.txt).



Concept
====================

- Full support for LSP completion related capabilities
- Powerful customizability via Lua functions
- Smart handling of key mapping
- No flicker



Setup
====================

### Recommended Configuration

This example configuration uses `vim-plug` as the plugin manager and `vim-vsnip` as snippet plugin.

```lua
call plug#begin(s:plug_dir)
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" For luasnip users.
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'

" For ultisnips users.
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" For snippy users.
" Plug 'dcampos/nvim-snippy'
" Plug 'dcampos/cmp-snippy'

call plug#end()

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
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
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
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

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    capabilities = capabilities
  }
EOF
```

### Where can I find more completion sources?

A list of available sources can be found in the [Wiki](https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources) or by searching for projects that match the nvim-cmp [GitHub topic](https://github.com/topics/nvim-cmp).

### Where can I find advanced configuration examples?

Please see the corresponding [FAQ](#how-to-show-name-of-item-kind-and-source-like-compe) section or [Wiki pages](https://github.com/hrsh7th/nvim-cmp/wiki).


Advanced configuration example
====================

### Use nvim-cmp as smart omnifunc handler.

nvim-cmp can be used as flexible omnifunc manager.

```lua
local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false, -- disable auto-completion.
  },
}

_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.lsp = function()
  cmp.complete({
    config = {
      sources = {
        { name = 'nvim_lsp' }
      }
    }
  })
end
_G.vimrc.cmp.snippet = function()
  cmp.complete({
    config = {
      sources = {
        { name = 'vsnip' }
      }
    }
  })
end

vim.cmd([[
  inoremap <C-x><C-o> <Cmd>lua vimrc.cmp.lsp()<CR>
  inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
]])
```

### Full managed completion behavior.

```lua
local cmp = require('cmp')

cmp.setup {
  completion = {
    autocomplete = false, -- disable auto-completion.
  }
}

_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.on_text_changed = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local before = string.sub(line, 1, cursor[2] + 1)
  if before:match('%s*$') then
    cmp.complete() -- Trigger completion only if the cursor is placed at the end of line.
  end
end
vim.cmd([[
  augroup vimrc
    autocmd
    autocmd TextChanged,TextChangedI,TextChangedP * call luaeval('vimrc.cmp.on_text_changed()')
  augroup END
]])
```



