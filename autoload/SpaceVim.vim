function! SpaceVim#init() abort
    
endfunction

function! SpaceVim#loadCustomConfig() abort
    let custom_confs = globpath(getcwd(), '.local.vim', 1,1)
    if !empty(custom_confs)
        exe 'source ' . custom_confs[0]
    endif
endfunction

function! SpaceVim#Layer(layer, opt) abort
    
endfunction

function! SpaceVim#end() abort
    
endfunction
