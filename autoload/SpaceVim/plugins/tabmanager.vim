scriptencoding utf-8
" APIs
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:TABs = SpaceVim#api#import('vim#tab')

" init val

let s:open_tabs = []


" Interface
function! SpaceVim#plugins#tabmanager#open() abort
    call s:BUFFER.open(
                \ {
                \ 'bufname' : '__Tabmanager__',
                \ 'initfunc' : function('s:init_buffer'),
                \ }
                \ )

    call s:BUFFER.resize(30)
    call s:update_context()
endfunction

" local functions
function! s:init_buffer() abort
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell number norelativenumber
    setf SpaceVimTabsManager
    nnoremap <silent> <buffer> q :bd<CR>
    nnoremap <silent> <buffer> <CR> <esc>:<c-u>cal <SID>jump()<CR>
    nnoremap <silent> <buffer> o :call <SID>toggle()<CR>
endfunction

function! s:update_context() abort
    setl modifiable
    normal! gg"_dG
    let tree = s:TABs.get_tree()
    let ctx = []
    for page in keys(tree)
        if index(s:open_tabs, page) != -1
            call add(ctx, '▼ Tab #' . page)
            for _buf in tree[page]
                if getbufvar(_buf, '&buflisted')
                    call add(ctx, '    ' . _buf . ':' . fnamemodify(bufname(_buf), ':t'))
                endif
            endfor
        else
            call add(ctx, '▷ Tab #' . page)
        endif
    endfor
    call setline(1, ctx)
    setl nomodifiable
endfunction

function! s:jump() abort
    if v:prevcount
        exe 'keepj' v:prevcount
    en
    let t = s:tabid()
    let b = s:bufid()
    q
    call s:TABs._jump(t,b)
endfunction

function! s:tabid() abort
    for i in range(0, line('.'))
        if getline(line('.') - i) =~# '^[▷▼] Tab #'
            return matchstr(getline(line('.') - i), '\d\+$')
        endif
    endfor
endfunction

function! s:bufid() abort
    let id = str2nr(split(getline('.'), ':')[0])
    return id
endfunction

function! s:toggle() abort
    let line = line('.')
    if getline('.') =~# '^[▷▼] Tab #'
        let tabid = matchstr(getline('.'), '\d\+$')
        if index(s:open_tabs, tabid) != -1
            call remove(s:open_tabs, index(s:open_tabs, tabid))
        else
            call add(s:open_tabs, tabid)
        endif
    endif
    call s:update_context()
    exe line
endfunction
