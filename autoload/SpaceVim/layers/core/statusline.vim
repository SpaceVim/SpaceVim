" ============================================================================
" File:        statusline.vim
" Description: SpaceVim core#statusline layer
" Author:      Shidong Wang <wsdjeg@outlook.com>
" Website:     https://spacevim.org
" License:     MIT
" ============================================================================

" statusline
scriptencoding utf-8
let g:_spacevim_statusline_loaded = 1
" APIs
let s:MESSLETTERS = SpaceVim#api#import('messletters')
let s:TIME = SpaceVim#api#import('time')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:STATUSLINE = SpaceVim#api#import('vim#statusline')
let s:VIMCOMP = SpaceVim#api#import('vim#compatible')

" init
let s:separators = {
            \ 'arrow' : ["\ue0b0", "\ue0b2"],
            \ 'curve' : ["\ue0b4", "\ue0b6"],
            \ 'slant' : ["\ue0b8", "\ue0ba"],
            \ 'brace' : ["\ue0d2", "\ue0d4"],
            \ 'fire' : ["\ue0c0", "\ue0c2"],
            \ 'nil' : ['', ''],
            \ }
let s:loaded_modes = ['syntax-checking']
let s:modes = {
            \ 'center-cursor': {
            \ 'icon' : '⊝',
            \ 'desc' : 'centered-cursor mode',
            \ },
            \ 'hi-characters-for-long-lines' :{
            \ 'icon' : '⑧',
            \ 'desc' : 'toggle highlight of characters for long lines',
            \ },
            \ 'fill-column-indicator' :{
            \ 'icon' : s:MESSLETTERS.circled_letter('f'),
            \ 'desc' : 'fill-column-indicator mode',
            \ },
            \ 'syntax-checking' :{
            \ 'icon' : s:MESSLETTERS.circled_letter('s'),
            \ 'desc' : 'syntax-checking mode',
            \ },
            \ 'spell-checking' :{
            \ 'icon' : s:MESSLETTERS.circled_letter('S'),
            \ 'desc' : 'spell-checking mode',
            \ },
            \ }

let s:loaded_sections = ['syntax checking', 'major mode', 'minor mode lighters', 'version control info']

function! s:battery_status() abort
    if executable('acpi')
        return ' ⚡' . substitute(split(system('acpi'))[-1], '%', '%%', 'g') . ' '
    else
        return ''
    endif
endfunction

function! s:search_status() abort
    let ct = 0
    let tt = 0
    let ctl = split(s:VIMCOMP.execute('.,$s/' . @/ . '//gn', 'silent!'), "\n")
    if !empty(ctl)
        let ct = split(ctl[0])[0]
    endif
    let ttl = split(s:VIMCOMP.execute('%s/' . @/ . '//gn', 'silent!'), "\n")
    if !empty(ctl)
        let tt = split(ttl[0])[0]
    endif
    return ' ' . (str2nr(tt) - str2nr(ct) + 1) . '/' . tt . ' '
endfunction

function! s:time() abort
    return ' ' . s:TIME.current_time() . ' '
endfunction

if g:spacevim_enable_neomake
    function! s:syntax_checking()
        if !exists('g:loaded_neomake')
            return ''
        endif
        let counts = neomake#statusline#LoclistCounts()
        let warnings = get(counts, 'W', 0)
        let l =  warnings ?  '%#SpaceVim_statusline_warn#●' . warnings : ''
        let counts = neomake#statusline#LoclistCounts()
        let errors = get(counts, 'E', 0)
        let l .=  errors ?  ' %#SpaceVim_statusline_error#●' . errors : ''
        return l
    endfunction
else
endif

function! s:winnr() abort
    return ' ' . s:MESSLETTERS.circled_num(winnr(), g:spacevim_buffer_index_type) . ' '
endfunction

function! s:filename() abort
    return (&modified ? ' * ' : ' - ') . s:filesize() . fnamemodify(bufname('%'), ':t') . ' '
endfunction

function! s:git_branch() abort
    if exists('g:loaded_fugitive')
        let l:head = fugitive#head()
        return empty(l:head) ? '' : '  '.l:head . ' '
    endif
    return ''
endfunction


function! s:modes() abort
    let m = ' ❖ '
    for mode in s:loaded_modes
        let m .= s:modes[mode].icon . ' '
    endfor
    return m
endfunction

function! s:filesize() abort
    let l:size = getfsize(bufname('%'))
    if l:size == 0 || l:size == -1 || l:size == -2
        return ''
    endif
    if l:size < 1024
        return l:size.' bytes '
    elseif l:size < 1024*1024
        return printf('%.1f', l:size/1024.0).'k '
    elseif l:size < 1024*1024*1024
        return printf('%.1f', l:size/1024.0/1024.0) . 'm '
    else
        return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g '
    endif
endfunction

function! SpaceVim#layers#core#statusline#get(...) abort
    if &filetype ==# 'vimfiler'
        return '%#SpaceVim_statusline_a#' . s:winnr() . '%#SpaceVim_statusline_a_SpaceVim_statusline_b#'
                    \ . '%#SpaceVim_statusline_b# vimfiler %#SpaceVim_statusline_b_SpaceVim_statusline_c#'
    elseif &filetype ==# 'tagbar'
        return '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#'
                    \ . '%#SpaceVim_statusline_b# tagbar %#SpaceVim_statusline_b_c#'
    elseif &filetype ==# 'startify'
        call fugitive#detect(getcwd())
    endif
    if a:0 > 0
        return s:active()
    else
        return s:inactive()
    endif
endfunction

function! s:active() abort
    let lsec = [s:winnr(), s:filename()]
    if index(s:loaded_sections, 'search status') != -1
        call add(lsec, s:search_status())
    endif
    if index(s:loaded_sections, 'major mode') != -1
        call add(lsec, ' ' . &filetype . ' ')
    endif
    let rsec = []
    if index(s:loaded_sections, 'syntax checking') != -1 && s:syntax_checking() != ''
        call add(lsec, s:syntax_checking())
    endif

    if index(s:loaded_sections, 'minor mode lighters') != -1
        call add(lsec, s:modes())
    endif
    if index(s:loaded_sections, 'version control info') != -1
        call add(lsec, s:git_branch())
    endif
    if index(s:loaded_sections, 'battery status') != -1
        call add(rsec, s:battery_status())
    endif
    call add(rsec, '%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}')
    call add(rsec, ' %P ')
    if index(s:loaded_sections, 'time') != -1
        call add(rsec, s:time())
    endif

    return s:STATUSLINE.build(lsec, rsec, s:lsep, s:rsep,
                \ 'SpaceVim_statusline_a', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z')
endfunction

function! s:inactive() abort
    return '%#SpaceVim_statusline_a#' . s:winnr() . '%#SpaceVim_statusline_a_b#'
                \ . '%#SpaceVim_statusline_b#' . s:filename() . ''
                \ . ' ' . &filetype . ' ' 
                \ . s:modes() . ''
                \ . s:git_branch() . ''
                \ . ' %='
                \ . '%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}'
                \ . ' %P '
endfunction
function! s:gitgutter() abort
    if exists('b:gitgutter_summary')
        let l:summary = get(b:, 'gitgutter_summary')
        if l:summary[0] != 0 || l:summary[1] != 0 || l:summary[2] != 0
            return ' +'.l:summary[0].' ~'.l:summary[1].' -'.l:summary[2].' '
        endif
    endif
    return ''
endfunction

function! SpaceVim#layers#core#statusline#init() abort
    augroup status
        autocmd!
        autocmd BufWinEnter,WinEnter * let &l:statusline = SpaceVim#layers#core#statusline#get(1)
        autocmd BufWinLeave,WinLeave * let &l:statusline = SpaceVim#layers#core#statusline#get()
    augroup END
endfunction

function! SpaceVim#layers#core#statusline#def_colors() abort
    hi! SpaceVim_statusline_a ctermbg=003 ctermfg=Black guibg=#a89984 guifg=#282828
    hi! SpaceVim_statusline_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#a89984
    hi! SpaceVim_statusline_c ctermbg=003 ctermfg=Black guibg=#3c3836 guifg=#a89984
    hi! SpaceVim_statusline_z ctermbg=003 ctermfg=Black guibg=#665c54 guifg=#665c54
    hi! SpaceVim_statusline_error ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fb4934 gui=bold
    hi! SpaceVim_statusline_warn ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fabd2f gui=bold
    call s:HI.hi_separator('SpaceVim_statusline_a', 'SpaceVim_statusline_b')
    call s:HI.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_c')
    call s:HI.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_z')
    call s:HI.hi_separator('SpaceVim_statusline_c', 'SpaceVim_statusline_z')
endfunction

function! SpaceVim#layers#core#statusline#toggle_mode(name) abort
    if index(s:loaded_modes, a:name) != -1
        call remove(s:loaded_modes, index(s:loaded_modes, a:name))
    else
        call add(s:loaded_modes, a:name)
    endif
    let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

function! SpaceVim#layers#core#statusline#toggle_section(name) abort
    if index(s:loaded_sections, a:name) != -1
        call remove(s:loaded_sections, index(s:loaded_sections, a:name))
    else
        call add(s:loaded_sections, a:name)
    endif
    let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

function! Test() abort
    echo s:loaded_modes
endfunction

function! SpaceVim#layers#core#statusline#config() abort
    let [s:lsep , s:rsep] = get(s:separators, g:spacevim_statusline_separator, s:separators['arrow'])
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'm'], 'call SpaceVim#layers#core#statusline#toggle_section("minor mode lighters")',
                \ 'toggle the minor mode lighters', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'v'], 'call SpaceVim#layers#core#statusline#toggle_section("version control info")',
                \ 'version control info', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'M'], 'call SpaceVim#layers#core#statusline#toggle_section("major mode")',
                \ 'toggle the major mode', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'b'], 'call SpaceVim#layers#core#statusline#toggle_section("battery status")',
                \ 'toggle the battery status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 't'], 'call SpaceVim#layers#core#statusline#toggle_section("time")',
                \ 'toggle the time', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'T'], 'if &laststatus == 2 | let &laststatus = 0 | else | let &laststatus = 2 | endif',
                \ 'toggle the statuline itself', 1)
    function! TagbarStatusline(a,b,c,d) abort
        return s:STATUSLINE.build([s:winnr(),' Tagbar ', ' ' . a:c . ' '], [], s:lsep, s:rsep,
                    \ 'SpaceVim_statusline_a', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z')
    endfunction
    let g:tagbar_status_func = 'TagbarStatusline'
endfunction
