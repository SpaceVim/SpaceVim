"=============================================================================
" FILE: autoload/incsearch.vim
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
"
" vimlint:
" @vimlint(EVL103, 1, a:cmdline)
" @vimlint(EVL102, 1, v:errmsg)
" @vimlint(EVL102, 1, v:warningmsg)
" @vimlint(EVL102, 1, v:searchforward)
"=============================================================================
scriptencoding utf-8
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTION = { 'forward': 1, 'backward': 0 } " see :h v:searchforward

" based on: https://github.com/deris/vim-magicalize/blob/433e38c1e83b1bdea4f83ab99dc19d070932380c/autoload/magicalize.vim#L52-L53
" improve to work with repetitive espaced slash like \V\V
" NOTE: \@1<= doesn't work to detect \v\v\v\v
let s:escaped_backslash     = '\m\%(^\|[^\\]\)\%(\\\\\)*'
let s:non_escaped_backslash = '\m\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@<=\\'

" Option:
let g:incsearch#emacs_like_keymap      = get(g: , 'incsearch#emacs_like_keymap'      , s:FALSE)
let g:incsearch#highlight              = get(g: , 'incsearch#highlight'              , {})
let g:incsearch#separate_highlight     = get(g: , 'incsearch#separate_highlight'     , s:FALSE)
let g:incsearch#consistent_n_direction = get(g: , 'incsearch#consistent_n_direction' , s:FALSE)
let g:incsearch#vim_cmdline_keymap     = get(g: , 'incsearch#vim_cmdline_keymap'     , s:TRUE)
let g:incsearch#smart_backward_word    = get(g: , 'incsearch#smart_backward_word'    , s:TRUE)
let g:incsearch#no_inc_hlsearch        = get(g: , 'incsearch#no_inc_hlsearch'        , s:FALSE)
" This changes error and warning emulation way slightly
let g:incsearch#do_not_save_error_message_history =
\   get(g:, 'incsearch#do_not_save_error_message_history', s:FALSE)
let g:incsearch#auto_nohlsearch = get(g: , 'incsearch#auto_nohlsearch' , s:FALSE)
" assert g:incsearch#magic =~# \\[mMvV]
let g:incsearch#magic           = get(g: , 'incsearch#magic'           , '')

" Debug:
let g:incsearch#debug = get(g:, 'incsearch#debug', s:FALSE)

" Utility:
let s:U = incsearch#util#import()

" Main: {{{

" @return vital-over command-line interface object. [experimental]
function! incsearch#cli() abort
  return incsearch#cli#get()
endfunction

"" Make vital-over command-line interface object and return it [experimental]
function! incsearch#make(...) abort
  return incsearch#cli#make(incsearch#config#make(get(a:, 1, {})))
endfunction

"" NOTE: this global variable is only for handling config from go_wrap func
" It avoids to make config string temporarily
let g:incsearch#_go_config = {}

"" This is main API assuming used by <expr> mappings
" ARGS:
"   @config See autoload/incsearch/config.vim
" RETURN:
"   Return primitive search commands (like `3/pattern<CR>`) if config.is_expr
"   is TRUE, return excute command to call incsearch.vim's inner API.
"   To handle dot repeat, make sure that config.is_expr is true. If you do not
"   specify config.is_expr, it automatically set config.is_expr TRUE for
"   operator-pending mode
" USAGE:
"   :noremap <silent><expr> <Plug>(incsearch-forward)  incsearch#go({'command': '/'})
"   " FIXME?: Calling this with feedkeys() is ugly... Reason: incsearch#go()
"   is optimize the situation which calling from <expr> mappings, and do not
"   take care from calling directly or some defined command.
"   :call feedkeys(incsearch#go(), 'n')
" @api
function! incsearch#go(...) abort
  let config = incsearch#config#make(get(a:, 1, {}))
  " FIXME?: this condition should not be config.is_expr?
  if config.is_expr
    return incsearch#_go(config)
  else
    let g:incsearch#_go_config = config
    let esc = s:U.is_visual(g:incsearch#_go_config.mode) ? "\<ESC>" : ''
    return printf("%s:\<C-u>call incsearch#_go(g:incsearch#_go_config)\<CR>", esc)
  endif
endfunction

"" Debuggin incsearch.vim interface for calling from function call
" USAGE:
"   :call incsearch#call({'pattern': @/})
" @api for debugging
function! incsearch#call(...) abort
  return incsearch#_go(incsearch#config#make(get(a:, 1, {})))
endfunction

" IMPORTANT NOTE:
"   Calling `incsearch#go()` and executing command which returned from
"   `incsearch#go()` have to result in the same cursor move.
" @return command: String to search
function! incsearch#_go(config) abort
  if s:U.is_visual(a:config.mode) && !a:config.is_expr
    normal! gv
  endif
  let cli = incsearch#cli#make(a:config)
  let input = s:get_input(cli)
  if cli._does_exit_from_incsearch
    " Outer incsearch-plugin handle it so do not something in paticular
    return cli._return_cmd
  else
    " After getting input, generate command, take aftercare, and return
    " command.
    let l:F = function(cli._flag is# 'n' ? 's:stay' : 's:search')
    let cmd = l:F(cli, input)
    if !a:config.is_expr
      let should_set_jumplist = (cli._flag !=# 'n')
      call s:set_search_related_stuff(cli, cmd, should_set_jumplist)
      if a:config.mode is# 'no'
        call s:set_vimrepeat(cmd)
      endif
    endif
    return cmd
  endif
endfunction

"" To handle recursive mapping, map command to <Plug>(_incsearch-dotrepeat)
" temporarily
" https://github.com/tpope/vim-repeat
" https://github.com/kana/vim-repeat
function! s:set_vimrepeat(cmd) abort
  execute 'noremap' '<Plug>(_incsearch-dotrepeat)' a:cmd
  silent! call repeat#set("\<Plug>(_incsearch-dotrepeat)")
endfunction

let g:incsearch#_view = get(g:, 'incsearch#_view', {})
noremap  <silent> <Plug>(_incsearch-winrestview) <Nop>
noremap! <silent> <Plug>(_incsearch-winrestview) <Nop>
nnoremap <silent> <Plug>(_incsearch-winrestview) :<C-u>call winrestview(g:incsearch#_view)<CR>
xnoremap <silent> <Plug>(_incsearch-winrestview) :<C-u>call winrestview(g:incsearch#_view)<CR>gv

function! s:stay(cli, input) abort
  let [raw_pattern, offset] = a:cli._parse_pattern()
  let pattern = a:cli._convert(raw_pattern)

  " NOTE: do not move cursor but need to handle {offset} for n & N ...! {{{
  " FIXME: cannot set {offset} if in operator-pending mode because this
  " have to use feedkeys()
  let is_cancel = a:cli.exit_code()
  if is_cancel
    call s:cleanup_cmdline()
  elseif !empty(offset) && mode(1) !=# 'no'
    let cmd = incsearch#with_ignore_foldopen(
    \   s:U.dictfunction(a:cli._generate_command, a:cli), a:input)
    call feedkeys(cmd, 'n')
    let g:incsearch#_view = a:cli._w
    call feedkeys("\<Plug>(_incsearch-winrestview)", 'm')
    call incsearch#autocmd#auto_nohlsearch(2)
  else
    " Handle last-pattern
    if a:input isnot# ''
      call histadd('/', a:input)
      call s:set_search_reg(pattern, a:cli._base_key)
    endif
    call incsearch#autocmd#auto_nohlsearch(0)
  endif
  " }}}
  return s:U.is_visual(a:cli._mode) ? "\<ESC>gv" : "\<ESC>" " just exit
endfunction

function! s:search(cli, input) abort
  call incsearch#autocmd#auto_nohlsearch(1) " NOTE: `.` repeat doesn't handle this
  return a:cli._generate_command(a:input)
endfunction

function! s:get_input(cli) abort
  " Handle visual mode highlight
  if s:U.is_visual(a:cli._mode)
    let visual_hl = incsearch#highlight#get_visual_hlobj()
    try
      call incsearch#highlight#turn_off(visual_hl)
      call incsearch#highlight#emulate_visual_highlight(a:cli._mode, visual_hl)
      let input = a:cli.get(a:cli._pattern)
    finally
      call incsearch#highlight#turn_on(visual_hl)
    endtry
  else
    let input = a:cli.get(a:cli._pattern)
  endif
  return input
endfunction

" Assume the cursor move is already done.
" This function handle search related stuff which doesn't be set by :execute
" in function like @/, hisory, jumplist, offset, error & warning emulation.
function! s:set_search_related_stuff(cli, cmd, ...) abort
  " For stay motion
  let should_set_jumplist = get(a:, 1, s:TRUE)
  let is_cancel = a:cli.exit_code()
  if is_cancel
    " Restore cursor position and return
    " NOTE: Should I request on_cancel event to vital-over and use it?
    call winrestview(a:cli._w)
    call s:cleanup_cmdline()
    return
  endif
  let [raw_pattern, offset] = a:cli._parse_pattern()
  let should_execute = !empty(offset) || empty(raw_pattern)
  if should_execute
    " Execute with feedkeys() to work with
    "  1. :h {offset} for `n` and `N`
    "  2. empty input (:h last-pattern)
    "  NOTE: Don't use feedkeys() as much as possible to avoid flickering
    call winrestview(a:cli._w)
    call feedkeys(a:cmd, 'n')
    if g:incsearch#consistent_n_direction
      call feedkeys("\<Plug>(_incsearch-searchforward)", 'm')
    endif
  else
    " Add history if necessary
    " Do not save converted pattern to history
    let pattern = a:cli._convert(raw_pattern)
    let input = a:cli._combine_pattern(raw_pattern, offset)
    call histadd(a:cli._base_key, input)
    call s:set_search_reg(pattern, a:cli._base_key)

    let target_view = winsaveview()
    call winrestview(a:cli._w) " Get back start position temporarily for emulation
    " Set jump list
    if should_set_jumplist
      normal! m`
    endif
    " Emulate errors, and handling `n` and `N` preparation
    call s:emulate_search_error(a:cli._direction, a:cli._w)

    " winrestview() between error and wraning emulation to avoid flickering
    call winrestview(target_view)

    " Emulate warning
    call s:emulate_search_warning(a:cli._direction, a:cli._w, target_view)

    call s:silent_after_search()

    " Open fold
    if &foldopen =~# '\vsearch|all'
      normal! zv
    endif
  endif
endfunction


"}}}

" Helper: {{{
" @return [pattern, offset]
function! incsearch#parse_pattern(expr, search_key) abort
  " search_key : '/' or '?'
  " expr       : {pattern\/pattern}/{offset}
  " expr       : {pattern}/;/{newpattern} :h //;
  " return     : [{pattern\/pattern}, {offset}]
  let very_magic = '\v'
  let pattern  = '(%(\\.|.){-})'
  let slash = '(\' . a:search_key . '&[^\\"|[:alnum:][:blank:]])'
  let offset = '(.*)'

  let parse_pattern = very_magic . pattern . '%(' . slash . offset . ')?$'
  let result = matchlist(a:expr, parse_pattern)[1:3]
  if type(result) == type(0) || empty(result)
    return []
  endif
  unlet result[1]
  return result
endfunction

function! incsearch#detect_case(pattern) abort
  " Ignore \%C, \%U, \%V for smartcase detection
  let p = substitute(a:pattern, s:non_escaped_backslash . '%[CUV]', '', 'g')
  " Explicit \c has highest priority
  if p =~# s:non_escaped_backslash . 'c'
    return '\c'
  endif
  if p =~# s:non_escaped_backslash . 'C' || &ignorecase == s:FALSE
    return '\C' " noignorecase or explicit \C
  endif
  if &smartcase == s:FALSE
    return '\c' " ignorecase & nosmartcase
  endif
  " Find uppercase letter which isn't escaped
  if p =~# s:escaped_backslash . '[A-Z]'
    return '\C' " smartcase with [A-Z]
  else
    return '\c' " smartcase without [A-Z]
  endif
endfunction

function! s:silent_after_search(...) abort " arg: mode(1)
  " :h function-search-undo
  let m = get(a:, 1, mode(1))
  if m !=# 'no' " guard for operator-mapping
    let cmd = join([
    \   (s:U.is_visual(m) ? "\<Plug>(_incsearch-esc)" : ''),
    \   "\<Plug>(_incsearch-hlsearch)",
    \   "\<Plug>(_incsearch-searchforward)",
    \   (s:U.is_visual(m) ? "\<Plug>(_incsearch-gv)" : '')
    \ ], '')
    call feedkeys(cmd, 'm')
  endif
endfunction

noremap  <silent> <Plug>(_incsearch-gv) <Nop>
noremap! <silent> <Plug>(_incsearch-gv) <Nop>
nnoremap <silent> <Plug>(_incsearch-gv) gv

noremap  <silent> <Plug>(_incsearch-esc) <Nop>
noremap! <silent> <Plug>(_incsearch-esc) <Nop>
xnoremap <silent> <Plug>(_incsearch-esc) <Esc>

noremap  <silent> <Plug>(_incsearch-hlsearch) <Nop>
noremap! <silent> <Plug>(_incsearch-hlsearch) <Nop>
nnoremap <silent> <Plug>(_incsearch-hlsearch) :<C-u>let &hlsearch=&hlsearch<CR>
xnoremap <silent> <Plug>(_incsearch-hlsearch) :<C-u>let &hlsearch=&hlsearch<CR>gv

noremap  <silent>       <Plug>(_incsearch-searchforward) <Nop>
noremap! <silent>       <Plug>(_incsearch-searchforward) <Nop>
nnoremap <silent><expr> <Plug>(_incsearch-searchforward) <SID>_searchforward_cmd()
xnoremap <silent><expr> <Plug>(_incsearch-searchforward) <SID>_searchforward_cmd()
function! s:_searchforward_cmd() abort
  let d = (g:incsearch#consistent_n_direction ? s:DIRECTION.forward : (incsearch#cli()._base_key is# '/' ? 1 : 0))
  return printf(":\<C-u>let v:searchforward=%d\<CR>", d)
endfunction

function! s:emulate_search_error(direction, ...) abort
  let from = get(a:, 1, winsaveview())
  let keyseq = (a:direction == s:DIRECTION.forward ? '/' : '?')
  let old_errmsg = v:errmsg
  let v:errmsg = ''
  " NOTE:
  "   - XXX: Handle `n` and `N` preparation with s:silent_after_search()
  "   - silent!: Do not show error and warning message, because it also
  "     echo v:throwpoint for error and save messages in message-history
  "   - Unlike v:errmsg, v:warningmsg doesn't set if it use :silent!
  " Get first error
  silent! call incsearch#execute_search(keyseq . "\<CR>")
  call winrestview(from)
  if g:incsearch#do_not_save_error_message_history
    if v:errmsg !=# ''
      call s:Error(v:errmsg)
    else
      let v:errmsg = old_errmsg
    endif
  else
    " NOTE: show more than two errors e.g. `/\za`
    let last_error = v:errmsg
    try
      " Do not use silent! to show warning
      call incsearch#execute_search(keyseq . "\<CR>")
    catch /^Vim\%((\a\+)\)\=:E/
      let first_error = matchlist(v:exception, '\v^Vim%(\(\a+\))=:(E.*)$')[1]
      call s:Error(first_error, 'echom')
      if last_error !=# '' && last_error !=# first_error
        call s:Error(last_error, 'echom')
      endif
    finally
      call winrestview(from)
    endtry
    if v:errmsg ==# ''
      let v:errmsg = old_errmsg
    endif
  endif
endfunction

function! s:emulate_search_warning(direction, from, to) abort
  " NOTE:
  " - It should use :h echomsg considering emulation of default
  "   warning messages remain in the :h message-history, but it'll mess
  "   up the message-history unnecessary, so it use :h echo
  " - See :h shortmess
  " if &shortmess !~# 's' && g:incsearch#do_not_save_error_message_history
  if &shortmess !~# 's' && g:incsearch#do_not_save_error_message_history
    let from = [a:from.lnum, a:from.col]
    let to = [a:to.lnum, a:to.col]
    let old_warningmsg = v:warningmsg
    let v:warningmsg =
    \   ( a:direction == s:DIRECTION.forward && !s:U.is_pos_less_equal(from, to)
    \   ? 'search hit BOTTOM, continuing at TOP'
    \   : a:direction == s:DIRECTION.backward && s:U.is_pos_less_equal(from, to)
    \   ? 'search hit TOP, continuing at BOTTOM'
    \   : '' )
    if v:warningmsg !=# ''
      call s:Warning(v:warningmsg)
    else
      let v:warningmsg = old_warningmsg
    endif
  endif
endfunction

function! s:cleanup_cmdline() abort
  redraw | echo ''
endfunction

" Should I use :h echoerr ? But it save the messages in message-history
function! s:Error(msg, ...) abort
  return call(function('s:_echohl'), [a:msg, 'ErrorMsg'] + a:000)
endfunction

function! s:Warning(msg, ...) abort
  return call(function('s:_echohl'), [a:msg, 'WarningMsg'] + a:000)
endfunction

function! s:_echohl(msg, hlgroup, ...) abort
  let echocmd = get(a:, 1, 'echo')
  redraw | echo ''
  exec 'echohl' a:hlgroup
  exec echocmd string(a:msg)
  echohl None
endfunction

" Not to generate command with zv
function! incsearch#with_ignore_foldopen(F, ...) abort
  let foldopen_save = &foldopen
  let &foldopen=''
  try
    return call(a:F, a:000)
  finally
    let &foldopen = foldopen_save
  endtry
endfunction

" Try to avoid side-effect as much as possible except cursor movement
let s:has_keeppattern = v:version > 704 || v:version == 704 && has('patch083')
let s:keeppattern = (s:has_keeppattern ? 'keeppattern' : '')
function! s:_execute_search(cmd) abort
  " :nohlsearch
  "   Please do not highlight at the first place if you set back
  "   info! I'll handle it myself :h function-search-undo
  execute s:keeppattern 'keepjumps' 'normal!' a:cmd | nohlsearch
endfunction
if s:has_keeppattern
  function! incsearch#execute_search(...) abort
    return call(function('s:_execute_search'), a:000)
  endfunction
else
  function! incsearch#execute_search(...) abort
    " keeppattern emulation
    let p = @/
    let r = call(function('s:_execute_search'), a:000)
    " NOTE: `let @/ = p` reset v:searchforward
    let d = v:searchforward
    let @/ = p
    let v:searchforward = d
    return r
  endfunction
endif

function! incsearch#magic() abort
  let m = g:incsearch#magic
  return (len(m) == 2 && m =~# '\\[mMvV]' ? m : '')
endfunction

" s:set_search_reg() set pattern to @/ with ?\? handling
" @command '/' or '?'
function! s:set_search_reg(pattern, command) abort
  let @/ = a:command is# '?'
  \ ? substitute(a:pattern, '\\?', '?', 'g') : a:pattern
endfunction

"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
" }}}
