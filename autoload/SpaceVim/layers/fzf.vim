"=============================================================================
" fzf.vim --- fzf layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! SpaceVim#layers#fzf#plugins() abort
  let plugins = []
  call add(plugins, ['junegunn/fzf',                { 'merged' : 0}])
  call add(plugins, ['Shougo/neoyank.vim', {'merged' : 0}])
  call add(plugins, ['SpaceVim/fzf-neoyank',                { 'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#fzf#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  nnoremap <silent> <C-p> :FzfFiles<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'FzfColors', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fe
        \ :<C-u>FZFNeoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['FZFNeoyank',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>FzfJumps<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['FzfJumps',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction

command! FzfColors call <SID>colors()
function! s:colors() abort
  let s:source = 'colorscheme'
  call fzf#run({'source': map(split(globpath(&rtp, 'colors/*.vim')),
        \               "fnamemodify(v:val, ':t:r')"),
        \ 'sink': 'colo', 'down': '40%'})
endfunction

command! FzfFiles call <SID>files()
function! s:files() abort
  let s:source = 'files'
  call fzf#run({'sink': 'e', 'options': '--reverse', 'down' : '40%'})
endfunction

let s:source = ''

function! SpaceVim#layers#fzf#sources() abort

  return s:source

endfunction
command! FzfJumps call <SID>jumps()
function! s:bufopen(e) abort
    let list = split(a:e)
    if len(list) < 4
      return
    endif

    let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
    let lines = getbufline(file_text, linenr)
    let path = file_text
    let bufnr = bufnr(file_text)
    if empty(lines)
      if stridx(join(split(getline(linenr))), file_text) == 0
        let lines = [file_text]
        let path = bufname('%')
        let bufnr = bufnr('%')
      elseif filereadable(path)
        let bufnr = 0
        let lines = ['buffer unloaded']
      else
        " Skip.
        return
      endif
    endif

    exe 'e '  . path
    call cursor(linenr, col)
endfunction
function! s:jumps() abort
  function! s:jumplist() abort
    return split(s:CMP.execute('jumps'), '\n')[1:]
  endfunction
  call fzf#run({
        \   'source':  reverse(<sid>jumplist()),
        \   'sink':    function('s:bufopen'),
        \   'options': '+m',
        \   'down':    len(<sid>jumplist()) + 2
        \ })
endfunction
