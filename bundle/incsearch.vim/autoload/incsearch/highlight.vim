"=============================================================================
" FILE: autoload/incsearch/highlight.vim
" AUTHOR: haya14busa
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
scriptencoding utf-8
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTION = { 'forward': 1, 'backward': 0 } " see :h v:searchforward

" Utility Helper:
let s:U = incsearch#util#import()


" Management:

let s:hi = vital#incsearch#import('Coaster.Highlight').make()
let g:incsearch#highlight#_hi = s:hi

function! incsearch#highlight#update() abort
  " it's intuiive to call incsearch#highlight#on() & off() but there are no
  " need to execute `:nohlsearch` when updating.
  call s:hi.disable_all()
  call s:hi.enable_all()
endfunction

function! incsearch#highlight#on() abort
  call s:hi.enable_all()
  if ! g:incsearch#no_inc_hlsearch
    let &hlsearch = &hlsearch
  endif
endfunction

function! incsearch#highlight#off() abort
  call s:hi.disable_all()
  if ! g:incsearch#no_inc_hlsearch
    nohlsearch
  endif
endfunction

function! s:init_hl() abort
  hi default link IncSearchMatch Search
  hi default link IncSearchMatchReverse IncSearch
  hi default link IncSearchCursor Cursor
  hi default link IncSearchOnCursor IncSearch
  hi default IncSearchUnderline term=underline cterm=underline gui=underline
endfunction
call s:init_hl()
augroup plugin-incsearch-highlight
  autocmd!
  autocmd ColorScheme * call s:init_hl()
augroup END

let s:default_highlight = {
\   'visual' : {
\       'group'    : '_IncSearchVisual',
\       'priority' : '10'
\   },
\   'match' : {
\       'group'    : 'IncSearchMatch',
\       'priority' : '49'
\   },
\   'match_reverse' : {
\       'group'    : 'IncSearchMatchReverse',
\       'priority' : '49'
\   },
\   'on_cursor' : {
\       'group'    : 'IncSearchOnCursor',
\       'priority' : '50'
\   },
\   'cursor' : {
\       'group'    : 'IncSearchCursor',
\       'priority' : '51'
\   },
\ }

function! incsearch#highlight#hgm() abort " highlight group management
  let hgm = copy(s:default_highlight)
  for key in keys(hgm)
    call extend(hgm[key], get(g:incsearch#highlight, key, {}))
  endfor
  return hgm
endfunction

" hldict: { 'name' : lhs, 'highlight': rhs }

" Util:

" @return hldict
function! incsearch#highlight#capture(hlname) abort
  " Based On: https://github.com/t9md/vim-ezbar
  "           https://github.com/osyo-manga/vital-over
  let hlname = a:hlname
  if !hlexists(hlname)
    return
  endif
  while 1
    let save_verbose = &verbose
    let &verbose = 0
    try
      redir => HL_SAVE
      execute 'silent! highlight ' . hlname
      redir END
    finally
      let &verbose = save_verbose
    endtry
    if !empty(matchstr(HL_SAVE, 'xxx cleared$'))
      return ''
    endif
    " follow highlight link
    let ml = matchlist(HL_SAVE, 'links to \zs.*')
    if !empty(ml)
      let hlname = ml[0]
      continue
    endif
    break
  endwhile
  let HL_SAVE = substitute(matchstr(HL_SAVE, 'xxx \zs.*'),
  \ '[ \t\n]\+', ' ', 'g')
  return { 'name': hlname, 'highlight': HL_SAVE }
endfunction

function! incsearch#highlight#turn_off(hldict) abort
  execute 'highlight' a:hldict.name 'NONE'
endfunction

function! incsearch#highlight#turn_on(hldict) abort
  execute 'highlight' a:hldict.name a:hldict.highlight
endfunction

" Wrapper:

" @return hlobj
function! incsearch#highlight#get_visual_hlobj() abort
  if ! exists('s:_visual_hl')
    let s:_visual_hl = incsearch#highlight#capture('Visual')
  endif
  return s:_visual_hl
endfunction

augroup incsearch-update-visual-highlight
  autocmd!
  autocmd ColorScheme * if exists('s:_visual_hl') | unlet s:_visual_hl | endif
augroup END

" Visual Highlighting Emulation:

let s:INT = { 'MAX': 2147483647 }

" NOTE:
"   Default highlight for visual selection has always higher priority than
"   defined highlight, so you have to turn off default visual highlight and
"   emulate it. All this function do is pseudo highlight visual selected area
" args: mode, visual_hl, v_start_pos, v_end_pos
function! incsearch#highlight#emulate_visual_highlight(...) abort
  let is_visual_now = s:U.is_visual(mode(1))
  let mode = get(a:, 1, is_visual_now ? mode(1) : visualmode())
  let visual_hl = get(a:, 2, incsearch#highlight#get_visual_hlobj())
  " Note: the default pos value assume visual selection is not cleared.
  " It uses curswant to emulate visual-block
  let v_start_pos = get(a:, 3,
  \   (is_visual_now ? [line('v'),col('v')] : [line("'<"), col("'<")]))
  " See: https://github.com/vim-jp/issues/issues/604
  " getcurpos() could be negative value, so use winsaveview() instead
  let end_curswant_pos =
  \   (exists('*getcurpos') ? getcurpos()[4] : winsaveview().curswant + 1)
  let v_end_pos = get(a:, 4, (is_visual_now
  \   ? [line('.'), end_curswant_pos < 0 ? s:INT.MAX : end_curswant_pos ]
  \   : [line("'>"), col("'>")]))
  let pattern = incsearch#highlight#get_visual_pattern(mode, v_start_pos, v_end_pos)
  let hgm = incsearch#highlight#hgm()
  let v = hgm.visual
  " NOTE: Update highlight
  execute 'hi' 'clear' v.group
  execute 'hi' v.group visual_hl['highlight']
  call s:hi.add(v.group, v.group, pattern, v.priority)
  call incsearch#highlight#update()
endfunction

function! incsearch#highlight#get_visual_pattern(mode, v_start_pos, v_end_pos) abort
  " NOTE: highlight doesn't work if the range is over screen height, so
  "   limit pattern to visible window.
  let [_, v_start, v_end, _] = s:U.sort_pos([
  \   a:v_start_pos,
  \   a:v_end_pos,
  \   [line('w0'), 1],
  \   [line('w$'), s:U.get_max_col(line('w$'))]
  \  ])
  if a:mode ==# 'v'
    if v_start[0] == v_end[0]
      return printf('\v%%%dl%%%dc\_.*%%%dl%%%dc',
      \              v_start[0],
      \              min([v_start[1], s:U.get_max_col(v_start[0])]),
      \              v_end[0],
      \              min([v_end[1], s:U.get_max_col(v_end[0])]))
    else
      return printf('\v%%%dl%%%dc\_.{-}%%%dl|%%%dl\_.*%%%dl%%%dc',
      \              v_start[0],
      \              min([v_start[1], s:U.get_max_col(v_start[0])]),
      \              v_end[0],
      \              v_end[0],
      \              v_end[0],
      \              min([v_end[1], s:U.get_max_col(v_end[0])]))
    endif
  elseif a:mode ==# 'V'
    return printf('\v%%%dl\_.*%%%dl', v_start[0], v_end[0])
  elseif a:mode ==# "\<C-v>"
    " @vimlint(EVL102, 1, l:min_c)
    let [min_c, max_c] = s:U.sort_num([v_start[1], v_end[1]])
    let max_c += 1 " increment needed
    let max_c = max_c < 0 ? s:INT.MAX : max_c
    let mapfunc = "
    \ printf('%%%dl%%%dc.*%%%dc',
    \        v:val, min_c, min([max_c, s:U.get_max_col(v:val)]))
    \ "
    return '\v'.join(map(range(v_start[0], v_end[0]), mapfunc), '|')
  else
    throw 'incsearch.vim: unexpected mode ' . a:mode
  endif
endfunction

" Incremental Highlighting:

function! incsearch#highlight#incremental_highlight(pattern, ...) abort
  let should_separate_highlight = get(a:, 1, s:FALSE)
  let direction = get(a:, 2, s:DIRECTION.forward)
  let start_pos = get(a:, 3, getpos('.')[1:2])
  let hgm = incsearch#highlight#hgm()
  let [m, r, o, c] = [hgm.match, hgm.match_reverse, hgm.on_cursor, hgm.cursor]
  let on_cursor_pattern = '\m\%#\(' . a:pattern . '\m\)'

  if '' =~# a:pattern
    " Do not highlight for patterns which match everything
    call s:hi.delete_all()
  elseif ! should_separate_highlight
    call s:hi.add(m.group, m.group, a:pattern, m.priority)
    if ! g:incsearch#no_inc_hlsearch
      let @/ = a:pattern
      let &hlsearch = &hlsearch
    endif
  else
    let [p1, p2] = (direction == s:DIRECTION.forward)
    \   ? [incsearch#highlight#forward_pattern(a:pattern, start_pos)
    \     ,incsearch#highlight#backward_pattern(a:pattern, start_pos)]
    \   : [incsearch#highlight#backward_pattern(a:pattern, start_pos)
    \     ,incsearch#highlight#forward_pattern(a:pattern, start_pos)]
    call s:hi.add(m.group , m.group , p1 , m.priority) " right direction
    call s:hi.add(r.group , r.group , p2 , r.priority) " reversed direction
  endif
  call s:hi.add(o.group , o.group , on_cursor_pattern , o.priority)
  call s:hi.add(c.group , c.group , '\v%#'            , c.priority)
  call incsearch#highlight#update()
endfunction

function! incsearch#highlight#forward_pattern(pattern, from_pos) abort
  let [line, col] = a:from_pos
  return printf('\v(%%>%dl|%%%dl%%>%dc)\m\(%s\m\)', line, line, col, a:pattern)
endfunction

function! incsearch#highlight#backward_pattern(pattern, from_pos) abort
  let [line, col] = a:from_pos
  return printf('\v(%%<%dl|%%%dl%%<%dc)\m\(%s\m\)', line, line, col, a:pattern)
endfunction


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
" }}}
