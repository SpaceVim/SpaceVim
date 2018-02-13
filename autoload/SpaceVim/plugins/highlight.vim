"=============================================================================
" highlight.vim --- highlight mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:STRING = SpaceVim#api#import('data#string')
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
      \ 'name' : 'HiRrangeDisplay',
      \ 'guibg' : '#458588',
      \ 'guifg' : '#282828',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },
      \ {
      \ 'name' : 'HiRrangeBuffer',
      \ 'guibg' : '#689d6a',
      \ 'guifg' : '#282828',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },
      \ {
      \ 'name' : 'HiRrangeFunction',
      \ 'guibg' : '#d38696',
      \ 'guifg' : '#282828',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },
      \ {
      \ 'name' : 'HiRrangeIndex',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#a89984',
      \ 'ctermbg' : 237,
      \ 'ctermfg' : 246,
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

function! s:hi() abort
  for info in s:hi_info
    call s:VIMH.hi(info)
  endfor
endfunction

call s:hi()

function! s:init() abort
  let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
  call s:highlight()
endfunction

function! SpaceVim#plugins#highlight#start() abort
  let curpos = getcurpos()
  let save_reg_k = @k
  normal! viw"ky
  let s:current_match = @k
  let @k = save_reg_k
  call setpos('.', curpos)
  let s:state = SpaceVim#api#import('transient_state') 
  call s:state.set_title('Highlight Transient State')
  call s:state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'logo' : function('s:range_logo'),
        \ 'logo_width' : 30,
        \ 'init' : function('s:init'),
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
  call s:state.open()
  call s:clear_highlight()
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

let s:current_range = 'Display'
function! s:change_range() abort
  if s:current_range ==# 'Display'
    let s:current_range = 'Buffer'
    let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(1, line('$'), s:current_match, 0)
    call s:clear_highlight()
    call s:highlight()
  elseif s:current_range ==# 'Buffer'
    let s:current_range = 'Function'
  elseif s:current_range ==# 'Function'
    let s:current_range = 'Display'
    let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
    call s:clear_highlight()
    call s:highlight()
  endif
  let s:state.noredraw = 1
endfunction

function! s:highlight() abort
  let s:highlight_id = []
  for item in s:stack
    call add(s:highlight_id, matchaddpos('Search', [ item ]))
  endfor
  let s:highlight_id_c = matchaddpos('IeditPurpleBold', [s:stack[s:index]])
endfunction

function! s:clear_highlight() abort
  for id in s:highlight_id
    call matchdelete(id)
  endfor
  call matchdelete(s:highlight_id_c)
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
  call s:clear_highlight()
  call s:highlight()
endfunction


let s:hi_range_id = 0
let s:hi_range_index = 0
function! s:range_logo() abort
  let line = getline(3)
  let range = s:current_range
  let index = '[' . (s:index + 1) . '/' . len(s:stack) . ']'
  let logo = s:STRING.fill_middle(range . '  ' . index, 30)
  let begin = stridx(logo, s:current_range)
  call setline(3,  logo . line[30:])
  try
    call matchdelete(s:hi_range_id)
    call matchdelete(s:hi_range_index)
  catch
  endtry
  let s:hi_range_id = matchaddpos('HiRrange' . s:current_range, [[3, begin, len(s:current_range) + 2]])
  let s:hi_range_index = matchaddpos('HiRrangeIndex', [[3, begin + len(s:current_range) + 2, len(index) + 2]])
  redraw!
  echon ' Change current range to:'
  exe 'echohl HiRrange' . s:current_range
  echon s:current_range
  echohl None
endfunction

function! s:update_logo_highlight() abort

endfunction


