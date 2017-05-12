" APIs
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:TABs = SpaceVim#api#import('vim#tab')

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
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf SpaceVimTabsManager
    nnoremap <silent> <buffer> q :bd<CR>
    nnoremap <silent> <buffer> <CR> :call <SID>jump()<CR>
endfunction

function! s:update_context() abort
    setl modifiable
    let tree = s:TABs.get_tree()
    let ctx = []
    for page in keys(tree)
        call add(ctx, 'Tab #' . page)
        for _buf in tree[page]
            if getbufvar(_buf, '&buflisted')
                call add(ctx, '    ' . _buf . ':' . bufname(_buf))
            endif
        endfor
    endfor
    call setline(1, ctx)
    setl nomodifiable
endfunction

function! s:jump() abort
    let t = s:tabid()
    let b = s:bufid()
    q
    call s:TABs._jump(t,b)
endfunction

function! s:tabid() abort
    for i in range(0, line('.'))
        if getline(line('.') - i) =~# '^Tab'
            return matchstr(getline(line('.') - i), '\d\+$')
        endif
    endfor
endfunction

function! s:bufid() abort
    let id = str2nr(split(getline('.'), ':')[0])
    return id
endfunction

