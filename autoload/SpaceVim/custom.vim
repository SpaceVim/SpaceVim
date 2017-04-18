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
