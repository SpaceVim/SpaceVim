"=============================================================================
" highlight.vim --- highlight mode for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" TODO: {{{
" e: iedit
" d/D: next previous definition
" f: search files
" s: swoop
" }}}

" Loading SpaceVim api {{{
let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:STRING = SpaceVim#api#import('data#string')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:HI = SpaceVim#api#import('vim#highlight')
"}}}

" init local variable {{{
let s:function_expr = {}
let s:hi_range_id = 0
let s:hi_range_index = 0
" }}}

" transient_state API func: logo {{{
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
  let s:hi_range_id = s:CMP.matchaddpos('HiRrange' . s:current_range, [[3, begin, len(s:current_range) + 2]])
  let s:hi_range_index = s:CMP.matchaddpos('HiRrangeIndex', [[3, begin + len(s:current_range) + 2, len(index) + 2]])
endfunction
" }}}

" transient_state API func: init {{{
let s:hi_info = [
      \ {
      \ 'name' : 'HiPurpleBold',
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
      \ 'name' : 'HiBlueBold',
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

function! s:init() abort
  call s:hi()
  let s:current_range = 'Display'
  let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
  call s:highlight()
endfunction
" }}}

" use SPC s H to highlight all symbol on default range.
" use SPC s h to highlight current symbol on default range.

" public API func: start Highlight mode {{{
function! SpaceVim#plugins#highlight#start(current) abort
  let curpos = getcurpos()
  let save_reg_k = @k
  normal! viw"ky
  let s:current_match = @k
  let @k = save_reg_k
  call setpos('.', curpos)
  if s:current_match =~# '^\s*$' || empty(s:current_match) || s:current_match ==# "\n"
    echohl WarningMsg
    echo 'cursor is not on symbol'
    echohl None
    return
  endif
  let s:state = SpaceVim#api#import('transient_state') 
  call s:state.set_title('Highlight Transient State')
  call s:state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'logo' : s:_function('s:range_logo'),
        \ 'logo_width' : 30,
        \ 'init' : s:_function('s:init'),
        \ 'left' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'Toggle highlight',
        \ 'func' : s:_function('s:next_item'),
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : "\<tab>",
        \ 'desc' : 'Toggle highlight',
        \ 'func' : s:_function('s:toggle_item'),
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'r',
        \ 'desc' : 'change range',
        \ 'func' : '',
        \ 'cmd' : 'call call(' . string(s:_function('s:change_range')) . ', [])',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'e',
        \ 'desc' : 'iedit',
        \ 'cmd' : '',
        \ 'func' : '',
        \ 'exit_cmd' : 'call call(' . string(s:_function('s:iedit')) . ', [])',
        \ 'exit' : 1,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'Previous match',
        \ 'cmd' : 'call call(' . string(s:_function('s:previous_item')) . ', [])',
        \ 'func' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'b',
        \ 'desc' : 'search buffers',
        \ 'cmd' : '',
        \ 'func' : '',
        \ 'exit_cmd' : 'call call(' . string(s:_function('s:search_buffers')) . ', [])',
        \ 'exit' : 1,
        \ },
        \ {
        \ 'key' : '/',
        \ 'desc' : 'Search project',
        \ 'cmd' : '',
        \ 'func' : '',
        \ 'exit_cmd' : 'call call(' . string(s:_function('s:search_project')) . ', [])',
        \ 'exit' : 1,
        \ },
        \ {
        \ 'key' : 'R',
        \ 'desc' : 'Reset',
        \ 'cmd' : '',
        \ 'func' : s:_function('s:reset_range'),
        \ 'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  let save_tve = &t_ve
  setlocal t_ve=
  if has('gui_running')
    let cursor_hi = s:HI.group2dict('Cursor')
    call s:HI.hide_in_normal('Cursor')
  endif
  call s:state.open()
  let &t_ve = save_tve
  if has('gui_running')
    call s:HI.hi(cursor_hi)
  endif
  try
    call s:clear_highlight()
  catch
  endtry
endfunction
" }}}

" public API func: register function range expression {{{
function! SpaceVim#plugins#highlight#reg_expr(ft, begin, end) abort
  call extend(s:function_expr, {a:ft : [a:begin, a:end]})
endfunction
" }}}

" key binding: R reset_range {{{
function! s:reset_range() abort
  let s:current_range = 'Display'
  let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
  call s:clear_highlight()
  call s:highlight()
endfunction
"}}}

" key binding: n next_item {{{
function! s:next_item() abort
  if s:index == len(s:stack) - 1
    let s:index = 0
  else
    let s:index += 1
  endif
  call cursor(s:stack[s:index][0], s:stack[s:index][1] + s:stack[s:index][2] - 1)
  call s:update_highlight()
endfunction
" }}}

" key binding: r change_range {{{
function! s:change_range() abort
  if s:current_range ==# 'Display'
    let s:current_range = 'Buffer'
    let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(1, line('$'), s:current_match, 0)
    call s:clear_highlight()
    call s:highlight()
  elseif s:current_range ==# 'Buffer'
    let s:current_range = 'Function'
    let range = s:find_func_range()
    let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(range[0], range[1], s:current_match, 0)
    call s:clear_highlight()
    call s:highlight()
  elseif s:current_range ==# 'Function'
    let s:current_range = 'Display'
    let [s:stack, s:index] = SpaceVim#plugins#iedit#paser(line('w0'), line('w$'), s:current_match, 0)
    call s:clear_highlight()
    call s:highlight()
  endif
  let s:state._clear_cmdline = 0
  echon ' Change current range to:'
  exe 'echohl HiRrange' . s:current_range
  echon s:current_range
  echohl None
endfunction
" }}}

" key binding: e iedit {{{
function! s:iedit() abort
  call SpaceVim#plugins#iedit#start() 
endfunction
" }}}

" key binding: N/p previous_item {{{
function! s:previous_item() abort
  if s:index == 0
    let s:index = len(s:stack) - 1
  else
    let s:index -= 1
  endif
  call cursor(s:stack[s:index][0], s:stack[s:index][1] + s:stack[s:index][2] - 1)
  call s:update_highlight()
endfunction
" }}}

" key binding: b search_buffers {{{
function! s:search_buffers() abort
  call SpaceVim#plugins#flygrep#open({'input' : s:current_match, 'files':'@buffers'}) 
endfunction
" }}}

" key binding: / search_project {{{
function! s:search_project() abort
  call SpaceVim#plugins#flygrep#open({'input' : s:current_match}) 
endfunction
" }}}

" local func: highlight symbol {{{
function! s:highlight() abort
  let s:highlight_id = []
  for item in s:stack
    call add(s:highlight_id, s:CMP.matchaddpos('HiBlueBold', [ item ]))
  endfor
  let s:highlight_id_c = s:CMP.matchaddpos('HiPurpleBold', [s:stack[s:index]])
endfunction
" }}}

" local func: clear highlight {{{
function! s:clear_highlight() abort
  for id in s:highlight_id
    call matchdelete(id)
  endfor
  call matchdelete(s:highlight_id_c)
endfunction
" }}}

" key binding: Tab toggle_item {{{
function! s:toggle_item() abort

endfunction
" }}}

" local func: function() wrapper {{{
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
" }}}

" local func: update highlight symbol {{{
function! s:update_highlight() abort
  call s:clear_highlight()
  call s:highlight()
endfunction
" }}}

" local func: find function range {{{
function! s:find_func_range() abort
  let line = line('.')
  if !empty(&ft) && has_key(s:function_expr, &ft)
    let begin = s:function_expr[&ft][0]
    let end = s:function_expr[&ft][1]
    let pos1 = search(end, 'nb',line('w0'))
    let pos2 = search(begin, 'nb',line('w0'))
    let pos3 = search(end, 'n',line('w$'))
    let pos0 = line('.')
    if pos1 < pos2 && pos2 < pos0 && pos0 < pos3
      return [pos2, pos3]
    endif
  endif
  return [line, line]
endfunction
" }}}

" vim:set et sw=2 cc=80 foldenable:
