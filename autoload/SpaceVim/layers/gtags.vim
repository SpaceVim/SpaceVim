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
let s:auto_update = 1
let g:tags_cache_dir = '~/.cache/SpaceVim/tags/'

function! SpaceVim#layers#gtags#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/gtags.vim', { 'merged' : 0}]
        \ ]
endfunction

function! SpaceVim#layers#gtags#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create-a-gtags-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update-tag-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'p'], 'Gtags -P', 'list-all-file-in-GTAGS', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'exe "Gtags -d " . expand("<cword>")', 'find-definitions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'exe "Gtags -r " . expand("<cword>")', 'find-references', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 's'], 'exe "Gtags -s " . expand("<cword>")', 'find-cursor-symbol', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'g'], 'exe "Gtags -g " . expand("<cword>")', 'find-cursor-string', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Gtags -f %', 'list of objects', 1)
  let g:gtags_gtagslabel = s:gtagslabel
  call SpaceVim#plugins#projectmanager#reg_callback(funcref('s:update_ctags_option'))
  if s:auto_update
    augroup spacevim_layer_gtags
      autocmd!
      " gtags#update() function only exist when gtags is available
      if executable('gtags')
        au BufWritePost * call gtags#update(1)
      endif
      if executable('ctags')
        au BufWritePost * call ctags#update()
      endif
    augroup END
  endif
endfunction

function! SpaceVim#layers#gtags#set_variable(var) abort

  let s:gtagslabel = get(a:var,
        \ 'gtagslabel',
        \ '')
  let g:tags_cache_dir = get(a:var,
        \ 'tags_cache_dir',
        \ g:tags_cache_dir)

  let s:auto_update = get(a:var,
        \ 'auto_update',
        \ s:auto_update)
endfunction


function! SpaceVim#layers#gtags#get_options() abort

  return ['gtagslabel']

endfunction

function! s:update_ctags_option() abort
  let project_root = getcwd()
  let dir = s:FILE.unify_path(g:tags_cache_dir) 
        \ . s:FILE.path_to_fname(project_root)
  let tags = filter(split(&tags, ','), 'v:val !~# ".cache/SpaceVim/tags"')
  call add(tags, dir . '/tags')
  let &tags = join(tags, ',')
endfunction
