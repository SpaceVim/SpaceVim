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
let s:clang_executable = 'clang'
function! SpaceVim#layers#lang#c#plugins() abort
  let plugins = []
  if g:spacevim_autocomplete_method ==# 'deoplete'
    if s:use_libclang
      call add(plugins, ['zchee/deoplete-clang'])
    else
      call add(plugins, ['tweekmonster/deoplete-clang2'])
    endif
  elseif g:spacevim_autocomplete_method ==# 'ycm'
    " no need extra plugins
  elseif g:spacevim_autocomplete_method ==# 'completor'
    " no need extra plugins
  elseif g:spacevim_autocomplete_method ==# 'asyncomplete'
  else
    call add(plugins, ['Rip-Rip/clang_complete'])
  endif
  call add(plugins, ['lyuts/vim-rtags', { 'if' : has('python')}])
  return plugins
endfunction

function! SpaceVim#layers#lang#c#config() abort
  call SpaceVim#plugins#runner#reg_runner('c', ['gcc -o #TEMP# %s', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('c', funcref('s:language_specified_mappings'))
  call SpaceVim#plugins#projectmanager#reg_callback(funcref('s:update_clang_flag'))
  if executable('clang')
    let g:neomake_c_enabled_makers = ['clang']
    let g:neomake_cpp_enabled_makers = ['clang']
  endif
endfunction

function! SpaceVim#layers#lang#c#set_variable(var) abort
  " use clang or libclang
  let s:use_libclang = get(a:var,
        \ 'use_libclang',
        \ 'clang')

  if has_key(a:var, 'clang_executable')
    let g:completor_clang_binary = a:var.clang_executable
    let g:deoplete#sources#clang#executable = a:var.clang_executable
    let g:neomake_c_enabled_makers = ['clang']
    let g:neomake_cpp_enabled_makers = ['clang']
    let s:clang_executable = a:var.clang_executable
  endif
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction


function! s:update_clang_flag() abort
  if filereadable('.clang')
    let argvs = readfile('.clang')
    call s:update_checkers_argv(argvs, ['c', 'cpp'])
    call s:update_autocomplete_argv(argvs, ['c', 'cpp'])
  endif
endfunction

if g:spacevim_enable_neomake && g:spacevim_enable_ale == 0
  function! s:update_checkers_argv(argv, fts) abort
    for ft in a:fts
      let g:neomake_{ft}_clang_maker = {
            \ 'args': ['-fsyntax-only', '-Wall', '-Wextra', '-I./'] + a:argv,
            \ 'exe' : s:clang_executable,
            \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m'
            \ }
    endfor
  endfunction
elseif g:spacevim_enable_ale
  function! s:update_checkers_argv(argv, fts) abort
    " g:ale_c_clang_options
    for ft in a:fts
      let g:ale_{ft}_clang_options = ' -fsyntax-only -Wall -Wextra -I./ ' . join(a:argv, ' ')
      let g:ale_{ft}_clang_executabl = s:clang_executable
    endfor
  endfunction
else
  function! s:update_checkers_argv(argv, fts) abort

  endfunction
endif

function! s:update_autocomplete_argv(argv, fts) abort

endfunction

