""
" @section lang#c, layer-lang-c
" @parentsection layers
" This layer provides C family language code completion and syntax checking.
" Requires clang.
"
" Configuration for `tweekmonster/deoplete-clang2`:
"
"   1. Set the compile flags:
"
"       `let g:deoplete#sources#clang#flags = ['-Iwhatever', ...]`
"
"   2. Set the path to the clang executable:
" 
"       `let g:deoplete#sources#clang#executable = '/usr/bin/clang'
"
"   3. `g:deoplete#sources#clang#autofill_neomake` is a boolean that tells this
"       plugin to fill in the `g:neomake_<filetype>_clang_maker` variable with the
"       clang executable path and flags. You will still need to enable it with
"       `g:neomake_<filetype>_enabled_make=['clang']`.
"
"   4. Set the standards for each language:
"       `g:deoplete#sources#clang#std` is a dict containing the standards you want
"       to use. It's not used if you already have `-std=whatever` in your flags. The
"       defaults are:
" >
"       {
"           'c': 'c11',
"           'cpp': 'c++1z',
"           'objc': 'c11',
"           'objcpp': 'c++1z',
"       }
" <
"   5. `g:deoplete#sources#clang#preproc_max_lines` sets the
"      maximum number of lines to search for an #ifdef or #endif
"      line. #ifdef lines are discarded to get completions within
"      conditional preprocessor blocks. The default is 50, 
"      setting it to 0 disables this feature.
"



let s:use_libclang = 0

function! SpaceVim#layers#lang#c#plugins() abort
  let plugins = []
  if has('nvim')
    if s:use_libclang
      call add(plugins, ['zchee/deoplete-clang'])
    else
      call add(plugins, ['tweekmonster/deoplete-clang2'])
    endif
  else
    call add(plugins, ['Rip-Rip/clang_complete'])
  endif
  call add(plugins, ['lyuts/vim-rtags', { 'if' : has('python')}])
  return plugins
endfunction

function! SpaceVim#layers#lang#c#config() abort
  call SpaceVim#plugins#runner#reg_runner('c', ['gcc -o #TEMP# %s', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('c', funcref('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#c#set_variable(var) abort
  " use clang or libclang
  let s:use_libclang = get(a:var,
        \ 'use_libclang',
        \ 'clang')

  if has_key(a:var, 'clang_executable')
    let g:completor_clang_binary = a:var.clang_executable
    let g:deoplete#sources#clang#executable = a:var.clang_executable
  endif
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction

