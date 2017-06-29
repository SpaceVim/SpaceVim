""
" @section lang#kotlin, layer-lang-kotlin
" @parentsection layers
" This layer is for kotlin development. 


function! SpaceVim#layers#lang#kotlin#plugins() abort
    let plugins = []
    call add(plugins, ['udalov/kotlin-vim'])
    return plugins
endfunction

function! SpaceVim#layers#lang#kotlin#config() abort
if g:spacevim_enable_neomake
" neomake support:
let g:neomake_kotlin_kotlinc_maker = {
    \ 'args': ['-cp', s:classpath(), '-d', s:outputdir()],
    \ 'errorformat':
        \ "%E%f:%l:%c: error: %m," .
		\ "%W%f:%l:%c: warning: %m," .
		\ "%Eerror: %m," .
		\ "%Wwarning: %m," .
		\ "%Iinfo: %m,"
    \ }
let g:neomake_kotlin_enabled_makers = ['kotlinc']
endif
endfunction

func! s:classpath()

endf

func! s:outputdir()

endf

