function! SpaceVim#custom#profile(dict) abort
    for key in keys(a:dict)
        call s:set(key, a:dict[key])
    endfor
endfunction


function! s:set(key,val) abort
    if !exists('g:spacevim_' . a:key)
        call SpaceVim#logger#warn('no option named ' . a:key)
    else
        exe 'let ' . 'g:spacevim_' . a:key . '=' . a:val
    endif
endfunction

" What is your preferred editing style?
" - Among the stars aboard the Evil flagship (vim)
" - On the planet Emacs in the Holy control tower (emacs)
"
" What distribution of spacemacs would you like to start with?
" The standard distribution, recommended (spacemacs)
" A minimalist distribution that you can build on (spacemacs-base)

function! SpaceVim#custom#autoconfig(...) abort
    let menu = SpaceVim#api#import('cmdlinemenu')
    let ques = [
                \ ['dark powered mode', function('s:awesome_mode')],
                \ ['basic mode', function('s:basic_mode')],
                \ ]
    call menu.menu(ques)
endfunction

function! s:awesome_mode() abort
    let sep = SpaceVim#api#import('file').separator
    let f = fnamemodify(g:Config_Main_Home, ':h') . join(['', 'mode', 'dark_powered.vim'], sep)
    let config = readfile(f, '')
    call s:write_to_config(config)
endfunction

function! s:basic_mode() abort
    let sep = SpaceVim#api#import('file').separator
    let f = fnamemodify(g:Config_Main_Home, ':h') . join(['', 'mode', 'basic.vim'], sep)
    let config = readfile(f, '')
    call s:write_to_config(config)
endfunction

function! s:write_to_config(config) abort
    let cf = expand('~/.SpaceVim.d/init.vim')
    if filereadable(cf)
        return
    endif
    if !isdirectory(fnamemodify(cf, ':p:h'))
        call mkdir(expand(fnamemodify(cf, ':p:h')), 'p')
    endif
    call writefile(a:config, cf, '')
endfunction
function! SpaceVim#custom#SPC(m, keys, cmd, desc, is_cmd) abort
    call add(g:_spacevim_mappings_space_custom,[a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction
