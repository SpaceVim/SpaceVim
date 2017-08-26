""
" @section Default, default
" @parentsection layers

let s:filename = expand('<sfile>:~')

function! SpaceVim#layers#default#plugins() abort
    let plugins = []

    return plugins
endfunction

let s:lnum = expand('<slnum>') + 3
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

    " [l or ]l go to next and previous error
    nnoremap <silent> [l :lprevious<cr>
    nnoremap <silent> ]l :lnext<cr>

    " [c or ]c go to next or previous vcs hunk

    " [w or ]w go to next or previous window
    nnoremap <silent> [w :call <SID>previous_window()<cr>
    nnoremap <silent> ]w :call <SID>next_window()<cr>

    " [t or ]t for next and previous tab
    nnoremap <silent> [t :tabprevious<cr>
    nnoremap <silent> ]t :tabnext<cr>

    " [p or ]p for p and P
    nnoremap <silent> [p P
    nnoremap <silent> ]p p

    " Select last paste
    nnoremap <silent><expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

    let lnum = expand('<slnum>') + s:lnum - 1
    if has('python3')
        let cmd =  'DeniteBufferDir file_rec'
    elseif has('python')
        let cmd =  "exe 'LeaderfFile ' . fnamemodify(bufname('%'), ':h')"
    else
        let cmd =  "exe 'CtrlP ' . fnamemodify(bufname('%'), ':h')"
    endif
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'],
                \ cmd,
                \ ['Find files in the directory of the current buffer',
                \ [
                \ '[SPC f f] is to find files in the directory of the current buffer',
                \ 'vim with +python3 support will use denite',
                \ 'vim with +python support will use leaderf',
                \ 'otherwise will use ctrlp',
                \ '',
                \ 'Definition: ' . s:filename . ':' . lnum,
                \ ]
                \ ]
                \ , 1)
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
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'b'], '<C-o>', 'jump backward', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'f'], '<C-i>', 'jump forward', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'd'], 'VimFiler -no-split', 'Explore current directory', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'D'], 'VimFiler', 'Explore current directory (other window)', 1)
    call SpaceVim#mapping#space#def('nmap', ['j', 'j'], '<Plug>(easymotion-prefix)s', 'jump to a character', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'J'], '<Plug>(easymotion-s2)', 'jump to a suite of two characters', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'k'], 'j==', 'go to next line and indent', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'l'], '<Plug>(easymotion-bd-jk)', 'jump to a line', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'v'], '<Plug>(easymotion-bd-jk)', 'jump to a line', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'w'], '<Plug>(easymotion-bd-w)', 'jump to a word', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'q'], '<Plug>(easymotion-bd-jk)', 'jump to a line', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'n'], "i\<cr>\<esc>", 'sp-newline', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'o'], "i\<cr>\<esc>k$", 'open-line', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 's'], 'call call('
                \ . string(s:_function('s:split_string')) . ', [0])',
                \ 'split sexp', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'S'], 'call call('
                \ . string(s:_function('s:split_string')) . ', [1])',
                \ 'split-and-add-newline', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'r'], 'call call('
                \ . string(s:_function('s:next_window')) . ', [])',
                \ 'rotate windows forward', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'R'], 'call call('
                \ . string(s:_function('s:previous_window')) . ', [])',
                \ 'rotate windows backward', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['j', 'u'], 'call call('
                \ . string(s:_function('s:jump_to_url')) . ', [])',
                \ 'jump to url', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['<Tab>'], 'try | b# | catch | endtry', 'last buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', '.'], 'call call('
                \ . string(s:_function('s:buffer_transient_state')) . ', [])',
                \ 'buffer transient state', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'd'], 'call SpaceVim#mapping#close_current_buffer()', 'kill-this-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'D'],
                \ 'call SpaceVim#mapping#kill_visible_buffer_choosewin()',
                \ 'kill-this-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', '<C-d>'], 'call SpaceVim#mapping#clearBuffers()', 'kill-other-buffers', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'e'], 'call call('
                \ . string(s:_function('s:safe_erase_buffer')) . ', [])',
                \ 'safe-erase-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'h'], 'Startify', 'home', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'm'], 'call call('
                \ . string(s:_function('s:open_message_buffer')) . ', [])',
                \ 'open-message-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'P'], 'normal! ggdG"+P', 'copy-clipboard-to-whole-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'R'], 'call call('
                \ . string(s:_function('s:safe_revert_buffer')) . ', [])',
                \ 'safe-revert-buffer', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'Y'], 'normal! ggVG"+y``', 'copy-whole-buffer-to-clipboard', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'w'], 'setl readonly!', 'read-only-mode', 1)
    let g:_spacevim_mappings_space.b.N = {'name' : '+New empty buffer'}
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'h'], 'topleft vertical new', 'new-empty-buffer-left', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'j'], 'rightbelow new', 'new-empty-buffer-below', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'k'], 'new', 'new-empty-buffer-above', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'l'], 'rightbelow vertical new', 'new-empty-buffer-right', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'n'], 'enew', 'new-empty-buffer', 1)

    " file mappings
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'b'], 'Unite vim_bookmarks', 'unite-filtered-bookmarks', 1)
    let g:_spacevim_mappings_space.f.C = {'name' : '+Files/convert'}
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'd'], 'update | e ++ff=dos | w', 'unix2dos', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'u'], 'update | e ++ff=dos | setlocal ff=unix | w', 'dos2unix', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'D'], 'call call('
                \ . string(s:_function('s:delete_current_buffer_file')) . ', [])',
                \ 'delete-current-buffer-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'F'], 'normal! gf', 'open-cursor-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'Unite file_mru', 'open-recent-file', 1)
    if g:spacevim_filemanager ==# 'vimfiler'
        call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'VimFiler', 'toggle_file_tree', 1)
        call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'VimFiler -no-toggle', 'show_file_tree', 1)
    elseif g:spacevim_filemanager ==# 'nerdtree'
        call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NERDTreeToggle', 'toggle_file_tree', 1)
        call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NERDTree', 'toggle_file_tree', 1)
    endif
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'y'], 'call zvim#util#CopyToClipboard()', 'show-and-copy-buffer-filename', 1)
    let g:_spacevim_mappings_space.f.v = {'name' : '+Vim(SpaceVim)'}
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'v'], 'let @+=g:spacevim_version | echo g:spacevim_version', 'display-and-copy-version', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'd'], 'SPConfig', 'open-custom-configuration', 1)
endfunction

let s:file = SpaceVim#api#import('file')
let s:MESSAGE = SpaceVim#api#import('vim#message')

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

function! s:next_window() abort
    try
        exe (winnr() + 1 ) . 'wincmd w'
    catch
        exe 1 . 'wincmd w'
    endtry
endfunction

function! s:previous_window() abort
    try
        if winnr() == 1
            exe winnr('$') . 'wincmd w'
        else
            exe (winnr() - 1 ) . 'wincmd w'
        endif
    catch
        exe winnr('$') . 'wincmd w'
    endtry
endfunction

function! s:split_string(newline) abort
    let syn_name = synIDattr(synID(line("."), col("."), 1), "name")
    if syn_name == &filetype . 'String'
        let c = col('.')
        let sep = ''
        while c > 0
            if s:is_string(line('.'), c)
                let c = c - 1
            else
                let sep = getline('.')[c]
                break
            endif
        endwhile
        if a:newline
            let save_register_m = @m
            let @m = sep . "\n" . sep
            normal! "mp
            let @m = save_register_m
        else
            let save_register_m = @m
            let @m = sep . sep
            normal! "mp
            let @m = save_register_m
        endif
    endif
endfunction

function! s:is_string(l,c) abort
    return synIDattr(synID(a:l, a:c, 1), "name") == &filetype . 'String'
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
    function! s:_function(fstr) abort
        return function(a:fstr)
    endfunction
else
    function! s:_SID() abort
        return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
    endfunction
    let s:_s = '<SNR>' . s:_SID() . '_'
    function! s:_function(fstr) abort
        return function(substitute(a:fstr, 's:', s:_s, 'g'))
    endfunction
endif

function! s:jump_to_url() abort
    let g:EasyMotion_re_anywhere = 'http[s]*://'
    call feedkeys("\<Plug>(easymotion-jumptoanywhere)")
endfunction

function! s:safe_erase_buffer() abort
    if s:MESSAGE.confirm('Erase content of buffer ' . expand('%:t'))
        normal! ggdG
    endif
    redraw!
endfunction

function! s:open_message_buffer() abort
    vertical topleft edit __Message_Buffer__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonumber norelativenumber
    setf message
    normal! ggdG
    silent put =execute(':message')
    normal! G
    setlocal nomodifiable
    nnoremap <silent> <buffer> q :silent bd<CR>
endfunction

function! s:safe_revert_buffer() abort
    if s:MESSAGE.confirm('Revert buffer form ' . expand('%:p'))
        edit!
    endif
    redraw!
endfunction

function! s:delete_current_buffer_file() abort
    if s:MESSAGE.confirm('Are you sure you want to delete this file')
        let f = fnameescape(expand('%:p'))
        call SpaceVim#mapping#close_current_buffer()
        if delete(f) == 0
            echo "File '" . f . "' successfully removed"
        endif
    endif
    redraw!

endfunction

function! s:swap_buffer_with_nth_win(nr) abort
    if a:nr <= winnr('$') && a:nr != winnr()
        let cb = bufnr('%')
        let tb = winbufnr(a:nr)
        if cb != tb
            exe a:nr . 'wincmd w'
            exe 'b' . cb
            wincmd p
            exe 'b' . tb
        endif
    endif
endfunction

function! s:move_buffer_to_nth_win(nr) abort
    if a:nr <= winnr('$') && a:nr != winnr()
        let cb = bufnr('%')
        bp
        exe a:nr . 'wincmd w'
        exe 'b' . cb
        wincmd p
    endif
endfunction

function! s:buffer_transient_state() abort
    let state = SpaceVim#api#import('transient_state') 
    call state.set_title('Buffer Selection Transient State')
    call state.defind_keys(
                \ {
                \ 'layout' : 'vertical split',
                \ 'left' : [
                \ {
                \ 'key' : {
                \ 'name' : 'C-1..C-9',
                \ 'pos' : [[1,4], [6,9]],
                \ 'handles' : [
                \ ["\<C-1>" , ''],
                \ ["\<C-2>" , ''],
                \ ["\<C-3>" , ''],
                \ ["\<C-4>" , ''],
                \ ["\<C-5>" , ''],
                \ ["\<C-6>" , ''],
                \ ["\<C-7>" , ''],
                \ ["\<C-8>" , ''],
                \ ["\<C-9>" , ''],
                \ ],
                \ },
                \ 'desc' : 'goto nth window',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : {
                \ 'name' : '1..9',
                \ 'pos' : [[1,2], [4,5]],
                \ 'handles' : [
                \ ['1' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [1])'],
                \ ['2' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [2])'],
                \ ['3' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [3])'],
                \ ['4' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [4])'],
                \ ['5' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [5])'],
                \ ['6' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [6])'],
                \ ['7' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [7])'],
                \ ['8' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [8])'],
                \ ['9' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [9])'],
                \ ],
                \ },
                \ 'desc' : 'move buffer to nth window',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : {
                \ 'name' : 'M-1..M-9',
                \ 'pos' : [[1,4], [6,9]],
                \ 'handles' : [
                \ ["\<M-1>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [1])'],
                \ ["\<M-2>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [2])'],
                \ ["\<M-3>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [3])'],
                \ ["\<M-4>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [4])'],
                \ ["\<M-5>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [5])'],
                \ ["\<M-6>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [6])'],
                \ ["\<M-7>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [7])'],
                \ ["\<M-8>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [8])'],
                \ ["\<M-9>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [9])'],
                \ ],
                \ },
                \ 'desc' : 'swap buffer with nth window',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 0,
                \ },
                \ ],
                \ 'right' : [
                \ {
                \ 'key' : 'n',
                \ 'desc' : 'next buffer',
                \ 'func' : '',
                \ 'cmd' : 'bnext',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : ['N', 'p'],
                \ 'desc' : 'previous buffer',
                \ 'func' : '',
                \ 'cmd' : 'bp',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 'd',
                \ 'desc' : 'kill buffer',
                \ 'func' : '',
                \ 'cmd' : 'call SpaceVim#mapping#close_current_buffer()',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 'q',
                \ 'desc' : 'quit',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 1,
                \ },
                \ ],
                \ }
                \ )
    call state.open()
endfunction
