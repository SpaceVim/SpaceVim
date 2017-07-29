let s:KEY = SpaceVim#api#import('vim#key')
let s:key_describ = {}

function! SpaceVim#plugins#help#describe_bindings()
endfunction

function! SpaceVim#plugins#help#regist_root(dict)
    let keys = keys(a:dict)
    if type(a:dict) == 4 && len(keys) == 1
        call extend(s:key_describ, a:dict)
    endif
endfunction


function! SpaceVim#plugins#help#describe_key()
    let definded = 1
    let root = s:key_describ
    let prompt = 'Describe key:'
    let keys = []
    call s:build_mpt(prompt)
    while definded
        let key = getchar()
        let name = s:KEY.nr2name(key)
        call add(keys, name)
        if has_key(root, name)
            let root = root[name]
            if type(root) == 3
                if len(root) == 3
                    redraw!
                    call s:open_describe_buffer(root[-1])
                else
                    call s:build_mpt(['can not find describe for ', join(keys, ' - ')])
                endif
                let definded = 0
            else
                call s:build_mpt([prompt, join(keys + [''], ' - ')])
            endif
        else
            redraw!
            echohl Comment
            echo   join(keys, ' - ') . ' is undfinded'
            echohl NONE
            let definded = 0
        endif
    endwhile
endfunction

function! s:build_mpt(mpt) abort
    redraw!
    echohl Comment
    if type(a:mpt) == 1
        echo a:mpt
    elseif type(a:mpt) == 3
        echo join(a:mpt)
    endif
    echohl NONE
endfunction


function! s:open_describe_buffer(desc) abort
    noautocmd botright split __help_describe__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber nocursorline
    set filetype=HelpDescribe
    call setline(1, a:desc)
    let lines = &lines * 30 / 100
    if lines < winheight(0)
        exe 'resize ' . lines
    endif
endfunction
