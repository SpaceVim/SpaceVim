"=============================================================================
" FILE: autoload/incsearch/over/modules/incsearch.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTION = { 'forward': 1, 'backward': 0 } " see :h v:searchforward


let s:hi = g:incsearch#highlight#_hi
let s:U = incsearch#util#import()

let s:inc = {
\   'name' : 'incsearch',
\}

" NOTE: for InsertRegister handling
function! s:inc.priority(event) abort
  return a:event is# 'on_char' ? 10 : 0
endfunction

function! s:inc.on_enter(cmdline) abort
  nohlsearch " disable previous highlight
  let a:cmdline._w = winsaveview()
  let hgm = incsearch#highlight#hgm()
  let c = hgm.cursor
  call s:hi.add(c.group, c.group, '\%#', c.priority)
  call incsearch#highlight#update()

  " XXX: Manipulate search history for magic option
  " In the first place, I want to omit magic flag when histadd(), but
  " when returning cmd as expr mapping and feedkeys() cannot handle it, so
  " remove no user intended magic flag at on_enter.
  " Maybe I can also handle it with autocmd, should I use autocmd instead?
  let hist = histget('/', -1)
  if len(hist) > 2 && hist[:1] ==# incsearch#magic()
    call histdel('/', -1)
    call histadd('/', hist[2:])
  endif
endfunction

function! s:inc.on_leave(cmdline) abort
  call s:hi.disable_all()
  call s:hi.delete_all()
  " redraw: hide pseud-cursor
  redraw " need to redraw for handling non-<expr> mappings
  if a:cmdline.getline() ==# ''
    echo ''
  else
    echo a:cmdline.get_prompt() . a:cmdline.getline()
  endif
  " NOTE:
  "   push rest of keymappings with feedkeys()
  "   FIXME: assume 'noremap' but it should take care wheter or not the
  "   mappings should be remapped or not
  if a:cmdline.input_key_stack_string() !=# ''
    call feedkeys(a:cmdline.input_key_stack_string(), 'n')
  endif
endfunction

" Avoid search-related error while incremental searching
function! s:on_searching(func, ...) abort
  try
    return call(a:func, a:000)
  catch /E16:/  " E16: Invalid range  (with /\_[a- )
  catch /E33:/  " E33: No previous substitute regular expression
  catch /E53:/  " E53: Unmatched %(
  catch /E54:/
  catch /E55:/
  catch /E62:/  " E62: Nested \= (with /a\=\=)
  catch /E63:/  " E63: invalid use of \_
  catch /E64:/  " E64: \@ follows nothing
  catch /E65:/  " E65: Illegal back reference
  catch /E66:/  " E66: \z( not allowed here
  catch /E67:/  " E67: \z1 et al. not allowed here
  catch /E68:/  " E68: Invalid character after \z (with /\za & re=1)
  catch /E69:/  " E69: Missing ] after \%[
  catch /E70:/  " E70: Empty \%[]
  catch /E71:/  " E71: Invalid character after \%
  catch /E554:/
  catch /E678:/ " E678: Invalid character after \%[dxouU]
  catch /E864:/ " E864: \%#= can only be followed by 0, 1, or 2. The
                "       automatic engine will be used
  catch /E865:/ " E865: (NFA) Regexp end encountered prematurely
  catch /E866:/ " E866: (NFA regexp) Misplaced @
  catch /E867:/ " E867: (NFA) Unknown operator
  catch /E869:/ " E869: (NFA) Unknown operator '\@m
  catch /E870:/ " E870: (NFA regexp) Error reading repetition limits
  catch /E871:/ " E871: (NFA regexp) Can't have a multi follow a multi !
  catch /E874:/ " E874: (NFA) Could not pop the stack ! (with \&)
  catch /E877:/ " E877: (NFA regexp) Invalid character class: 109
  catch /E888:/ " E888: (NFA regexp) cannot repeat (with /\ze*)
    call s:hi.disable_all()
  catch
    echohl ErrorMsg | echom v:throwpoint . ' ' . v:exception | echohl None
  endtry
endfunction

function! s:on_char_pre(cmdline) abort
  " NOTE:
  " `:call a:cmdline.setchar('')` as soon as possible!
  let [raw_pattern, offset] = a:cmdline._parse_pattern()
  let pattern = a:cmdline._convert(raw_pattern)

  " Interactive :h last-pattern if pattern is empty
  if ( a:cmdline.is_input('<Over>(incsearch-next)')
  \ || a:cmdline.is_input('<Over>(incsearch-prev)')
  \ ) && empty(pattern)
    call a:cmdline.setchar('')
    " Use history instead of @/ to work with magic option and converter
    call a:cmdline.setline(histget('/', -1) . (empty(offset) ? '' : a:cmdline._base_key) . offset)
    " Just insert last-pattern and do not count up, but the incsearch-prev
    " should move the cursor to reversed directly, so do not return if the
    " command is prev
    if a:cmdline.is_input('<Over>(incsearch-next)') | return | endif
  endif

  if a:cmdline.is_input('<Over>(incsearch-next)')
    call a:cmdline.setchar('')
    if a:cmdline._flag ==# 'n' " exit stay mode
      let a:cmdline._flag = ''
    else
      let a:cmdline._vcount1 += 1
    endif
  elseif a:cmdline.is_input('<Over>(incsearch-prev)')
    call a:cmdline.setchar('')
    if a:cmdline._flag ==# 'n' " exit stay mode
      let a:cmdline._flag = ''
    endif
    let a:cmdline._vcount1 -= 1
  elseif (a:cmdline.is_input('<Over>(incsearch-scroll-f)')
  \ &&   (a:cmdline._flag ==# '' || a:cmdline._flag ==# 'n'))
  \ ||   (a:cmdline.is_input('<Over>(incsearch-scroll-b)') && a:cmdline._flag ==# 'b')
    call a:cmdline.setchar('')
    if a:cmdline._flag ==# 'n' | let a:cmdline._flag = '' | endif
    let pos_expr = a:cmdline.is_input('<Over>(incsearch-scroll-f)') ? 'w$' : 'w0'
    let to_col = a:cmdline.is_input('<Over>(incsearch-scroll-f)')
    \          ? s:U.get_max_col(pos_expr) : 1
    let [from, to] = [getpos('.')[1:2], [line(pos_expr), to_col]]
    let cnt = s:U.count_pattern(pattern, from, to)
    let a:cmdline._vcount1 += cnt
  elseif (a:cmdline.is_input('<Over>(incsearch-scroll-b)')
  \ &&   (a:cmdline._flag ==# '' || a:cmdline._flag ==# 'n'))
  \ ||   (a:cmdline.is_input('<Over>(incsearch-scroll-f)') && a:cmdline._flag ==# 'b')
    call a:cmdline.setchar('')
    if a:cmdline._flag ==# 'n'
      let a:cmdline._flag = ''
      let a:cmdline._vcount1 -= 1
    endif
    let pos_expr = a:cmdline.is_input('<Over>(incsearch-scroll-f)') ? 'w$' : 'w0'
    let to_col = a:cmdline.is_input('<Over>(incsearch-scroll-f)')
    \          ? s:U.get_max_col(pos_expr) : 1
    let [from, to] = [getpos('.')[1:2], [line(pos_expr), to_col]]
    let cnt = s:U.count_pattern(pattern, from, to)
    let a:cmdline._vcount1 -= cnt
  endif

  " Handle nowrapscan:
  "   if you `:set nowrapscan`, you can't move to the reversed direction
  if !&wrapscan && (
  \    a:cmdline.is_input('<Over>(incsearch-next)')
  \ || a:cmdline.is_input('<Over>(incsearch-prev)')
  \ || a:cmdline.is_input('<Over>(incsearch-scroll-f)')
  \ || a:cmdline.is_input('<Over>(incsearch-scroll-b)')
  \ )
    if a:cmdline._vcount1 < 1
      let a:cmdline._vcount1 = 1
    else
      call a:cmdline.setchar('')
      let [from, to] = [[a:cmdline._w.lnum, a:cmdline._w.col + 1],
      \       a:cmdline._flag !=# 'b'
      \       ? [line('$'), s:U.get_max_col('$')]
      \       : [1, 1]
      \   ]
      let max_cnt = s:U.count_pattern(pattern, from, to, s:TRUE)
      let a:cmdline._vcount1 = min([max_cnt, a:cmdline._vcount1])
    endif
  endif
  if &wrapscan && a:cmdline._vcount1 < 1
    let a:cmdline._vcount1 += s:U.count_pattern(pattern)
  endif
endfunction

function! s:on_char(cmdline) abort
  if a:cmdline._does_exit_from_incsearch
    return
  endif
  let [raw_pattern, offset] = a:cmdline._parse_pattern()

  if raw_pattern ==# ''
    call s:hi.disable_all()
    nohlsearch
    return
  endif

  " For InsertRegister
  if a:cmdline.get_tap_key() ==# "\<C-r>"
    let p = a:cmdline.getpos()
    " Remove `"`
    let raw_pattern = raw_pattern[:p-1] . raw_pattern[p+1:]
    let w = winsaveview()
    call cursor(line('.'), col('.') + len(a:cmdline.backward_word()))
    call a:cmdline.get_module('InsertRegister').reset()
    call winrestview(w)
  endif

  let pattern = a:cmdline._convert(raw_pattern)

  " Improved Incremental cursor move!
  call s:move_cursor(a:cmdline, pattern, offset)

  " Improved Incremental highlighing!
  " case: because matchadd() doesn't handle 'ignorecase' nor 'smartcase'
  let case = incsearch#detect_case(raw_pattern)
  let should_separate = g:incsearch#separate_highlight && a:cmdline._flag !=# 'n'
  let pattern_for_hi =
  \ (a:cmdline._flag is# 'b' ? s:unescape_question_for_backward(pattern) : pattern)
  \ . case
  call incsearch#highlight#incremental_highlight(
  \   pattern_for_hi,
  \   should_separate,
  \   a:cmdline._direction,
  \   [a:cmdline._w.lnum, a:cmdline._w.col])

  " functional `normal! zz` after scroll for <expr> mappings
  if ( a:cmdline.is_input('<Over>(incsearch-scroll-f)')
  \ || a:cmdline.is_input('<Over>(incsearch-scroll-b)'))
    call winrestview({'topline': max([1, line('.') - winheight(0) / 2])})
  endif
endfunction

" Caveat: It handle :h last-pattern, so be careful if you want to pass empty
" string as a pattern
function! s:move_cursor(cli, pattern, ...) abort
  let offset = get(a:, 1, '')
  if a:cli._flag ==# 'n' " skip if stay mode
    return
  endif
  call winrestview(a:cli._w)
  " pseud-move cursor position: this is restored afterward if called by
  " <expr> mappings
  if a:cli._is_expr
    for _ in range(a:cli._vcount1)
      " NOTE: This cannot handle {offset} for cursor position
      call search(a:pattern, a:cli._flag)
    endfor
  else
    " More precise cursor position while searching
    " Caveat:
    "   This block contains `normal`, please make sure <expr> mappings
    "   doesn't reach this block
    let is_visual_mode = s:U.is_visual(mode(1))
    let cmd = incsearch#with_ignore_foldopen(
    \   s:U.dictfunction(a:cli._build_search_cmd, a:cli),
    \   a:cli._combine_pattern(a:pattern, offset), 'n')
    " NOTE:
    " :silent!
    "   Shut up errors! because this is just for the cursor emulation
    "   while searching
    silent! call incsearch#execute_search(cmd)
    if is_visual_mode
      let w = winsaveview()
      normal! gv
      call winrestview(w)
      call incsearch#highlight#emulate_visual_highlight()
    endif
  endif
endfunction

function! s:inc.on_char_pre(cmdline) abort
  call s:on_searching(function('s:on_char_pre'), a:cmdline)
endfunction

function! s:inc.on_char(cmdline) abort
  call s:on_searching(function('s:on_char'), a:cmdline)
endfunction

function! s:unescape_question_for_backward(pattern) abort
  return substitute(a:pattern, '\\?', '?', 'g')
endfunction

function! incsearch#over#modules#incsearch#make() abort
  return deepcopy(s:inc)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
