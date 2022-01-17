# nvim-cmp

A completion engine plugin for neovim written in Lua.
Completion sources are installed from external repositories and "sourced".

<video src="https://user-images.githubusercontent.com/629908/139000570-3ac39587-a88b-43c6-b35e-207489719359.mp4" width="100%"></video>

Readme!
====================

1. nvim-cmp's breaking changes are documented [here](https://github.com/hrsh7th/nvim-cmp/issues/231).
2. This is my hobby project. You can support me via GitHub sponsors.
3. Bug reports are welcome, but I might not fix if you don't provide a minimal reproduction configuration and steps.


Concept
====================

- No flicker
- Works properly
- Fully customizable via Lua functions
- Fully supports LSP's completion capabilities
  - Snippets
  - CommitCharacters
  - TriggerCharacters
  - TextEdit and InsertReplaceTextEdit
  - AdditionalTextEdits
  - Markdown documentation
  - Execute commands (Some LSP server needs it to auto-importing. e.g. `sumneko_lua` or `purescript-language-server`)
  - Preselect
  - CompletionItemTags
- Support pairs-wise plugin automatically


Setup
====================

### Recommended Configuration

This example configuration uses `vim-plug` as the plugin manager.

```viml
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
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
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

You can search for various completion sources [here](https://github.com/topics/nvim-cmp).


Configuration options
====================

You can specify the following configuration options via `cmp.setup { ... }`.

The configuration options will be merged with the [default config](./lua/cmp/config/default.lua).

If you want to remove a default option, set it to `false`.


#### mapping (type: table<string, fun(fallback: function)>)

Defines the action of each key mapping. The following lists all the built-in actions:

- `cmp.mapping.select_prev_item({ cmp.SelectBehavior.{Insert,Select} })`
- `cmp.mapping.select_next_item({ cmp.SelectBehavior.{Insert,Select} })`
- `cmp.mapping.scroll_docs(number)`
- `cmp.mapping.complete()`
- `cmp.mapping.close()`
- `cmp.mapping.abort()`
- `cmp.mapping.confirm({ select = bool, behavior = cmp.ConfirmBehavior.{Insert,Replace} })`: If `select` is true and you haven't select any item, automatically selects the first item.

You can configure `nvim-cmp` to use these `cmp.mapping` like this:

```lua
mapping = {
  ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.close(),
  ['<CR>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  })
}
```

In addition, the mapping mode can be specified with the help of `cmp.mapping(...)`. The default is the insert mode (i) if not specified.

```lua
mapping = {
  ...
  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
  ...
}
```

The mapping mode can also be specified using a table. This is particularly useful to set different actions for each mode.

```lua
mapping = {
  ['<CR>'] = cmp.mapping({
    i = cmp.mapping.confirm({ select = true }),
    c = cmp.mapping.confirm({ select = false }),
  })
}
```

You can also provide a custom function as the action.

```lua
mapping = {
  ['<Tab>'] = function(fallback)
    if ...some_condition... then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('...', true, true, true), 'n', true)
    else
      fallback() -- The fallback function is treated as original mapped key. In this case, it might be `<Tab>`.
    end
  end,
}
```

#### enabled (type: fun(): boolean|boolean)

A boolean value, or a function returning a boolean, that specifies whether to enable nvim-cmp's features or not.

Default:

```lua
function()
  return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
end
```

#### sources (type: table<cmp.SourceConfig>)

Lists all the global completion sources that will be enabled in all buffers.
The order of the list defines the priority of each source. See the
*sorting.priority_weight* option below.

It is possible to set up different sources for different filetypes using
`FileType` autocommand and `cmp.setup.buffer` to override the global
configuration.

```viml
" Setup buffer configuration (nvim-lua source only enables in Lua filetype).
autocmd FileType lua lua require'cmp'.setup.buffer {
\   sources = {
\     { name = 'nvim_lua' },
\     { name = 'buffer' },
\   },
\ }
```

Note that the source name isn't necessarily the source repository name.  Source
names are defined in the source repository README files. For example, look at
the [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) source README
which defines the source name as `buffer`.

#### sources[number].name (type: string)

The source name.

#### sources[number].opts (type: table)

The source customization options. It is defined by each source.

#### sources[number].priority (type: number|nil)

The priority of the source.  If you don't specify it, the source priority will
be determined by the default algorithm (see `sorting.priority_weight`).

#### sources[number].keyword_pattern (type: string)

The source specific keyword_pattern for override.

#### sources[number].keyword_length (type: number)

The source specific keyword_length for override.

#### sources[number].max_item_count (type: number)

The source specific maximum item count.

#### sources[number].group_index (type: number)

The source group index.

You can call built-in utility like `cmp.config.sources({ { name = 'a' } }, { { name = 'b' } })`.

#### preselect (type: cmp.PreselectMode)

Specify preselect mode. The following modes are available.

- `cmp.PreselectMode.Item`
  - If the item has `preselect = true`, `nvim-cmp` will preselect it.
- `cmp.PreselectMode.None`
  - Disable preselect feature.

Default: `cmp.PreselectMode.Item`

#### completion.autocomplete (type: cmp.TriggerEvent[])

Which events should trigger `autocompletion`.

If you set this to `false`, `nvim-cmp` will not perform completion
automatically. You can still use manual completion though (like omni-completion
via the `cmp.mapping.complete` function).

Default: `{ types.cmp.TriggerEvent.TextChanged }`

#### completion.keyword_pattern (type: string)

The default keyword pattern.  This value will be used if a source does not set
a source specific pattern.

Default: `[[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]]`

#### completion.keyword_length (type: number)

The minimum length of a word to complete on; e.g., do not try to complete when the
length of the word to the left of the cursor is less than `keyword_length`.

Default: `1`

#### completion.get_trigger_characters (type: fun(trigger_characters: string[]): string[])

The function to resolve trigger_characters.

Default: `function(trigger_characters) return trigger_characters end`

#### completion.completeopt (type: string)

vim's `completeopt` setting. Warning: Be careful when changing this value.

Default: `menu,menuone,noselect`

#### confirmation.default_behavior (type: cmp.ConfirmBehavior)

A default `cmp.ConfirmBehavior` value when to use confirmed by commitCharacters

Default: `cmp.ConfirmBehavior.Insert`

#### confirmation.get_commit_characters (type: fun(commit_characters: string[]): string[])

The function to resolve commit_characters.

#### sorting.priority_weight (type: number)

The score multiplier of source when calculating the items' priorities.
Specifically, each item's original priority (given by its corresponding source)
will be increased by `#sources - (source_index - 1)` multiplied by
`priority_weight`. That is, the final priority is calculated by the following formula:

`final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)`

Default: `2`

#### sorting.comparators (type: function[])

When sorting completion items, the sort logic tries each function in
`sorting.comparators` consecutively when comparing two items. The first function
to return something other than `nil` takes precedence.

Each function must return `boolean|nil`.

You can use the preset functions from `cmp.config.compare.*`.

Default:
```lua
{
  cmp.config.compare.offset,
  cmp.config.compare.exact,
  cmp.config.compare.score,
  cmp.config.compare.recently_used,
  cmp.config.compare.kind,
  cmp.config.compare.sort_text,
  cmp.config.compare.length,
  cmp.config.compare.order,
}
```

#### documentation (type: false | cmp.DocumentationConfig)

If set to `false`, the documentation of each item will not be shown.
Else, a table representing documentation configuration should be provided.
The following are the possible options:

#### documentation.border (type: string[])

Border characters used for documentation window.

#### documentation.winhighlight (type: string)

A neovim's `winhighlight` option for documentation window.

#### documentation.maxwidth (type: number)

The documentation window's max width.

#### documentation.maxheight (type: number)

The documentation window's max height.

#### documentation.zindex (type: number)

The documentation window's zindex.

#### formatting.fields (type: cmp.ItemField[])

The order of item's fields for completion menu.

#### formatting.format (type: fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem)

A function to customize completion menu.
The return value is defined by vim. See `:help complete-items`.

You can display the fancy icons to completion-menu with [lspkind-nvim](https://github.com/onsails/lspkind-nvim).

Please see [FAQ](#how-to-show-name-of-item-kind-and-source-like-compe) if you would like to show symbol-text (e.g. function) and source (e.g. LSP) like compe.

```lua
local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format(),
  },
}
```

See the [wiki](https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations) for more info on customizing menu appearance.

#### experimental.native_menu (type: boolean)

Use vim's native completion menu instead of custom floating menu.

Default: `false`

#### experimental.ghost_text (type: cmp.GhostTextConfig | false)

Specify whether to display ghost text.

Default: `false`

Commands
====================

#### `CmpStatus`

Show the source statuses

Autocmds
====================

#### `cmp#ready`

Invoke after nvim-cmp setup.

Highlights
====================

#### `CmpItemAbbr`

The abbr field.

#### `CmpItemAbbrDeprecated`

The deprecated item's abbr field.

#### `CmpItemAbbrMatch`

The matched characters highlight.

#### `CmpItemAbbrMatchFuzzy`

The fuzzy matched characters highlight.

#### `CmpItemKind`

The kind field.

#### `CmpItemMenu`

The menu field.

Programatic API
====================

You can use the following APIs.

#### `cmp.event:on(name: string, callback: string)`

Subscribes to the following events.

- `confirm_done`

#### `cmp.get_config()`

Returns the current configuration.

#### `cmp.visible()`

Returns the completion menu is visible or not.

NOTE: This method returns true if the native popup menu is visible, for the convenience of defining mappings.

#### `cmp.get_selected_entry()`

Returns the selected entry.

#### `cmp.get_active_entry()`

Returns the active entry.

NOTE: The `preselected` entry does not returned from this method.

#### `cmp.confirm({ select = boolean, behavior = cmp.ConfirmBehavior.{Insert,Replace} }, callback)`

Confirms the current selected item, if possible. If `select` is true and no item has been selected, selects the first item.

#### `cmp.complete()`

Invokes manual completion.

#### `cmp.close()`

Closes the current completion menu.

#### `cmp.abort()`

Closes the current completion menu and restore the current line (similar to native `<C-e>` behavior).

#### `cmp.select_next_item({ cmp.SelectBehavior.{Insert,Select} })`

Selects the next completion item if possible.

#### `cmp.select_prev_item({ cmp.SelectBehavior.{Insert,Select} })`

Selects the previous completion item if possible.

#### `cmp.scroll_docs(delta)`

Scrolls the documentation window by `delta` lines, if possible.


FAQ
====================

#### I can't get the specific source working.

Check the output of command `:CmpStatus`. It is likely that you specify the source name incorrectly.

NOTE: `nvim_lsp` will be sourced on `InsertEnter` event. It will show as `unknown source`, but this isn't a problem.


#### What is the `pair-wise plugin automatically supported`?

Some pair-wise plugin set up the mapping automatically.
For example, `vim-endwise` will map `<CR>` even if you don't do any mapping instructions for the plugin.

But I think the user want to override `<CR>` mapping only when the mapping item is selected.

The `nvim-cmp` does it automatically.

The following configuration will be working as

1. If the completion-item is selected, will be working as `cmp.mapping.confirm`.
2. If the completion-item isn't selected, will be working as vim-endwise feature.

```lua
mapping = {
  ['<CR>'] = cmp.mapping.confirm()
}
```


#### What is the equivalence of nvim-compe's `preselect = 'always'`?

You can use the following configuration.

```lua
cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
  }
}
```

#### I don't use a snippet plugin.

At the moment, nvim-cmp requires a snippet engine to function correctly.
You need to specify one in `snippet`.

```lua
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
  end,
}
```


#### I dislike auto-completion

You can use `nvim-cmp` without auto-completion like this.

```lua
cmp.setup {
  completion = {
    autocomplete = false
  }
}
```


#### How to disable nvim-cmp on the specific buffer?

You can specify `enabled = false` like this.

```vim
autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
```


#### nvim-cmp is slow.

I've optimized `nvim-cmp` as much as possible, but there are currently some known / unfixable issues.

**`cmp-buffer` source and too large buffer**

The `cmp-buffer` source makes an index of the current buffer so if the current buffer is too large, it will slowdown the main UI thread.

**`vim.lsp.set_log_level`**

This setting will cause the filesystem operation for each LSP payload.
This will greatly slow down nvim-cmp (and other LSP related features).


#### How to show name of item kind and source (like compe)?

```lua
formatting = {
  format = require("lspkind").cmp_format({with_text = true, menu = ({
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      luasnip = "[LuaSnip]",
      nvim_lua = "[Lua]",
      latex_symbols = "[Latex]",
    })}),
},
```


#### How to set up mappings?

You can find all the mapping examples in [Example mappings](https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings).


Create a Custom Source
====================

Warning: If the LSP spec is changed, nvim-cmp will keep up to it without an announcement.

If you publish `nvim-cmp` source to GitHub, please add `nvim-cmp` topic for the repo.

You should read [cmp types](/lua/cmp/types) and [LSP spec](https://microsoft.github.io/language-server-protocol/specifications/specification-current/) to create sources.

- The `complete` function is required. Others can be omitted.
- The `callback` argument must always be called.
- The custom source should only use `require('cmp')`.
- The custom source can specify `word` property to CompletionItem. (It isn't an LSP specification but supported as a special case.)

Here is an example of a custom source.

```lua
local source = {}

---Source constructor.
source.new = function()
  local self = setmetatable({}, { __index = source })
  self.your_awesome_variable = 1
  return self
end

---Return the source is available or not.
---@return boolean
function source:is_available()
  return true
end

---Return the source name for some information.
function source:get_debug_name()
  return 'example'
end

---Return keyword pattern which will be used...
---  1. Trigger keyword completion
---  2. Detect menu start offset
---  3. Reset completion state
---@param params cmp.SourceBaseApiParams
---@return string
function source:get_keyword_pattern(params)
  return '???'
end

---Return trigger characters.
---@param params cmp.SourceBaseApiParams
---@return string[]
function source:get_trigger_characters(params)
  return { ??? }
end

---Invoke completion (required).
---  If you want to abort completion, just call the callback without arguments.
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  callback({
    { label = 'January' },
    { label = 'February' },
    { label = 'March' },
    { label = 'April' },
    { label = 'May' },
    { label = 'June' },
    { label = 'July' },
    { label = 'August' },
    { label = 'September' },
    { label = 'October' },
    { label = 'November' },
    { label = 'December' },
  })
end

---Resolve completion item that will be called when the item selected or before the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)
  callback(completion_item)
end

---Execute command that will be called when after the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  callback(completion_item)
end

require('cmp').register_source(source.new())
```

You can also create a source by Vim script like this (This is useful to support callback style plugins).

- If you want to return `boolean`, you must return `v:true`/`v:false` instead of `0`/`1`.

```vim
let s:source = {}

function! s:source.new() abort
  return extend(deepcopy(s:source))
endfunction

" The other APIs are also available.

function! s:source.complete(params, callback) abort
  call a:callback({
  \   { 'label': 'January' },
  \   { 'label': 'February' },
  \   { 'label': 'March' },
  \   { 'label': 'April' },
  \   { 'label': 'May' },
  \   { 'label': 'June' },
  \   { 'label': 'July' },
  \   { 'label': 'August' },
  \   { 'label': 'September' },
  \   { 'label': 'October' },
  \   { 'label': 'November' },
  \   { 'label': 'December' },
  \ })
endfunction

call cmp#register_source('month', s:source.new())
```
