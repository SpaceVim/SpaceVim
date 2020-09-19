let s:save_cpo = &cpo
set cpo&vim

" constants
let s:ON_NVIM = has('nvim')

" configurations
let g:clever_f_across_no_line          = get(g:, 'clever_f_across_no_line', 0)
let g:clever_f_ignore_case             = get(g:, 'clever_f_ignore_case', 0)
let g:clever_f_use_migemo              = get(g:, 'clever_f_use_migemo', 0)
let g:clever_f_fix_key_direction       = get(g:, 'clever_f_fix_key_direction', 0)
let g:clever_f_show_prompt             = get(g:, 'clever_f_show_prompt', 0)
let g:clever_f_smart_case              = get(g:, 'clever_f_smart_case', 0)
let g:clever_f_chars_match_any_signs   = get(g:, 'clever_f_chars_match_any_signs', '')
let g:clever_f_mark_cursor             = get(g:, 'clever_f_mark_cursor', 1)
let g:clever_f_hide_cursor_on_cmdline  = get(g:, 'clever_f_hide_cursor_on_cmdline', 1)
let g:clever_f_timeout_ms              = get(g:, 'clever_f_timeout_ms', 0)
let g:clever_f_mark_char               = get(g:, 'clever_f_mark_char', 1)
let g:clever_f_repeat_last_char_inputs = get(g:, 'clever_f_repeat_last_char_inputs', ["\<CR>"])
let g:clever_f_mark_direct             = get(g:, 'clever_f_mark_direct', 0)

" below variable must be set before loading this script
let g:clever_f_clean_labels_eagerly    = get(g:, 'clever_f_clean_labels_eagerly', 1)

" highlight labels
augroup plugin-clever-f-highlight
    autocmd!
    autocmd ColorScheme * highlight default CleverFDefaultLabel ctermfg=red ctermbg=NONE cterm=bold,underline guifg=red guibg=NONE gui=bold,underline
augroup END
highlight default CleverFDefaultLabel ctermfg=red ctermbg=NONE cterm=bold,underline guifg=red guibg=NONE gui=bold,underline

" Priority of highlight customization is:
"   High:   When g:clever_f_*_color
"   Middle: :highlight in a colorscheme
"   Low:    Default highlights
" When the variable is defined, it should be linked with :hi! since :hi does
" not overwrite existing highlight group. (#50)
if g:clever_f_mark_cursor
    if exists('g:clever_f_mark_cursor_color')
        execute 'highlight! link CleverFCursor' g:clever_f_mark_cursor_color
    else
        highlight link CleverFCursor Cursor
    endif
endif
if g:clever_f_mark_char
    if exists('g:clever_f_mark_char_color')
        execute 'highlight! link CleverFChar' g:clever_f_mark_char_color
    else
        highlight link CleverFChar CleverFDefaultLabel
    endif
endif
if g:clever_f_mark_direct
    if exists('g:clever_f_mark_direct_color')
        execute 'highlight! link CleverFDirect' g:clever_f_mark_direct_color
    else
        highlight link CleverFDirect CleverFDefaultLabel
    endif
endif

if g:clever_f_clean_labels_eagerly
    augroup plugin-clever-f-permanent-finalizer
        autocmd!
        autocmd WinEnter,WinLeave,CmdWinLeave * if g:clever_f_mark_char | call s:remove_highlight() | endif
    augroup END
endif
augroup plugin-clever-f-finalizer
    autocmd!
augroup END

" initialize the internal state
let s:last_mode = ''
let s:previous_map = {}
let s:previous_pos = {}
let s:first_move = {}
let s:migemo_dicts = {}
let s:previous_char_num = {}
let s:timestamp = [0, 0]

" keys are mode string returned from mode()
function! clever_f#reset() abort
    let s:previous_map = {}
    let s:previous_pos = {}
    let s:first_move = {}
    let s:migemo_dicts = {}

    " Note:
    " [0, 0] may be invalid because the representation of return value of reltime() depends on implementation.
    let s:timestamp = [0, 0]

    call s:remove_highlight()

    return ''
endfunction

" hidden API for debug
function! clever_f#_reset_all() abort
    call clever_f#reset()
    let s:last_mode = ''
    let s:previous_char_num = {}
    autocmd! plugin-clever-f-finalizer
    unlet! s:moved_forward

    return ''
endfunction

function! s:remove_highlight() abort
    for h in filter(getmatches(), 'v:val.group ==# "CleverFChar"')
        call matchdelete(h.id)
    endfor
endfunction

function! s:is_timedout() abort
    let cur = reltime()
    let rel = reltimestr(reltime(s:timestamp, cur))
    let elapsed_ms = float2nr(str2float(rel) * 1000.0)
    let s:timestamp = cur
    return elapsed_ms > g:clever_f_timeout_ms
endfunction

" highlight characters to which the cursor can be moved directly
function! s:mark_direct(forward, count) abort
    let line = getline('.')
    let [_, l, c, _] = getpos('.')

    if (a:forward && c == len(line)) || (!a:forward && c == 1)
        " there is no matching characters
        return []
    endif

    if g:clever_f_ignore_case
        let line = tolower(line)
    endif

    let char_count = {}
    let matches = []
    let indices = a:forward ? range(c, len(line) - 1, 1) : range(c - 2, 0, -1)
    for i in indices
        let ch = line[i]
        " only matches to ASCII
        if ch !~# '^[\x00-\x7F]$' | continue | endif
        let ch_lower = tolower(ch)

        let char_count[ch] = get(char_count, ch, 0) + 1
        if g:clever_f_smart_case && ch =~# '\u'
            " uppercase characters are doubly counted
            let char_count[ch_lower] = get(char_count, ch_lower, 0) + 1
        endif

        if char_count[ch] == a:count ||
            \ (g:clever_f_smart_case && char_count[ch_lower] == a:count)
            " NOTE: should not use `matchaddpos(group, [...position])`,
            " because the maximum number of position is 8
            let m = matchaddpos('CleverFDirect', [[l, i + 1]])
            call add(matches, m)
        endif
    endfor
    return matches
endfunction

" introduce public function for test
function! clever_f#_mark_direct(forward, count) abort
    return s:mark_direct(a:forward, a:count)
endfunction

function! s:mark_char_in_current_line(map, char) abort
    let regex = '\%' . line('.') . 'l' . s:generate_pattern(a:map, a:char)
    call matchadd('CleverFChar', regex , 999)
endfunction

" Note:
" \x80\xfd` seems to be sent by a terminal.
" Below is a workaround for the sequence.
function! s:getchar() abort
    while 1
        let cn = getchar()
        if type(cn) != type('') || cn !=# "\x80\xfd`"
            return cn
        endif
    endwhile
endfunction

function! s:include_multibyte_char(str) abort
    return strlen(a:str) != clever_f#compat#strchars(a:str)
endfunction

function! clever_f#find_with(map) abort
    if a:map !~# '^[fFtT]$'
        throw "Error: Invalid mapping '" . a:map . "'"
    endif

    if &foldopen =~# '\<\%(all\|hor\)\>'
        while foldclosed(line('.')) >= 0
            foldopen
        endwhile
    endif

    let current_pos = getpos('.')[1 : 2]

    let mode = s:mode()
    if current_pos != get(s:previous_pos, mode, [0, 0])
        let back = 0
        if g:clever_f_mark_cursor
            let cursor_marker = matchadd('CleverFCursor', '\%#', 999)
            redraw
        endif
        " block-NONE does not work on Neovim
        if g:clever_f_hide_cursor_on_cmdline && !s:ON_NVIM
            let guicursor_save = &guicursor
            set guicursor=n-o:block-NONE
            let t_ve_save = &t_ve
            set t_ve=
        endif
        try
            if g:clever_f_mark_direct
                let direct_markers = s:mark_direct(a:map =~# '\l', v:count1)
                redraw
            endif
            if g:clever_f_show_prompt | echon 'clever-f: ' | endif
            let s:previous_map[mode] = a:map
            let s:first_move[mode] = 1
            let cn = s:getchar()
            if cn == char2nr("\<Esc>")
                return "\<Esc>"
            endif
            if index(map(deepcopy(g:clever_f_repeat_last_char_inputs), 'char2nr(v:val)'), cn) == -1
                let s:previous_char_num[mode] = cn
            else
                if has_key(s:previous_char_num, s:last_mode)
                    let s:previous_char_num[mode] = s:previous_char_num[s:last_mode]
                else
                    echohl ErrorMsg | echo 'Previous input not found.' | echohl None
                    return ''
                endif
            endif
            let s:last_mode = mode

            if g:clever_f_timeout_ms > 0
                let s:timestamp = reltime()
            endif

            if g:clever_f_mark_char
                call s:remove_highlight()
                if mode ==# 'n' || mode ==? 'v' || mode ==# "\<C-v>" ||
                 \ mode ==# 'ce' || mode ==? 's' || mode ==# "\<C-s>"
                    augroup plugin-clever-f-finalizer
                        autocmd CursorMoved <buffer> call s:maybe_finalize()
                        autocmd InsertEnter <buffer> call s:finalize()
                    augroup END
                    call s:mark_char_in_current_line(s:previous_map[mode], s:previous_char_num[mode])
                endif
            endif

            if g:clever_f_show_prompt | redraw! | endif
        finally
            if g:clever_f_mark_cursor | call matchdelete(cursor_marker) | endif
            if g:clever_f_mark_direct
                for m in direct_markers
                    call matchdelete(m)
                endfor
            endif
            if g:clever_f_hide_cursor_on_cmdline && !s:ON_NVIM
                " Set default value at first then restore (#49)
                " For example, when the value is a:blinkon0, it does not affect cursor shape so cursor
                " shape continues to disappear.
                set guicursor&

                if &guicursor !=# guicursor_save
                    let &guicursor = guicursor_save
                endif
                let &t_ve = t_ve_save
            endif
        endtry
    else
        " when repeated
        let back = a:map =~# '\u'
        if g:clever_f_fix_key_direction
            let back = s:previous_map[mode] =~# '\u' ? !back : back
        endif

        " reset and retry if timed out
        if g:clever_f_timeout_ms > 0 && s:is_timedout()
            call clever_f#reset()
            return clever_f#find_with(a:map)
        endif
    endif

    return clever_f#repeat(back)
endfunction

function! clever_f#repeat(back) abort
    let mode = s:mode()
    let pmap = get(s:previous_map, mode, '')
    let prev_char_num = get(s:previous_char_num, mode, 0)

    if pmap ==# ''
        return ''
    endif

    " ignore special characters like \<Left>
    if type(prev_char_num) == type('') && char2nr(prev_char_num) == 128
        return ''
    endif

    if a:back
        let pmap = s:swapcase(pmap)
    endif

    if mode[0] ==? 'v' || mode[0] ==# "\<C-v>"
        let cmd = s:move_cmd_for_visualmode(pmap, prev_char_num)
    else
        let inclusive = mode ==# 'no' && pmap =~# '\l'
        let cmd = printf("%s:\<C-u>call clever_f#find(%s, %s)\<CR>",
                    \    inclusive ? 'v' : '',
                    \    string(pmap), prev_char_num)
    endif

    return cmd
endfunction

" absolutely moved forward?
function! s:moves_forward(p, n) abort
    if a:p[0] != a:n[0]
        return a:p[0] < a:n[0]
    endif

    if a:p[1] != a:n[1]
        return a:p[1] < a:n[1]
    endif

    return 0
endfunction

function! clever_f#find(map, char_num) abort
    let before_pos = getpos('.')[1 : 2]
    let next_pos = s:next_pos(a:map, a:char_num, v:count1)
    if next_pos == [0, 0]
        return
    endif

    let moves_forward = s:moves_forward(before_pos, next_pos)

    " update highlight when cursor moves across lines
    let mode = s:mode()
    if g:clever_f_mark_char
        if next_pos[0] != before_pos[0]
            \ || (a:map ==? 't' && !s:first_move[mode] && clever_f#compat#xor(s:moved_forward, moves_forward))
            call s:remove_highlight()
            call s:mark_char_in_current_line(a:map, a:char_num)
        endif
    endif

    let s:moved_forward = moves_forward
    let s:previous_pos[mode] = next_pos
    let s:first_move[mode] = 0
endfunction

function! s:finalize() abort
    autocmd! plugin-clever-f-finalizer
    call s:remove_highlight()
    let s:previous_pos = {}
    let s:moved_forward = 0
endfunction

function! s:maybe_finalize() abort
    let pp = get(s:previous_pos, s:last_mode, [0, 0])
    if getpos('.')[1 : 2] != pp
        call s:finalize()
    endif
endfunction

function! s:move_cmd_for_visualmode(map, char_num) abort
    let next_pos = s:next_pos(a:map, a:char_num, v:count1)
    if next_pos == [0, 0]
        return ''
    endif

    let m = s:mode()
    call setpos("''", [0] + next_pos + [0])
    let s:previous_pos[m] = next_pos
    let s:first_move[m] = 0

    return '``'
endfunction

function! s:search(pat, flag) abort
    if g:clever_f_across_no_line
        return search(a:pat, a:flag, line('.'))
    else
        return search(a:pat, a:flag)
    endif
endfunction

function! s:should_use_migemo(char) abort
    if !g:clever_f_use_migemo || a:char !~# '^\a$'
        return 0
    endif

    if !g:clever_f_across_no_line
        return 1
    endif

    return s:include_multibyte_char(getline('.'))
endfunction

function! s:load_migemo_dict() abort
    let enc = &l:encoding
    if enc ==# 'utf-8'
        return clever_f#migemo#utf8#load_dict()
    elseif enc ==# 'cp932'
        return clever_f#migemo#cp932#load_dict()
    elseif enc ==# 'euc-jp'
        return clever_f#migemo#eucjp#load_dict()
    else
        let g:clever_f_use_migemo = 0
        throw 'Error: ' . enc . ' is not supported. Migemo is disabled.'
    endif
endfunction

function! s:generate_pattern(map, char_num) abort
    let char = type(a:char_num) == type(0) ? nr2char(a:char_num) : a:char_num
    let regex = char

    let should_use_migemo = s:should_use_migemo(char)
    if should_use_migemo
        if !has_key(s:migemo_dicts, &l:encoding)
            let s:migemo_dicts[&l:encoding] = s:load_migemo_dict()
        endif
        let regex = s:migemo_dicts[&l:encoding][regex] . '\&\%(' . char . '\|\A\)'
    elseif stridx(g:clever_f_chars_match_any_signs, char) != -1
        let regex = '\[!"#$%&''()=~|\-^\\@`[\]{};:+*<>,.?_/]'
    elseif char ==# '\'
        let regex = '\\'
    endif

    let is_exclusive_visual = &selection ==# 'exclusive' && s:mode()[0] ==? 'v'
    if a:map ==# 't' && !is_exclusive_visual
        let regex = '\_.\ze\%(' . regex . '\)'
    elseif is_exclusive_visual && a:map ==# 'f'
        let regex = '\%(' . regex . '\)\zs\_.'
    elseif a:map ==# 'T'
        let regex = '\%(' . regex . '\)\@<=\_.'
    endif

    if !should_use_migemo
        let regex = '\V'.regex
    endif

    return ((g:clever_f_smart_case && char =~# '\l') || g:clever_f_ignore_case ? '\c' : '\C') . regex
endfunction

function! s:next_pos(map, char_num, count) abort
    let mode = s:mode()
    let search_flag = a:map =~# '\l' ? 'W' : 'bW'
    let cnt = a:count
    let pattern = s:generate_pattern(a:map, a:char_num)

    if a:map ==? 't' && get(s:first_move, mode, 1)
        if !s:search(pattern, search_flag . 'c')
            return [0, 0]
        endif
        let cnt -= 1
    endif

    while 0 < cnt
        if !s:search(pattern, search_flag)
            return [0, 0]
        endif
        let cnt -= 1
    endwhile

    return getpos('.')[1 : 2]
endfunction

function! s:swapcase(char) abort
    return a:char =~# '\u' ? tolower(a:char) : toupper(a:char)
endfunction

" Drop forced visual mode character ('nov' -> 'no')
function! s:mode() abort
    let mode = mode(1)
    if mode =~# '^no'
        let mode = mode[0 : 1]
    endif
    return mode
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
