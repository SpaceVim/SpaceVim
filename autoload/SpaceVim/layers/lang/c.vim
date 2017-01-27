""
" @section Layer_lang_c
"   this layer provide c family language code completion and syntax chaeck.you
"   need install clang. 
"
" configuration:
"
"   1.setting compile flag: 
" >
"   let g:deoplete#sources#clang#flags = ['-Iwhatever', ...]
" <
"   2.`g:deoplete#sources#clang#executable` sets the path to the clang
"   executable.
"
"   3.`g:deoplete#sources#clang#autofill_neomake` is a boolean that tells this
"   plugin to fill in the `g:neomake_<filetype>_clang_maker` variable with the
"   clang executable path and flags. You will still need to enable it with
"   `g:neomake_<filetype>_enabled_make=['clang']`.
"
"   4.`g:deoplete#sources#clang#std` is a dict containing the standards you want
"   to use. It's not used if you already have `-std=whatever` in your flags. The
"   defaults are:
" >
"   {
"       'c': 'c11',
"       'cpp': 'c++1z',
"       'objc': 'c11',
"       'objcpp': 'c++1z',
"   }
" <
"   5.`g:deoplete#sources#clang#preproc_max_lines` sets the
"   maximum number of lines to search for a #ifdef or #endif
"   line. #ifdef lines are discarded to get completions within
"   conditional preprocessor blocks. The default is 50, setting it to 0 disables this feature.
"



function! SpaceVim#layers#lang#c#plugins() abort
    let plugins = []
    if has('nvim')
        call add(plugins, ['tweekmonster/deoplete-clang2'])
    else
        call add(plugins, ['Rip-Rip/clang_complete'])
    endif
    return plugins
endfunction

function! SpaceVim#layers#lang#c#config() abort

endfunction
