function! SpaceVim#layers#lang#haskell#plugins() abort
  let plugins = [
        \ ['neovimhaskell/haskell-vim', { 'on_ft': 'haskell' }],
        \ ['pbrisbin/vim-syntax-shakespeare', { 'on_ft': 'haskell' }],
        \ ]

  if !s:use_lsp
    call add(plugins, ['eagletmt/neco-ghc', { 'on_ft': 'haskell' }])
  endif

  return plugins
endfunction

let s:use_lsp = 0

function! SpaceVim#layers#lang#haskell#set_variable(var) abort
  let s:use_lsp = get(a:var, 'use_lsp', 0) && has('nvim') && executable('hie')
endfunction

function! SpaceVim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  call SpaceVim#plugins#runner#reg_runner('haskell', [
        \ 'ghc -v0 --make %s -o #TEMP#',
        \ '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('haskell',
        \ funcref('s:on_ft'))

  if s:use_lsp
    call SpaceVim#mapping#gd#add('haskell',
          \ function('SpaceVim#lsp#go_to_def'))
    call SpaceVim#lsp#reg_server('haskell', ['hie', '--lsp'])
  endif

  augroup SpaceVim_lang_haskell
    autocmd!

    if !s:use_lsp
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    endif
  augroup END
endfunction

function! s:on_ft() abort
  if s:use_lsp
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif

  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
