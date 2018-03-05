"=============================================================================
" VersionControl.vim --- SpaceVim version control layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

function! SpaceVim#layers#VersionControl#plugins() abort
  let plugins = []
  call add(plugins, ['mhinz/vim-signify', {'merged' : 0}])
  call add(plugins, ['tpope/vim-fugitive',   { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#VersionControl#config() abort
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  let g:_spacevim_mappings_space.g.v = get(g:_spacevim_mappings_space.g, 'v',  {'name' : '+VersionControl'})
  call SpaceVim#mapping#space#def('nnoremap', ['g', '.'], 'call call('
        \ . string(s:_function('s:buffer_transient_state')) . ', [])',
        \ 'buffer transient state', 1)
  call SpaceVim#layers#core#statusline#register_sections('vcs', s:_function('s:git_branch'))
  call SpaceVim#layers#core#statusline#register_sections('hunks', s:_function('s:hunks'))
  call add(g:spacevim_statusline_left_sections, 'vcs')
  call add(g:spacevim_statusline_left_sections, 'hunks')
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'v'], 'call SpaceVim#layers#core#statusline#toggle_section("vcs")',
        \ 'version control info', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'h'], 'call SpaceVim#layers#core#statusline#toggle_section("hunks")',
        \ 'toggle the hunks summary', 1)
endfunction

"  master
function! s:git_branch() abort
  if exists('g:loaded_fugitive')
    let l:head = fugitive#head()
    if empty(l:head)
      call fugitive#detect(getcwd())
      let l:head = fugitive#head()
    endif
    return empty(l:head) ? '' : '  '.l:head . ' '
  endif
  return ''
endfunction

" +0 ~0 -0 
function! s:hunks() abort
  let hunks = [0,0,0]
  try
    let hunks = sy#repo#get_stats()
  catch
  endtry
  let rst = ''
  if hunks[0] > 0
    let rst .= hunks[0] . '+ '
  endif
  if hunks[1] > 0
    let rst .= hunks[1] . '~ '
  endif
  if hunks[2] > 0
    let rst .= hunks[2] . '- '
  endif
  return empty(rst) ? '' : ' ' . rst
endfunction

" vcs transient state functions:
function! s:show_repo_log() abort
  
endfunction

function! s:show_diff_of_unstaged_hunks() abort
  
endfunction

function! s:fetch_repo() abort
  
endfunction

function! s:pull_repo() abort
  
endfunction

function! s:push_repo() abort
  
endfunction

function! s:buffer_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('VCS Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'next hunk',
        \ 'func' : '',
        \ 'cmd' : 'normal ]c',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'previous hunk',
        \ 'func' : '',
        \ 'cmd' : 'normal [c',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : ['r', 's', 'h'],
        \ 'desc' : 'revert/stage/show hunk',
        \ 'func' : '',
        \ 'cmd' : 'normal [c',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 't',
        \ 'desc' : 'toggle diff signs',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : {
        \ 'name' : 'w/u',
        \ 'pos': [[0,1], [2,3]],
        \ 'handles' : [
        \ ['w', 'Gina add %'],
        \ ['u', 'Gina reset %'],
        \ ],
        \ },
        \ 'desc' : 'stage/unstage in current file',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : ['c', 'C'],
        \ 'desc' : 'commit with popup/direct commit',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : 'f/F/P',
        \ 'pos' : [[0,1], [2,3], [4,5]],
        \ 'handles' : [
        \ ['f' , 'call call(' . string(s:_function('s:fetch_repo')) . ', [])'],
        \ ['F' , 'call call(' . string(s:_function('s:pull_repo')) . ', [])'],
        \ ['P' , 'call call(' . string(s:_function('s:push_repo')) . ', [])'],
        \ ],
        \ },
        \ 'desc' : 'fetch/pull/push popup',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : 'l/D',
        \ 'pos' : [[0,1], [2,3]],
        \ 'handles' : [
        \ ['l' , 'call call(' . string(s:_function('s:show_repo_log')) . ', [])'],
        \ ['D' , 'call call(' . string(s:_function('s:show_diff_of_unstaged_hunks')) . ', [])'],
        \ ],
        \ },
        \ 'desc' : 'log/diff popup',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
