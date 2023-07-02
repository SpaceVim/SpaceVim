local cmp = require('cmp')
-- @fixme the tagbsearch opt need to be disabled
-- E432
--
vim.o.tagbsearch = false

local copt = vim.fn['SpaceVim#layers#autocomplete#get_variable']()

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function expand_snippet(fallback) -- {{{
  if vim.g.spacevim_snippet_engine == 'neosnippet' then
    if vim.fn['neosnippet#expandable']() == 1 then
      feedkey('<plug>(neosnippet_expand)', '')
    end
  elseif vim.g.spacevim_snippet_engine == 'ultisnips' then
  end
end
-- }}}

local function smart_tab(fallback) -- {{{
  if copt.auto_completion_tab_key_behavior == 'smart' then
    if vim.fn['neosnippet#expandable_or_jumpable']() == 1 then
      feedkey('<plug>(neosnippet_expand_or_jump)', '')
    elseif cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  elseif copt.auto_completion_tab_key_behavior == 'complete' then
    cmp.select_next_item()
  end
end

--1. `auto_completion_return_key_behavior` set the action to perform
--   when the `Return`/`Enter` key is pressed. the possible values are:
--   - `complete` completes with the current selection
--   - `smart` completes with current selection and expand snippet or argvs
--   - `nil`
--   By default it is `complete`.

local function enter(f) -- {{{
  if copt.auto_completion_return_key_behavior == 'complete' then
    cmp.mapping.confirm({ select = false })
  elseif copt.auto_completion_return_key_behavior == 'smart' then
    expand_snippet(nil)
    if cmp.visible() then
      cmp.mapping.confirm({ select = false })
      return cmp.close()
    else
      pcall(f)
    end
  end
end
-- }}}

local function ctrl_p(f) -- {{{
  if cmp.visible() then
    cmp.select_prev_item()
  else
    pcall(f)
  end
end
-- }}}

local function ctrl_n(f) -- {{{
  if cmp.visible() then
    cmp.select_next_item()
  else
    pcall(f)
  end
end
-- }}}

-- }}}

--2. `auto_completion_tab_key_behavior` set the action to
--   perform when the `TAB` key is pressed, the possible values are:
--   - `smart` cycle candidates, expand snippets, jump parameters
--   - `complete` completes with the current selection
--   - `cycle` completes the common prefix and cycle between candidates
--   - `nil` insert a carriage return
--   By default it is `complete`.

cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = smart_tab,
    ['<M-/>'] = expand_snippet,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ['<C-n>'] = ctrl_n,
    ['<C-p>'] = ctrl_p,
    ['<CR>'] = enter,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    {
      name = 'dictionary',
      keyword_length = 2,
    },
    { name = 'path' },
    { name = 'neosnippet' },
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      }
    },
  }),
})
-- `/` cmdline setup.
-- cmp.setup.cmdline('/', {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = {
-- { name = 'buffer' },
-- },
-- })
-- `/` cmdline setup.
-- cmp.setup.cmdline(':', {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = {
-- { name = 'buffer' },
-- { name = 'path' },
-- },
-- })
-- Setup lspconfig.
local capabilities =
  require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- for cmp dictionary
local dict = require("cmp_dictionary")

dict.setup({
  -- The following are default values.
  exact = 2,
  first_case_insensitive = false,
  document = false,
  -- document_command = "wn %s -over",
  async = true,
  sqlite = false,
  max_items = -1,
  capacity = 5,
  debug = false,
})


-- dict.switcher({
  -- filetype = {
    -- lua = "/path/to/lua.dict",
    -- javascript = { "/path/to/js.dict", "/path/to/js2.dict" },
  -- },
  -- filepath = {
    -- [".*xmake.lua"] = { "/path/to/xmake.dict", "/path/to/lua.dict" },
    -- ["%.tmux.*%.conf"] = { "/path/to/js.dict", "/path/to/js2.dict" },
  -- },
  -- spelllang = {
    -- en = "/path/to/english.dict",
  -- },
-- })
