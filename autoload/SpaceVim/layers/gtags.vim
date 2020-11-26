"=============================================================================
" tags.vim --- SpaceVim gtags layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:gtagslabel')
  finish
endif

let s:FILE = SpaceVim#api#import('file')

let s:gtagslabel = ''

function! SpaceVim#layers#gtags#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/gtags.vim', { 'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/ctags.vim', { 'merged' : 0}]
        \ ]
endfunction

function! SpaceVim#layers#gtags#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create-a-gtags-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update-tag-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'p'], 'Gtags -p', 'list-all-file-in-GTAGS', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'exe "Gtags -d " . expand("<cword>")', 'find-definitions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'exe "Gtags -r " . expand("<cword>")', 'find-references', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 's'], 'exe "Gtags -s " . expand("<cword>")', 'find-cursor-symbol', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'g'], 'exe "Gtags -g " . expand("<cword>")', 'find-cursor-string', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Gtags -f %', 'list of objects', 1)
  let g:gtags_gtagslabel = s:gtagslabel
  call SpaceVim#plugins#projectmanager#reg_callback(funcref('s:update_ctags_option'))
endfunction

function! SpaceVim#layers#gtags#set_variable(var) abort

  let s:gtagslabel = get(a:var,
        \ 'gtagslabel',
        \ '')
  let g:tags_cache_dir = get(a:var,
        \ 'tags_cache_dir',
        \ '')
endfunction


function! SpaceVim#layers#gtags#get_options() abort

  return ['gtagslabel']

endfunction

function! s:update_ctags_option() abort
  let project_root = getcwd()
  let dir = s:FILE.unify_path(g:gtags_cache_dir) 
        \ . s:FILE.path_to_fname(project_root)
  let tags = filter(split(&tags, ','), 'v:val !~# ".cache/SpaceVim/tags"')
  call add(tags, dir . '/tags')
  let &tags = join(tags, ',')
endfunction
