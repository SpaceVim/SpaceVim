local cmp = require('cmp')

local copt = vim.fn['SpaceVim#layers#autocomplete#get_variable']()

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function smart_tab(fallback) -- {{{
  
end

local function expand_snippet(fallback) -- {{{
  if vim.g.spacevim_snippet_engine == 'neosnippet' then
      if vim.fn['neosnippet#expandable']() == 1
        then
        feedkey('<plug>(neosnippet_expand)', '')
      end
  elseif vim.g.spacevim_snippet_engine == 'ultisnips' then
  end
  
end
-- }}}


-- }}}

-- 1. `auto_completion_return_key_behavior` set the action to perform
   -- when the `Return`/`Enter` key is pressed. the possible values are:
   -- - `complete` completes with the current selection
   -- - `smart` completes with current selection and expand snippet or argvs
   -- - `nil`
   -- By default it is `complete`.

cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = function(fallback)
      if copt.auto_completion_return_key_behavior == 'smart' 
        and vim.fn['neosnippet#expandable_or_jumpable']() == 1
        then
        feedkey('<plug>(neosnippet_expand_or_jump)', '')
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<M-/>'] = expand_snippet,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'neosnippet' },
  }, {
    { name = 'buffer' },
  }),
})

-- Setup lspconfig.
local capabilities =
  require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
