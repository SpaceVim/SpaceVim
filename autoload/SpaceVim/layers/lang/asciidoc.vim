"=============================================================================
" asciidoc.vim --- lang#asciidoc layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#asciidoc, layers-lang-asciidoc
" @parentsection layers
" This layer provides syntax highlighting for asciidoc. To enable this
" layer:
" >
"   [layers]
"     name = "lang#asciidoc"
" <

func! SpaceVim#layers#lang#asciidoc#plugins() abort

  return [
        \ [g:_spacevim_root_dir . 'bundle/vim-asciidoc', {'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/VimRegStyle', {'merged' : 0}],
        \ ]

endf


function! SpaceVim#layers#lang#asciidoc#config() abort

  call SpaceVim#mapping#space#regesit_lang_mappings('asciidoc', function('s:language_specified_mappings'))

  " tagbar configuration
  "
  let ctags_version = system('ctags --version')
  if !v:shell_error && ctags_version =~# 'Universal Ctags'
  else
    let g:tagbar_type_asciidoc = {
          \ 'ctagstype' : 'asciidoc',
          \ 'kinds' : [
          \ 'h:table of contents',
          \ 'a:anchors:1',
          \ 't:titles:1',
          \ 'n:includes:1',
          \ 'i:images:1',
          \ 'I:inline images:1'
          \ ],
          \ 'deffile': g:_spacevim_root_dir . 'bundle/vim-asciidoc/ctags/asciidoc.conf' ,
          \ 'sort' : 0
          \ }
  endif

endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','h'],
        \ 'call call('
        \ . string(function('s:compile_to_html')) . ', [])',
        \ 'compile-to-html', 1)
endfunction

function! s:compile_to_html() abort
  let input = expand('%')
  let target = fnamemodify(input, ':r') . '.html'
  let cmd = printf('asciidoc -o %s %s', target, input)
  call system(cmd)
endfunction

function! SpaceVim#layers#lang#asciidoc#health() abort
  call SpaceVim#layers#lang#asciidoc#plugins()
  call SpaceVim#layers#lang#asciidoc#config()
  return 1
endfunction

" https://asciidoctor.org/docs/editing-asciidoc-with-live-preview/

" https://asciidoctor.org/docs/editing-asciidoc-with-live-preview/
" VimRegStyle based on https://github.com/Raimondi/VimRegStyle/commit/771e32e659b345cf29993d517e08b6b3f741f9c6
" vim-asciidoc is based on https://github.com/wsdjeg/vim-asciidoc/
