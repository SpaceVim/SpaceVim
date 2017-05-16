" statusline
scriptencoding utf-8
let g:_spacevim_statusline_loaded = 1
" APIs
let s:MESSLETTERS = SpaceVim#api#import('messletters')

" init
let s:loaded_modes = ['⊝']
let s:modes = [
            \ {
            \ 'name' : '⊝',
            \ 'desc' : 'centered-cursor mode',
            \ }
            \ ]

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
        let m .= mode . ' '
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
    if a:0 > 0
        return s:active()
    else
        return s:inactive()
    endif
endfunction

function! s:active() abort
    let l:m_r_f = '%7* %m%r%y %*'
    let l:ff = '%8* %{&ff} |'
    let l:enc = " %{''.(&fenc!=''?&fenc:&enc).''} | %{(&bomb?\",BOM\":\"\")}"
    let l:pos = '%l:%c%V %*'
    let l:pct = '%9* %P %*'
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

endfunction
function! s:gitgutter()
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
        autocmd WinEnter * setlocal statusline=%!SpaceVim#layers#core#statusline#get(1)
        autocmd WinLeave * setlocal statusline=%!SpaceVim#layers#core#statusline#get()
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
