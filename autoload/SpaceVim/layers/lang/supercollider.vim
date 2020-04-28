"=============================================================================
" supercollider.vim --- supercollider language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#supercollider#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-supercollider', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#supercollider#config() abort
  " call SpaceVim#plugins#repl#reg('supercollider', 'supercollider')
  " call SpaceVim#plugins#runner#reg_runner('supercollider', 'supercollider %s')
  " call SpaceVim#mapping#space#regesit_lang_mappings('supercollider', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("supercollider")',
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

" key bindings
"
" au Filetype supercollider nnoremap <buffer> <F5> :call SClang_block()<CR>
" au Filetype supercollider inoremap <buffer> <F5> :call SClang_block()<CR>a
" au Filetype supercollider vnoremap <buffer> <F5> :call SClang_send()<CR>
"
" au Filetype supercollider vnoremap <buffer> <F6> :call SClang_line()<CR>
" au Filetype supercollider nnoremap <buffer> <F6> :call SClang_line()<CR>
" au Filetype supercollider inoremap <buffer> <F6> :call SClang_line()<CR>a
"
" au Filetype supercollider nnoremap <buffer> <F12> :call SClangHardstop()<CR>
"
" au Filetype supercollider nnoremap <leader>sk :SClangRecompile<CR>
" au Filetype supercollider nnoremap <buffer>K :call SChelp(expand('<cword>'))<CR>
" au Filetype supercollider inoremap <C-Tab> :call SCfindArgs()<CR>a
" au Filetype supercollider nnoremap <C-Tab> :call SCfindArgs()<CR>
" au Filetype supercollider vnoremap <C-Tab> :call SCfindArgsFromSelection()<CR>
"
" DEPRECATED
" au Filetype supercollider nnoremap <leader>sd yiw :call SChelp(""")<CR>
" au Filetype supercollider nnoremap <leader>sj yiw :call SCdef(""")<CR>
" au Filetype supercollider nnoremap <leader>si yiw :call SCimplementation(""")<CR>
" au Filetype supercollider nnoremap <leader>sr yiw :call SCreference(""")<CR>
endfunction
