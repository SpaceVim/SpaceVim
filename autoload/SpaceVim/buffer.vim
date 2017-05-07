let s:BUFFER = SpaceVim#api#import('vim#buffer')

augroup SpaceVim_buffer_handle
    au!
    au BufEnter * call s:handle()
augroup END

function! SpaceVim#buffer#def_handle_func(ft, func) abort
    call s:BUFFER.def_handle_func(a:ft, a:func)
endfunction

function! s:handle() abort
    call s:BUFFER.handle()
endfunction
