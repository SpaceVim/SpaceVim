""
" @section Default, default
" @parentsection layers

function! SpaceVim#layers#default#plugins() abort
    let plugins = []

    return plugins
endfunction

function! SpaceVim#layers#default#config() abort
    " Unimpaired bindings
    " Quickly add empty lines
    nnoremap <silent> [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>
    nnoremap <silent> ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

    "]e or [e move current line ,count can be useed
    nnoremap <silent>[e  :<c-u>execute 'move -1-'. v:count1<cr>
    nnoremap <silent>]e  :<c-u>execute 'move +'. v:count1<cr>

    " [b or ]n go to previous or next buffer
    nnoremap <silent> [b :<c-u>bN<cr>
    nnoremap <silent> ]b :<c-u>bn<cr>

    " [f or ]f go to next or previous file in dir
    nnoremap <silent> ]f :<c-u>call <SID>next_file()<cr>
    nnoremap <silent> [f :<c-u>call <SID>previous_file()<cr>

    call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'], "exe 'CtrlP ' . fnamemodify(bufname('%'), ':h')", 'Find files in the directory of the current buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 's'], 'write', 'save buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'S'], 'wall', 'save all buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'write !sudo tee % >/dev/null', 'save buffer with sudo', 1)
    " help mappings
    call SpaceVim#mapping#space#def('nnoremap', ['h', 'I'], 'call SpaceVim#issue#report()', 'Reporting an issue of SpaceVim', 1)
    if has('python3')
        call SpaceVim#mapping#space#def('nnoremap', ['h', 'i'], 'DeniteCursorWord help', 'get help with the symbol at point', 1)
    else
        call SpaceVim#mapping#space#def('nnoremap', ['h', 'i'], 'UniteWithCursorWord help', 'get help with the symbol at point', 1)
    endif
    call SpaceVim#mapping#space#def('nnoremap', ['h', 'l'], 'SPLayer -l', 'lists all the layers available in SpaceVim', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['h', 'm'], 'Unite manpage', 'search available man pages', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['h', 'k'], 'LeaderGuide "[KEYs]"', 'show top-level bindings with mapping guide', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['h', '[SPC]'], 'Unite help -input=SpaceVim', 'unite-SpaceVim-help', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['j', '0'], 'm`^', 'push mark and goto beginning of line', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', '$'], 'm`g_', 'push mark and goto beginning of line', 0)
endfunction

let s:file = SpaceVim#api#import('file')

function! s:next_file() abort
    let dir = expand('%:p:h')
    let f = expand('%:t')
    let file = s:file.ls(dir, 1)
    if index(file, f) == -1
        call add(file,f)
    endif
    call sort(file)
    if len(file) != 1
        if index(file, f) == len(file) - 1
            exe 'e ' . dir . s:file.separator . file[0]
        else
            exe 'e ' . dir . s:file.separator . file[index(file, f) + 1]
        endif
    endif
endfunction

function! s:previous_file() abort
    let dir = expand('%:p:h')
    let f = expand('%:t')
    let file = s:file.ls(dir, 1)
    if index(file, f) == -1
        call add(file,f)
    endif
    call sort(file)
    if len(file) != 1
        if index(file, f) == 0
            exe 'e ' . dir . s:file.separator . file[-1]
        else
            exe 'e ' . dir . s:file.separator . file[index(file, f) - 1]
        endif
    endif
endfunction
