"=============================================================================
" FILE: autoload/asterisk.vim
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
let s:INT = { 'MAX': 2147483647 }
let s:DIRECTION = { 'forward': 1, 'backward': 0 } " see :h v:searchforward

let g:asterisk#keeppos = get(g:, 'asterisk#keeppos', s:FALSE)

" do_jump: do not move cursor if false
" is_whole: is_whole word. false if `g` flag given (e.g. * -> true, g* -> false)
let s:_config = {
\   'direction' : s:DIRECTION.forward,
\   'do_jump' : s:TRUE,
\   'is_whole' : s:TRUE,
\   'keeppos': s:FALSE
\ }

function! s:default_config() abort
    return extend(deepcopy(s:_config), {'keeppos': g:asterisk#keeppos})
endfunction

" @return command: String
function! asterisk#do(mode, config) abort
    let config = extend(s:default_config(), a:config)
    let is_visual = s:is_visual(a:mode)
    " Raw cword without \<\>
    let cword = (is_visual ? s:get_selected_text() : s:escape_pattern(expand('<cword>')))
    if cword is# ''
        return s:generate_error_cmd(is_visual)
    endif
    " v:count handling
    let should_plus_one_count = s:should_plus_one_count(cword, config, a:mode)
    let maybe_count = (should_plus_one_count ? string(v:count1 + 1) : '')
    let pre = (is_visual || should_plus_one_count ? "\<Esc>" . maybe_count : '')
    " Including \<\> if necessary
    let pattern = (is_visual ?
    \   s:convert_2_word_pattern_4_visual(cword, config) : s:cword_pattern(cword, config))
    let key = (config.direction is s:DIRECTION.forward ? '/' : '?')
    " Get offset in current word
    let offset = config.keeppos ? s:get_pos_in_cword(cword, a:mode) : 0
    let pattern_offseted = pattern . (offset is 0 ? '' : key . 's+' . offset)
    let search_cmd = pre . key . pattern_offseted
    if config.do_jump
        return search_cmd . "\<CR>"
    elseif config.keeppos && offset isnot 0
        "" Do not jump with keeppos feature
        " NOTE: It doesn't move cursor, so we can assume it works with
        " operator pending mode even if it returns command to execute.
        let echo = s:generate_echo_cmd(pattern_offseted)
        let restore = s:generate_restore_cmd()
        "" *premove* & *aftermove* : not to cause flickr as mush as possible
        " flick corner case: `#` with under cursor word at the top of window
        " and the cursor is at the end of the word.
        let premove =
        \   (a:mode isnot# 'n' ? "\<Esc>" : '')
        \   . 'm`'
        \   . (config.direction is s:DIRECTION.forward ? '0' : '$')
        " NOTE: Neovim doesn't stack pos to jumplist after "m`".
        " https://github.com/haya14busa/vim-asterisk/issues/34
        if has('nvim')
            let aftermove = '``'
        else
            let aftermove = "\<C-o>"
        endif
        " NOTE: To avoid hit-enter prompt, it execute `restore` and `echo`
        " command separately. I can also implement one function and call it
        " once instead of separately, should I do this?
        return printf("%s%s\<CR>%s:%s\<CR>:%s\<CR>", premove, search_cmd, aftermove, restore, echo)
    else " Do not jump: Just handle search related
        call s:set_search(pattern)
        return s:generate_set_search_cmd(pattern, a:mode, config)
    endif
endfunction

"" For keeppos feature
" NOTE: To avoid hit-enter prompt, this function name should be as short as
" possible. `r` is short for restore. Should I use more short function using
" basic global function instead of autoload one.
function! asterisk#r() abort
    call winrestview(s:w)
    call s:restore_event_ignore()
endfunction

function! s:set_view(view) abort
    let s:w = a:view
endfunction

"" For keeppos feature
" NOTE: vim-asterisk moves cursor temporarily for keeppos feature with search
" commands. It should not trigger the event related to this cursor move, so
" set eventignore and restore it afterwards.
function! s:set_event_ignore() abort
    let s:ei = &ei
    let events = ['CursorMoved']
    if exists('##CmdlineEnter')
        let events += ['CmdlineEnter', 'CmdlineLeave']
    endif
    let &ei = join(events, ',')
endfunction

function! s:restore_event_ignore() abort
    let &ei = s:ei
endfunction

" @return restore_command: String
function! s:generate_restore_cmd() abort
    call s:set_view(winsaveview())
    call s:set_event_ignore()
    return 'call asterisk#r()'
endfunction

" @return \<cword\> if needed: String
function! s:cword_pattern(cword, config) abort
    return printf((a:config.is_whole && a:cword =~# '\k' ? '\<%s\>' : '%s'), a:cword)
endfunction

" This function is based on https://github.com/thinca/vim-visualstar
" Author  : thinca <thinca+vim@gmail.com>
" License : zlib License
" @return \<selected_pattern\>: String
function! s:convert_2_word_pattern_4_visual(pattern, config) abort
    let text = a:pattern
    let type = (a:config.direction is# s:DIRECTION.forward ? '/' : '?')
    let [pre, post] = ['', '']
    if a:config.is_whole
        let [head_pos, tail_pos] = s:sort_pos([s:getcoord('.'), s:getcoord('v')])
        let head = matchstr(text, '^.')
        let is_head_multibyte = 1 < len(head)
        let [l, col] = head_pos
        let line = getline(l)
        let before = line[: col - 2]
        let outer = matchstr(before, '.$')
        if text =~# '^\k' && ((!empty(outer) && len(outer) != len(head)) ||
        \   (!is_head_multibyte && (col == 1 || before !~# '\k$')))
            let pre = '\<'
        endif
        let tail = matchstr(text, '.$')
        let is_tail_multibyte = 1 < len(tail)
        let [l, col] = tail_pos
        let col += s:is_exclusive() && head_pos[1] !=# tail_pos[1] ? - 1 : len(tail) - 1
        let line = getline(l)
        let after = line[col :]
        let outer = matchstr(after, '^.')
        if text =~# '\k$' && ((!empty(outer) && len(outer) != len(tail)) ||
        \   (!is_tail_multibyte && (col == len(line) || after !~# '^\k')))
            let post = '\>'
        endif
    endif
    let text = substitute(escape(text, '\' . type), "\n", '\\n', 'g')
    let text = substitute(text, "\r", '\\r', 'g')
    return '\V' . pre . text . post
endfunction

"" Set pattern and history for search
" @return nothing
function! s:set_search(pattern) abort
    let @/ = a:pattern
    call histadd('/', @/)
endfunction

"" Generate command to turn on search related option like hlsearch to work
" with :h function-search-undo
" @return command: String
function! s:generate_set_search_cmd(pattern, mode, config) abort
    " :h function-search-undo
    " :h v:hlsearch
    " :h v:searchforward
    let hlsearch = 'let &hlsearch=&hlsearch'
    let searchforward = printf('let v:searchforward = %d', a:config.direction)
    let echo = s:generate_echo_cmd(a:pattern)
    let esc = (a:mode isnot# 'n' ? "\<Esc>" : '')
    return printf("%s:\<C-u>%s\<CR>:%s\<CR>:%s\<CR>", esc, hlsearch, searchforward, echo)
endfunction

" @return echo_command: String
function! s:generate_echo_cmd(message) abort
    return printf('echo "%s"', escape(a:message, '\"'))
endfunction

"" Generate command to show error with empty pattern
" @return error_command: String
function! s:generate_error_cmd(is_visual) abort
    " 'E348: No string under cursor'
    let m = 'asterisk.vim: No selected string'
    return (a:is_visual
    \   ? printf("\<Esc>:echohl ErrorMsg | echom '%s' | echohl None\<CR>", m)
    \   : '*')
endfunction

" @return boolean
function! s:should_plus_one_count(cword, config, mode) abort
    " For backward, because count isn't needed with <expr> but it requires
    " +1 for backward and for the case that cursor is not at the head of
    " cword
    if s:is_visual(a:mode)
        return a:config.direction is# s:DIRECTION.backward ? s:TRUE : s:FALSE
    else
        return a:config.direction is# s:DIRECTION.backward
        \   ? s:get_pos_char() =~# '\k' && ! s:is_head_of_cword(a:cword) && ! a:config.keeppos
        \   : s:get_pos_char() !~# '\k'
    endif
endfunction

" @return boolean
function! s:is_head_of_cword(cword) abort
    return 0 == s:get_pos_in_cword(a:cword)
endfunction

" Assume the current mode is middle of visual mode.
" @return selected text
function! s:get_selected_text(...) abort
    let mode = get(a:, 1, mode(1))
    let end_col = s:curswant() is s:INT.MAX ? s:INT.MAX : s:get_col_in_visual('.')
    let current_pos = [line('.'), end_col]
    let other_end_pos = [line('v'), s:get_col_in_visual('v')]
    let [begin, end] = s:sort_pos([current_pos, other_end_pos])
    if s:is_exclusive() && begin[1] !=# end[1]
        " Decrement column number for :set selection=exclusive
        let end[1] -= 1
    endif
    if mode !=# 'V' && begin ==# end
        let lines = [s:get_pos_char(begin)]
    elseif mode ==# "\<C-v>"
        let [min_c, max_c] = s:sort_num([begin[1], end[1]])
        let lines = map(range(begin[0], end[0]), '
        \   getline(v:val)[min_c - 1 : max_c - 1]
        \ ')
    elseif mode ==# 'V'
        let lines = getline(begin[0], end[0])
    else
        if begin[0] ==# end[0]
            let lines = [getline(begin[0])[begin[1]-1 : end[1]-1]]
        else
            let lines = [getline(begin[0])[begin[1]-1 :]]
            \         + (end[0] - begin[0] < 2 ? [] : getline(begin[0]+1, end[0]-1))
            \         + [getline(end[0])[: end[1]-1]]
        endif
    endif
    return join(lines, "\n") . (mode ==# 'V' ? "\n" : '')
endfunction

" @return Number: return multibyte aware column number in Visual mode to
" select
function! s:get_col_in_visual(pos) abort
    let [pos, other] = [a:pos, a:pos is# '.' ? 'v' : '.']
    let c = col(pos)
    let d = s:compare_pos(s:getcoord(pos), s:getcoord(other)) > 0
    \   ? len(s:get_pos_char([line(pos), c - (s:is_exclusive() ? 1 : 0)])) - 1
    \   : 0
    return c + d
endfunction

function! s:get_multi_col(pos) abort
    let c = col(a:pos)
    return c + len(s:get_pos_char([line(a:pos), c])) - 1
endfunction

" Helper:

function! s:is_visual(mode) abort
    return a:mode =~# "[vV\<C-v>]"
endfunction

" @return Boolean
function! s:is_exclusive() abort
    return &selection is# 'exclusive'
endfunction

function! s:curswant() abort
    return winsaveview().curswant
endfunction

" @return coordinate: [Number, Number]
function! s:getcoord(expr) abort
    return getpos(a:expr)[1:2]
endfunction

"" Return character at given position with multibyte handling
" @arg [Number, Number] as coordinate or expression for position :h line()
" @return String
function! s:get_pos_char(...) abort
    let pos = get(a:, 1, '.')
    let [line, col] = type(pos) is# type('') ? s:getcoord(pos) : pos
    return matchstr(getline(line), '.', col - 1)
endfunction

" @return int index of cursor in cword
function! s:get_pos_in_cword(cword, ...) abort
    return (s:is_visual(get(a:, 1, mode(1))) || s:get_pos_char() !~# '\k') ? 0
    \   : s:count_char(searchpos(a:cword, 'bcn')[1], s:get_multi_col('.'))
endfunction

" multibyte aware
function! s:count_char(from, to) abort
    let chars = getline('.')[a:from-1:a:to-1]
    return len(split(chars, '\zs')) - 1
endfunction

" 7.4.341
" http://ftp.vim.org/vim/patches/7.4/7.4.341
if v:version > 704 || v:version == 704 && has('patch341')
    function! s:sort_num(xs) abort
        return sort(a:xs, 'n')
    endfunction
else
    function! s:_sort_num_func(x, y) abort
        return a:x - a:y
    endfunction
    function! s:sort_num(xs) abort
        return sort(a:xs, 's:_sort_num_func')
    endfunction
endif

function! s:sort_pos(pos_list) abort
    " pos_list: [ [x1, y1], [x2, y2] ]
    return sort(a:pos_list, 's:compare_pos')
endfunction

function! s:compare_pos(x, y) abort
    return max([-1, min([1,(a:x[0] == a:y[0]) ? a:x[1] - a:y[1] : a:x[0] - a:y[0]])])
endfunction

" taken from :h Vital.Prelude.escape_pattern()
function! s:escape_pattern(str) abort
    return escape(a:str, '~"\.^$[]*')
endfunction

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}

