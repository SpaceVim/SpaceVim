"=============================================================================
" incsearch.vim --- SpaceVim incsearch layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section incsearch, layer-incsearch
" @parentsection layers
" This layer improved incremental searching for neovim/vim
"
" mappings
" >
"   key         mode        description
"   /           n/v         incsearch forward
"   ?           n/v         incsearch backward
"   g/          n/v         incsearch stay
"   n           n           nohlsearch n
"   N           n           nohlsearch N
"   *           n           nohlsearch *
"   g*          n           nohlsearch g*
"   #           n           nohlsearch #
"   g#          n           nohlsearch g#
"   z/          n           incsearch fuzzy /
"   z?          n           incsearch fuzzy ?
"   zg?         n           incsearch fuzzy g?
"   <Space>/    n           incsearch easymotion
" <

let s:filename = expand('<sfile>:~')

function! SpaceVim#layers#incsearch#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/incsearch.vim', {'merged' : 0}])
  call add(plugins, ['haya14busa/incsearch-fuzzy.vim', {'merged' : 0}])
  call add(plugins, ['haya14busa/vim-asterisk', {'merged' : 0}])
  call add(plugins, ['osyo-manga/vim-over', {'merged' : 0}])
  call add(plugins, ['haya14busa/incsearch-easymotion.vim', {'merged' : 0}])
  return plugins
endfunction

let s:lnum = expand('<slnum>') + 3
function! SpaceVim#layers#incsearch#config() abort
  " makes * and # work on visual mode too.
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  set hlsearch
  let g:incsearch#no_inc_hlsearch = 1
  let g:incsearch#auto_nohlsearch = get(g:, 'incsearch#auto_nohlsearch', 1)
  nnoremap <silent> n  :call <SID>update_search_index('d')<cr>
  nnoremap <silent> N  :call <SID>update_search_index('r')<cr>
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
  xnoremap <silent> * :<C-u>call <SID>visual_star_saerch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap <silent> # :<C-u>call <SID>visual_star_saerch('?')<CR>?<C-R>=@/<CR><CR>
  function! s:config_fuzzyall(...) abort
    return extend(copy({
          \   'converters': [
          \     incsearch#config#fuzzy#converter(),
          \     incsearch#config#fuzzyspell#converter()
          \   ],
          \ }), get(a:, 1, {}))
  endfunction
  function! s:config_easyfuzzymotion(...) abort
    return extend(copy({
          \   'converters': [incsearch#config#fuzzy#converter()],
          \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
          \   'keymap': {"\<CR>": '<Over>(easymotion)'},
          \   'is_expr': 0,
          \   'is_stay': 1
          \ }), get(a:, 1, {}))
  endfunction
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nmap', ['b', '/'], '<Plug>(incsearch-fuzzyword-/)', ['fuzzy find word',
        \ [
        \ '[SPC b /] is fuzzy find word in current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 0)
endfunction


let s:si_flag = 0
function! s:update_search_index(key) abort
  if a:key ==# 'd'
    if mapcheck('<Plug>(incsearch-nohl-n)') !=# ''
      call feedkeys("\<Plug>(incsearch-nohl-n)")
    else
      normal! n
    endif
  elseif a:key ==# 'r'
    if mapcheck('<Plug>(incsearch-nohl-N)') !=# ''
      call feedkeys("\<Plug>(incsearch-nohl-N)")
    else
      normal! N
    endif
  endif
  let save_cursor = getpos('.')
  if !SpaceVim#layers#core#statusline#check_section('search status')
    call SpaceVim#layers#core#statusline#toggle_section('search status')
  endif
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
  keepjumps call setpos('.', save_cursor)
endfunction

function! s:visual_star_saerch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

