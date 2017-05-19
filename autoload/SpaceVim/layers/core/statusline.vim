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

" init
let s:separators = {
            \ 'arrow' : ["\ue0b0", "\ue0b2"],
            \ 'curve' : ["\ue0b4", "\ue0b6"],
            \ 'slant' : ["\ue0b8", "\ue0ba"],
            \ 'nil' : ['', '']
            \ }
let s:loaded_modes = ['center-cursor']
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
            \ }

let s:loaded_sections = []

function! s:battery_status() abort
    if executable('acpi')
        return '⚡ ' . substitute(split(system('acpi'))[-1], '%', '%%', 'g')
    else
        return ''
    endif
endfunction

function! s:time() abort
    return s:TIME.current_time()
endfunction

let s:sections = {
            \ 'battery status' : function('s:battery_status'),
            \ }

function! s:winnr() abort
    return s:MESSLETTERS.circled_num(winnr(), g:spacevim_buffer_index_type)
endfunction

function! s:filename() abort
    return (&modified ? ' * ' : ' - ') . s:filesize() . fnamemodify(bufname('%'), ':t')
endfunction

function! s:git_branch() abort
    if exists('g:loaded_fugitive')
        let l:head = fugitive#head()
        return empty(l:head) ? '' : ''.l:head . ' '
    endif
    return ''
endfunction


function! s:modes() abort
    let m = '❖ '
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
        return '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#'
                \ . '%#SpaceVim_statusline_b# vimfiler %#SpaceVim_statusline_b_c#'
    elseif &filetype ==# 'tagbar'
        return '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#'
                \ . '%#SpaceVim_statusline_b# tagbar %#SpaceVim_statusline_b_c#'
    endif
    if a:0 > 0
        return s:active()
    else
        return s:inactive()
    endif
endfunction

function! s:active() abort
    let l = '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#' . s:lsep
                \ . '%#SpaceVim_statusline_b# ' . s:filename() . ' %#SpaceVim_statusline_b_c#' . s:lsep
                \ . '%#SpaceVim_statusline_c# ' . &filetype . ' %#SpaceVim_statusline_c_b#' . s:lsep 
                \ . '%#SpaceVim_statusline_b# ' . s:modes() . ' %#SpaceVim_statusline_b_c#' . s:lsep
                \ . '%#SpaceVim_statusline_c# ' . s:git_branch() . ' %#SpaceVim_statusline_c_z#' . s:lsep
                \ . '%#SpaceVim_statusline_z#%='
    if index(s:loaded_sections, 'battery status') != -1
        let l .= '%#SpaceVim_statusline_z_b#' . s:rsep . '%#SpaceVim_statusline_b# ' . s:battery_status() . ' %#SpaceVim_statusline_c_b#'
    else
        let l .= '%#SpaceVim_statusline_c_z#'
    endif
    let l .= s:rsep . '%#SpaceVim_statusline_c#%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}'
                \ . '%#SpaceVim_statusline_b_c#' . s:rsep . '%#SpaceVim_statusline_b# %P '
    if index(s:loaded_sections, 'time') != -1
        let l .= '%#SpaceVim_statusline_c_b#' . s:rsep . '%#SpaceVim_statusline_c# ' . s:time() . ' '
    endif
    return l
endfunction

function! s:inactive() abort
    return '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#'
                \ . '%#SpaceVim_statusline_b# ' . s:filename() . ' '
                \ . ' ' . &filetype . ' ' 
                \ . ' ' . s:modes() . ' '
                \ . ' ' . s:git_branch() . ' '
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
    hi! SpaceVim_statusline_a_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#a89984
    hi! SpaceVim_statusline_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#a89984
    hi! SpaceVim_statusline_b_c ctermbg=003 ctermfg=Black guibg=#3c3836 guifg=#504945
    hi! SpaceVim_statusline_c ctermbg=003 ctermfg=Black guibg=#3c3836 guifg=#a89984
    hi! SpaceVim_statusline_c_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#3c3836
    hi! SpaceVim_statusline_c_z ctermbg=003 ctermfg=Black guibg=#665c54 guifg=#3c3836
    hi! SpaceVim_statusline_z_c ctermbg=003 ctermfg=Black guibg=#3c3836 guifg=#665c54
    hi! SpaceVim_statusline_z_b ctermbg=003 ctermfg=Black guibg=#665c54 guifg=#504945
    hi! SpaceVim_statusline_z ctermbg=003 ctermfg=Black guibg=#665c54 guifg=#665c54

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
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'b'], 'call SpaceVim#layers#core#statusline#toggle_section("battery status")',
                \ 'toggle the battery status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 't'], 'call SpaceVim#layers#core#statusline#toggle_section("time")',
                \ 'toggle the time', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'T'], 'if &laststatus == 2 | let &laststatus = 0 | else | let &laststatus = 2 | endif',
                \ 'toggle the statuline itself', 1)
endfunction
