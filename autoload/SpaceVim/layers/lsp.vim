"=============================================================================
" lsp.vim --- SpaceVim lsp layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:NVIM_VERSION')
  finish
endif

""
" @section language server protocol, layers-lsp
" @parentsection layers
" This layer provides language client support for SpaceVim.
" By default, this layer is not loaded. You need to enable this layer with
" specific clients, for example:
" >
"   [[layers]]
"     name = 'lsp'
"     enabled_clients = ['vimls']
" <
"
" @subsection layer options
"
" The following options can be used with this layer:
"
" 1. `enabled_clients`: set the enabled servers. This options only for
" neovim 0.5.0+.
" 2. `override_cmd`: If you are not using neovim 0.5.0+, use this option to
" set default lsp command.
"
" @subsection LSP servers
"
" The default LSP servers are:
" >
"   name      Discriptions
"   ---------------------------------------------------
"   vimls     vim-language-server
" <

let s:NVIM_VERSION = SpaceVim#api#import('neovim#version')
let s:FILE = SpaceVim#api#import('file')
let s:enabled_clients = []
let s:override_client_cmds = {}

function! SpaceVim#layers#lsp#health() abort
  call SpaceVim#layers#lsp#plugins()
  call SpaceVim#layers#lsp#config()
  return 1
endfunction


function! SpaceVim#layers#lsp#setup() abort
  lua << EOF
  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>lua require("spacevim.diagnostic").show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua require("spacevim.diagnostic").goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua require("spacevim.diagnostic").goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua require("spacevim.diagnostic").set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = require('spacevim').eval('s:enabled_clients')
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
      }
    }
end
local override_client_cmds = require('spacevim').eval('s:override_client_cmds')
for client, override_cmd in pairs(override_client_cmds) do
  nvim_lsp[client].setup {
    cmd = override_cmd,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
      }
    }
end
EOF
endfunction

function! SpaceVim#layers#lsp#plugins() abort
  let plugins = []

  if (has('nvim-0.5.0') && s:NVIM_VERSION.is_release_version()) || has('nvim-0.6.0')
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-lspconfig', {'merged' : 0, 'loadconf' : 1}])
    if g:spacevim_autocomplete_method ==# 'deoplete'
      call add(plugins, [g:_spacevim_root_dir . 'bundle/deoplete-lsp', {'merged' : 0}])
    elseif g:spacevim_autocomplete_method ==# 'nvim-cmp'
      call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-nvim-lsp', {
            \ 'merged' : 0,
            \ }])
    endif
  elseif SpaceVim#layers#isLoaded('autocomplete') && get(g:, 'spacevim_autocomplete_method') ==# 'coc'
    " nop
  elseif has('nvim-0.4.3') && $ENABLE_NVIM043LSP
    call add(plugins, ['bfredl/nvim-lspmirror', {'merged' : 0}])
    call add(plugins, ['bfredl/nvim-lspext', {'merged' : 0}])
  elseif has('nvim')
    call add(plugins, ['autozimu/LanguageClient-neovim',
          \ { 'merged': 0, 'if': has('python3'), 'build' : 'bash install.sh' }])
  else
    call add(plugins, ['prabirshrestha/async.vim', {'merged' : 0}])
    call add(plugins, ['prabirshrestha/vim-lsp', {'merged' : 0}])
  endif

  return plugins
endfunction

function! SpaceVim#layers#lsp#config() abort
  for ft in s:enabled_fts
    call SpaceVim#lsp#reg_server(ft, s:lsp_servers[ft])
  endfor
  " SpaceVim/LanguageClient-neovim {{{
  let g:LanguageClient_diagnosticsDisplay = {
        \ 1: {
          \ 'name': 'Error',
          \ 'texthl': 'LanguageClientError',
          \ 'signText': g:spacevim_error_symbol,
          \ 'signTexthl': 'LanguageClientError', 
          \ 'virtualTexthl': 'Error',
          \ },
          \ 2: {
            \ 'name': 'Warning',
            \ 'texthl': 'LanguageClientWarning',
            \ 'signText': g:spacevim_warning_symbol,
            \ 'signTexthl': 'LanguageClientWarningSign',
            \ 'virtualTexthl': 'Todo',
            \ },
            \ 3: {
              \ 'name': 'Information',
              \ 'texthl': 'LanguageClientInfo',
              \ 'signText': g:spacevim_info_symbol,
              \ 'signTexthl': 'LanguageClientInfoSign',
              \ 'virtualTexthl': 'Todo',
              \ },
              \ 4: {
                \ 'name': 'Hint',
                \ 'texthl': 'LanguageClientInfo',
                \ 'signText': g:spacevim_info_symbol,
                \ 'signTexthl': 'LanguageClientInfoSign',
                \ 'virtualTexthl': 'Todo',
                \ },
                \ }

  if g:spacevim_lint_engine ==# 'neomake'
    let g:LanguageClient_diagnosticsDisplay[1].texthl = 'NeomakeError'
    let g:LanguageClient_diagnosticsDisplay[1].signTexthl = 'NeomakeErrorSign'

    let g:LanguageClient_diagnosticsDisplay[2].texthl = 'NeomakeWarning'
    let g:LanguageClient_diagnosticsDisplay[2].signTexthl = 
          \ 'NeomakeWarningSign'

    let g:LanguageClient_diagnosticsDisplay[3].texthl = 'NeomakeInfo'
    let g:LanguageClient_diagnosticsDisplay[3].signTexthl = 'NeomakeInfoSign'

    let g:LanguageClient_diagnosticsDisplay[4].texthl = 'NeomakeMessage'
    let g:LanguageClient_diagnosticsDisplay[4].signTexthl = 
          \ 'NeomakeMessageSign'
  elseif g:spacevim_lint_engine ==# 'ale'
    let g:LanguageClient_diagnosticsDisplay[1].texthl = 'ALEError'
    let g:LanguageClient_diagnosticsDisplay[1].signTexthl = 'ALEErrorSign'

    let g:LanguageClient_diagnosticsDisplay[2].texthl = 'ALEWarning'
    let g:LanguageClient_diagnosticsDisplay[2].signTexthl = 'ALEWarningSign'

    let g:LanguageClient_diagnosticsDisplay[3].texthl = 'ALEInfo'
    let g:LanguageClient_diagnosticsDisplay[3].signTexthl = 'ALEInfoSign'

    let g:LanguageClient_diagnosticsDisplay[4].texthl = 'ALEInfo'
    let g:LanguageClient_diagnosticsDisplay[4].signTexthl = 'ALEInfoSign'
  endif


  if !SpaceVim#layers#isLoaded('checkers')
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], 'call call('
          \ . string(s:_function('s:clear_errors')) . ', [])',
          \ 'clear all errors', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'call call('
          \ . string(s:_function('s:jump_to_next_error')) . ', [])',
          \ 'next-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'call call('
          \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
          \ 'previous-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'call call('
          \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
          \ 'previous-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'call call('
          \ . string(s:_function('s:toggle_show_error')) . ', [0])',
          \ 'toggle showing the error list', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'L'], 'call call('
          \ . string(s:_function('s:toggle_show_error')) . ', [1])',
          \ 'toggle showing the error list', 1)
  endif

  let g:LanguageClient_autoStart = 1
  let g:lsp_async_completion = 1
  " }}}
endfunction

let s:enabled_fts = []

let s:lsp_servers = {
      \ 'ada' : ['ada_language_server'],
      \ 'c' : ['clangd'],
      \ 'cpp' : ['clangd'],
      \ 'crystal' : ['scry'],
      \ 'css' : ['css-languageserver', '--stdio'],
      \ 'dart' : ['dart_language_server'],
      \ 'dockerfile' : ['docker-langserver', '--stdio'],
      \ 'go' : ['gopls'],
      \ 'haskell' : ['hie-wrapper', '--lsp'],
      \ 'html' : ['html-languageserver', '--stdio'],
      \ 'javascript' : ['typescript-language-server', '--stdio'],
      \ 'javascriptreact' : ['typescript-language-server', '--stdio'],
      \ 'julia' : ['julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false); server.runlinter = true; run(server);'],
      \ 'objc' : ['clangd'],
      \ 'objcpp' : ['clangd'],
      \ 'php' : ['php', g:spacevim_plugin_bundle_dir . 'repos/github.com/phpactor/phpactor/bin/phpactor', 'language-server'],
      \ 'purescript' : ['purescript-language-server', '--stdio'],
      \ 'python' : ['pyls'],
      \ 'reason' : ['ocaml-language-server'],
      \ 'ruby' : ['solargraph',  'stdio'],
      \ 'rust' : ['rustup', 'run', 'nightly', 'rls'],
      \ 'scala' : ['metals-vim'],
      \ 'sh' : ['bash-language-server', 'start'],
      \ 'typescript' : ['typescript-language-server', '--stdio'],
      \ 'typescriptreact' : ['typescript-language-server', '--stdio'],
      \ 'vim' : ['vim-language-server', '--stdio'],
      \ 'vue' : ['vls']
      \ }

function! SpaceVim#layers#lsp#set_variable(var) abort
  let s:enabled_clients = get(a:var, 'enabled_clients', s:enabled_clients)
  let override = get(a:var, 'override_cmd', {})
  let s:override_client_cmds = get(a:var, 'override_client_cmds', {})
  if !empty(override)
    call extend(s:lsp_servers, override, 'force')
  endif
  let l:cwd = s:FILE.path_to_fname(getcwd())
  for ft in get(a:var, 'filetypes', [])
    let l:cmds = get(s:lsp_servers, ft, [''])
    let l:exec = l:cmds[0]
    if empty(l:exec)
      call SpaceVim#logger#warn('Failed to find the lsp server command for ' . ft)
    else
      if executable(l:exec)
        call add(s:enabled_fts, ft)
        let l:newcmds = []
        for l:cmd in l:cmds
          let l:newcmd = substitute(l:cmd, '#{cwd}', l:cwd, 'g')
          call add(l:newcmds, l:newcmd)
        endfor
        let s:lsp_servers[ft] = l:newcmds
      else
        call SpaceVim#logger#warn('Failed to enable lsp for ' . ft . ', ' . l:exec . ' is not executable!')
      endif
    endif
  endfor
endfunction

function! SpaceVim#layers#lsp#check_filetype(ft) abort
  return index(s:enabled_fts, a:ft) != -1
endfunction

function! SpaceVim#layers#lsp#check_server(server) abort
  return index(s:enabled_clients, a:server) != -1
endfunction

function! s:jump_to_next_error() abort
  try
    lnext
  catch
    try
      ll
    catch
      try
        cnext
      catch
        try
          cc
        catch
          echohl WarningMsg
          echon 'There is no errors!'
          echohl None
        endtry
      endtry
    endtry
  endtry
endfunction

function! s:jump_to_previous_error() abort
  try
    lprevious
  catch
    try
      ll
    catch
      try
        cprevious
      catch
        try
          cc
        catch
          echohl WarningMsg
          echon 'There is no errors!'
          echohl None
        endtry
      endtry
    endtry
  endtry
endfunction

function! s:toggle_show_error(...) abort
  try
    botright lopen
  catch
    try
      if len(getqflist()) == 0
        echohl WarningMsg
        echon 'There is no errors!'
        echohl None
      else
        botright copen
      endif
    catch
    endtry
  endtry
  if a:1 == 1
    wincmd w
  endif
endfunction

if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

" TODO clear errors
function! s:clear_errors() abort
  sign unplace *
endfunction
