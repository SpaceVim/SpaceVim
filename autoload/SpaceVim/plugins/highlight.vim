"=============================================================================
" highlight.vim --- highlight mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:hi_info = [
      \ {
      \ 'name' : 'IeditPurpleBold',
      \ 'guibg' : '#d3869b',
      \ 'guifg' : '#282828',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },
      \ {
      \ 'name' : 'IeditBlueBold',
      \ 'guibg' : '#83a598',
      \ 'guifg' : '#282828',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 109,
      \ 'bold' : 1,
      \ }
      \ ]
call s:VIMH.hi(s:hi_info[0])
call s:VIMH.hi(s:hi_info[1])

function! SpaceVim#plugins#highlight#start() abort
  let curpos = getcurpos()
  let save_reg_k = @k
  normal! viw"ky
  let s:current_match = @k
  let @k = save_reg_k
  call setpos('.', curpos)
  let state = SpaceVim#api#import('transient_state') 
  let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
  let s:highlight_id = matchaddpos('Search', s:stack)
  let s:highlight_id_c = matchaddpos('IeditPurpleBold', [s:stack[s:index]])
  call state.set_title('Highlight Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'Next match',
        \ 'func' : s:_function('s:next_item'),
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'r',
        \ 'desc' : 'change range',
        \ 'func' : '',
        \ 'cmd' : 'call call(' . string(function('s:change_range')) . ', [])',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'Previous match',
        \ 'cmd' : 'call call(' . string(function('s:previous_item')) . ', [])',
        \ 'func' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'b',
        \ 'desc' : 'search buffers',
        \ 'cmd' : '',
        \ 'func' : '',
        \ 'exit_cmd' : 'call call(' . string(function('s:search_buffers')) . ', [])',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
  call matchdelete(s:highlight_id)
  call matchdelete(s:highlight_id_c)
endfunction
" n : next item
" N/p: Previous item
" r: change range
" R: reset
" e: iedit
" d/D: next previous definition
" b: search buffers
" /: search proj
" f: search files
" s: swoop
"
function! s:next_item() abort
  if s:index == len(s:stack) - 1
    let s:index = 0
  else
    let s:index += 1
  endif
  call cursor(s:stack[s:index][0], s:stack[s:index][1] + s:stack[s:index][2] - 1)
  call s:update_highlight()
endfunction

let s:current_range = 'display'
function! s:change_range() abort
  if s:current_range == 'display'
    let s:current_range = 'buffer'
  elseif s:current_range == 'buffer'
    let s:current_range = 'display'
  endif
endfunction

function! s:previous_item() abort
  if s:index == 0
    let s:index = len(s:stack) - 1
  else
    let s:index -= 1
  endif
  call cursor(s:stack[s:index][0], s:stack[s:index][1] + s:stack[s:index][2] - 1)
  call s:update_highlight()
endfunction

function! s:toggle_item() abort

endfunction

function! s:search_buffers() abort
  call SpaceVim#plugins#flygrep#open({'input' : s:current_match, 'files':'@buffers'}) 
endfunction

" function() wrapper
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

function! s:update_highlight() abort
  call matchdelete(s:highlight_id)
  call matchdelete(s:highlight_id_c)
  let s:highlight_id = matchaddpos('Search', s:stack)
  let s:highlight_id_c = matchaddpos('IeditPurpleBold', [s:stack[s:index]])
  
endfunction
