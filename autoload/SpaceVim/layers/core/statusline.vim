" statusline
scriptencoding utf-8
let g:_spacevim_statusline_loaded = 1
" APIs
let s:MESSLETTERS = SpaceVim#api#import('messletters')

" init
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
    return '%#SpaceVim_statusline_a# ' . s:winnr() . ' %#SpaceVim_statusline_a_b#'
                \ . '%#SpaceVim_statusline_b# ' . s:filename() . ' %#SpaceVim_statusline_b_c#'
                \ . '%#SpaceVim_statusline_c# ' . &filetype . ' %#SpaceVim_statusline_c_b#' 
                \ . '%#SpaceVim_statusline_b# ' . s:modes() . ' %#SpaceVim_statusline_b_c#'
                \ . '%#SpaceVim_statusline_c# ' . s:git_branch() . ' %#SpaceVim_statusline_c_b#'
                \ . '%#SpaceVim_statusline_b# %='
                \ . '%#SpaceVim_statusline_c_b#%#SpaceVim_statusline_c#%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}'
                \ . '%#SpaceVim_statusline_b_c#%#SpaceVim_statusline_b# %P '

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
endfunction

function! SpaceVim#layers#core#statusline#toggle_mode(name) abort
    if index(s:loaded_modes, a:name) != -1
        call remove(s:loaded_modes, index(s:loaded_modes, a:name))
    else
        call add(s:loaded_modes, a:name)
    endif
    let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

function! Test() abort
    echo s:loaded_modes
endfunction
