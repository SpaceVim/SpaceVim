let s:TAB = SpaceVim#api#import('vim#tab')

let s:restore_windows_stack = []


function! s:get_window_restore_data() abort
    let win_data = {
                \ 'bufid':  bufnr('%'),
                \ 'tabpagenr': tabpagenr(),
                \ 'view':      winsaveview(),
                \ }
    return win_data
endfunction

function! SpaceVim#plugins#windowsmanager#UpdateRestoreWinInfo() abort
    if !&buflisted
        return
    endif
    let win_data = s:get_window_restore_data()
    if len(tabpagebuflist()) == 1
        let win_data.neighbour_buffer = ''
        let win_data.open_command     = (tabpagenr() - 1).'tabnew'
    endif
    call add(s:restore_windows_stack, win_data)
endfunction

function! SpaceVim#plugins#windowsmanager#UndoQuitWin()
    if empty(s:restore_windows_stack)
        return
    endif
    let win_data = remove(s:restore_windows_stack, -1)
    if win_data.neighbour_buffer != ''
    endif
    exe win_data.open_command . ' | b ' win_data.bufid
endfunction
