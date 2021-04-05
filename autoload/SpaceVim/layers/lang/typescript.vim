"GetUserUserContext=============================================================================
" typescript.vim --- lang#typescript layer for SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#typescript, layer-lang-typescript
" @parentsection layers
" This layer provides typescript development support for SpaceVim.
" To enable this layer, add following sinippet into SpaceVim configuration
" file.
" >
"   [layers]
"       name = "lang#typescript"
" <
" @subsection mappings
" >
"   Ket binding          Description
"   ----------------------------------------
"   g d                  defintion preview
" <

function! SpaceVim#layers#lang#typescript#plugins() abort
  let plugins = []
  call add(plugins, ['leafgarland/typescript-vim', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-jsx-typescript', {'merged' : 0}])
  call add(plugins, ['heavenshell/vim-jsdoc', { 'on_cmd': 'JsDoc' }])
  if !SpaceVim#layers#lsp#check_filetype('typescript')
    if has('nvim')
      call add(plugins, ['mhartington/nvim-typescript', {'build': './install.sh'}])
    else
      call add(plugins, ['Quramy/tsuquyomi', {'merged' : 0}])
    endif
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#typescript#config() abort
  if !has('nvim') && !SpaceVim#layers#lsp#check_filetype('typescript')
    augroup SpaceVim_lang_typescript
      autocmd!
      autocmd FileType typescript setlocal omnifunc=tsuquyomi#complete
      " Does tsuquyomi support tsx file?
      autocmd FileType typescriptreact setlocal omnifunc=tsuquyomi#complete
    augroup END
  endif
  call SpaceVim#mapping#gd#add('typescript',
        \ function('s:go_to_typescript_def'))
  call SpaceVim#mapping#gd#add('typescriptreact',
        \ function('s:go_to_typescriptreact_def'))
  call SpaceVim#mapping#space#regesit_lang_mappings('typescript',
        \ function('s:on_typescript_ft'))
  call SpaceVim#mapping#space#regesit_lang_mappings('typescriptreact',
        \ function('s:on_typescript_ft'))
  call SpaceVim#plugins#repl#reg('typescript', ['ts-node', '-i'])
  call SpaceVim#plugins#runner#reg_runner('typescript', {
        \ 'exe' : 'ts-node',
        \ 'usestdin' : 1,
        \ 'opt': [],
        \ })
  let g:neomake_typescript_enabled_makers = ['eslint']
  " does eslint support tsx?
  let g:neoformat_typescriptreact_prettier = {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
        \ 'stdin': 1
        \ }
  let g:neoformat_enabled_typescriptreact = ['prettier']
endfunction

function! SpaceVim#layers#lang#typescript#set_variable(var) abort
  if has('nvim')
    let  g:nvim_typescript#server_path =
          \ get(a:var, 'typescript_server_path',
          \ './node_modules/.bin/tsserver')
  else
    let tsserver_path = get(a:var, 'typescript_server_path', '')
    if !empty(tsserver_path)
      let g:tsuquyomi_use_dev_node_module = 2
      let g:tsuquyomi_tsserver_path = tsserver_path
    endif
  endif
  let g:jsdoc_lehre_path = get(a:var, 'lehre_path', 'lehre')
endfunction

function! s:on_typescript_ft() abort
  if SpaceVim#layers#lsp#check_filetype('typescript')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
  else
    if has('nvim')
      nnoremap <silent><buffer> gD :<C-u>TSTypeDef<Cr>
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'], 'TSDoc',
            \ 'show-document', 1)
      nnoremap <silent><buffer> K :<C-u>TSDoc<Cr>
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'], 'TSRename',
            \ 'rename-symbol', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'f'], 'TSGetCodeFix',
            \ 'code fix', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'i'], 'TSImport',
            \ 'import', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'p'], 'TSDefPreview',
            \ 'preview definition', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'], 'TSType',
            \ 'view type', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'R'], 'TSRefs',
            \ 'show reference', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'D'], 'TSGetDiagnostics',
            \ 'show errors', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'o'], 'TSOrganizeImports',
            \ 'organizes imports', 1)            
    else
      nnoremap <silent><buffer> gD :<C-u>TsuTypeDefinition<Cr>
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'], 'TsuquyomiSignatureHelp',
            \ 'show document', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'], 'TsuquyomiRenameSymbol',
            \ 'rename symbol', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'i'], 'TsuImport',
            \ 'import', 1)
      call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'm'], 'TsuImplementation',
            \ 'interface implementations', 1)
    endif
  endif

  " code runner
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)

  " generate groups
  let g:_spacevim_mappings_space.l.g = {'name' : '+Generate'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'g', 'd'], 'JsDoc',
        \ 'generate JSDoc', 1)

  " REPL support
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("typescript")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)

endfunction

function! s:go_to_typescript_def() abort
  if !SpaceVim#layers#lsp#check_filetype('typescript')
    if has('nvim')
      TSDef
    else 
      call SpaceVim#lsp#go_to_def()
    endif
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction
function! s:go_to_typescriptreact_def() abort
  if !SpaceVim#layers#lsp#check_filetype('typescriptreact')
    if has('nvim')
      TSDef
    else 
      call SpaceVim#lsp#go_to_def()
    endif
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction
