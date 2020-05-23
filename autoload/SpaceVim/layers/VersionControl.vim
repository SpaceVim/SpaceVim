"=============================================================================
" VersionControl.vim --- SpaceVim version control layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:CMP = SpaceVim#api#import('vim#compatible')

let s:enable_gtm_status = 0

function! SpaceVim#layers#VersionControl#plugins() abort
  let plugins = []
  if !SpaceVim#layers#isLoaded('git')
    call add(plugins, ['mhinz/vim-signify', {'merged' : 0, 'loadconf' : 1}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#VersionControl#config() abort
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  let g:_spacevim_mappings_space.g.v = get(g:_spacevim_mappings_space.g, 'v',  {'name' : '+VersionControl'})
  call SpaceVim#mapping#space#def('nnoremap', ['g', '.'], 'call call('
        \ . string(s:_function('s:git_transient_state')) . ', [])',
        \ 'buffer transient state', 1)
  call SpaceVim#layers#core#statusline#register_sections('vcs', s:_function('s:git_branch'))
  call SpaceVim#layers#core#statusline#register_sections('hunks', s:_function('s:hunks'))
  call add(g:spacevim_statusline_left_sections, 'vcs')
  call add(g:spacevim_statusline_left_sections, 'hunks')
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'v'], 'call SpaceVim#layers#core#statusline#toggle_section("vcs")',
        \ 'version control info', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'h'], 'call SpaceVim#layers#core#statusline#toggle_section("hunks")',
        \ 'toggle the hunks summary', 1)
  let g:gtm_plugin_status_enabled = s:enable_gtm_status
  if s:enable_gtm_status
    augroup gtm_plugin
      autocmd!
      autocmd BufReadPost,BufWritePost,CursorMoved,CursorMovedI * silent call s:record()
    augroup END
  endif
  nnoremap <silent> [n :call <SID>Context(1)<CR>
  nnoremap <silent> ]n :call <SID>Context(0)<CR>
endfunction

function! s:Context(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

function! SpaceVim#layers#VersionControl#set_variable(var) abort
  let s:enable_gtm_status = get(a:var,
        \ 'enable_gtm_status',
        \ s:enable_gtm_status)
endfunction

"  master
function! s:git_branch() abort
  if exists('g:loaded_fugitive')
    try
      let head = fugitive#head()
      if empty(head)
        call fugitive#detect(getcwd())
        let head = fugitive#head()
      endif
      if g:spacevim_statusline_unicode_symbols == 1
        return empty(head) ? '' : '  '.head . ' ' . s:gtm_status()
      else
        return empty(head) ? '' : ' '.head . ' ' . s:gtm_status()
      endif
    catch
    endtry
  elseif exists('g:loaded_git')
    try
      let head = '%{git#branch#current()}'
      if g:spacevim_statusline_unicode_symbols == 1
        return empty(head) ? '' : '  '.head . ' ' . s:gtm_status()
      else
        return empty(head) ? '' : ' '.head . ' ' . s:gtm_status()
      endif
    catch
    endtry
  endif
  return ''
endfunction


function! s:gtm_status() abort
  if s:enable_gtm_status
    let status = s:gtm_statusline()
    return empty(status) ? '' : ' (' . status . ') '
  else
    return ''
  endif
endfunction

let s:last_update = 0
let s:last_file = ''
let s:update_interval = 30
let s:gtm_plugin_status = ''

function! s:record() abort
  let fpath = expand('%:p')
  " record if file path has changed or last update is greater than update_interval
  if (s:last_file != fpath || localtime() - s:last_update > s:update_interval) && filereadable(fpath)
    let s:cmd = (s:enable_gtm_status == 1 ? 'gtm record --status' : 'gtm record')
    let output=system(s:cmd . ' ' . shellescape(fpath))
    if v:shell_error
      echoerr 'failed to run ' . s:cmd . ' ' . shellescape(fpath)
    else
      let s:gtm_plugin_status = (s:enable_gtm_status ? substitute(output, '\n\+$', '', '') : '')
    endif
    let s:last_update = localtime()
    let s:last_file = fpath
  endif
endfunction

function! s:gtm_statusline() abort
  return s:gtm_plugin_status
endfunction

" +0 ~0 -0 
" if git layer is loaded, use vim-gitgutter instead.
function! s:hunks() abort
  let hunks = [0,0,0]
  try
    if SpaceVim#layers#isLoaded('git')
      let hunks = GitGutterGetHunkSummary()
    else
      let hunks = sy#repo#get_stats()
    endif
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

" first we need to open a buffer contains:
" Switches
"  -g Show graph (--graph)
"  -c Show graph in color (--color)
"
" Options
"  =n Limit number of commits (-n"256")
"  =f Limit to files (-- )
"  =a Limit to author (--author=)
"
" Actions
"  l Log current
let s:git_log_switches = {
      \ 'g' : {'desc' : 'Show graph', 'option' : '--graph', 'enable' : 0},
      \ 'c' : {'desc' : 'Show graph in color', 'option' : '--color', 'enable' : 0},
      \ 'd' : {'desc' : 'Show refnames', 'option' : '--decorate', 'enable' : 0},
      \ 'S' : {'desc' : 'Show signatures', 'option' : '--show-signature', 'enable' : 0},
      \ 'u' : {'desc' : 'Show diffs', 'option' : '--patch', 'enable' : 0},
      \ 's' : {'desc' : 'Show diffstats', 'option' : '--stat', 'enable' : 0},
      \ 'h' : {'desc' : 'Show header', 'option' : '++header', 'enable' : 0},
      \ 'D' : {'desc' : 'Simplify by decoration', 'option' : '--simplify-by-decoration', 'enable' : 0},
      \ 'f' : {'desc' : 'Follow renames when showing single-file log', 'option' : '--follow', 'enable' : 0},
      \ }
let s:git_log_options = {
      \ 'n' : {'desc' : 'Limit number of commits', 'option' : '-n', 'enable' : 0},
      \ 'f' : {'desc' : 'Limit to files', 'option' : '--', 'enable' : 0},
      \ 'a' : {'desc' : 'Limit to author', 'option' : '--author=', 'enable' : 0},
      \ 'o' : {'desc' : 'Order commits by', 'option' : '++order=', 'enable' : 0},
      \ 'g' : {'desc' : 'Search messages', 'option' : '--grep=', 'enable' : 0},
      \ 'G' : {'desc' : 'Search changes', 'option' : '-G', 'enable' : 0},
      \ 'S' : {'desc' : 'Search occurrences', 'option' : '-S', 'enable' : 0},
      \ 'L' : {'desc' : 'Trace line evolution', 'option' : '-L', 'enable' : 0},
      \ }
let s:git_log_actions = {
      \ 'l' : {'desc' : 'Log current'},
      \ 'o' : {'desc' : 'Log other'},
      \ 'h' : {'desc' : 'Log HEAD'},
      \ 'L' : {'desc' : 'Log local branches'},
      \ 'b' : {'desc' : 'Log all branches'},
      \ 'a' : {'desc' : 'Log all references'},
      \ 'r' : {'desc' : 'Reflog current'},
      \ 'O' : {'desc' : 'Reflog other'},
      \ 'H' : {'desc' : 'Reflog HEAD'},
      \ }

" generate git log popup content && defind key bindings {{{
function! s:generate_git_log_popup_content() abort
  let lines = ['Switches']
  for k in keys(s:git_log_switches)
    call add(lines, ' -' . k . ' ' . s:git_log_switches[k]['desc'] . '(' . s:git_log_switches[k]['option'] . ')')
    exe 'nnoremap <silent><buffer> -' . k . ' :call <SID>toggle_switches("' . k . '")<cr>'
  endfor
  call add(lines, '')
  call add(lines, 'Options')
  for k in keys(s:git_log_options)
    call add(lines, ' =' . k . ' ' . s:git_log_options[k]['desc'] . '(' . s:git_log_options[k]['option'] . ')')
    exe 'nnoremap <silent><buffer> =' . k . ' :call <SID>change_options("' . k . '")<cr>'
  endfor
  call add(lines, '')
  call add(lines, 'Actions')
  let actions_line = ''
  let i = 0
  for k in ['l', 'L', 'r', 'o', 'b', 'O', 'h', 'a', 'H']
    let i += 1
    let actions_line .= ' ' . k . ' ' . s:git_log_actions[k]['desc']
    exe 'nnoremap <silent><buffer> ' . k . ' :call <SID>' . join(split(s:git_log_actions[k]['desc']), '_') . '()<cr>'
    let actions_line .= repeat(' ', i % 3 * 30 - len(actions_line))
    if i%3 == 0
      call add(lines, actions_line)
      let actions_line = ''
    endif
  endfor
  if !empty(actions_line)
    call add(lines, actions_line)
    let actions_line = ''
  endif
  return lines
endfunction
" }}}

" git popup menu switches functions {{{
let s:switches_hi_id = 0
function! s:highlight_switches() abort
  let line = 1
  try
    call matchdelete(s:switches_hi_id)
  catch
  endtry
  let poses = []
  for k in keys(s:git_log_switches)
    let line += 1
    if s:git_log_switches[k].enable
      call add(poses, [line, len(s:git_log_switches[k].desc) + 6, len(s:git_log_switches[k].option)])
    endif
  endfor
  " vim has a bug, Normal higlight group does not work will matchaddpos
  " So we need to use new highlight group
  let s:switches_hi_id = s:CMP.matchaddpos('MoreMsg', poses)
endfunction

function! s:toggle_switches(key) abort
  if s:git_log_switches[a:key].enable
    let s:git_log_switches[a:key].enable = 0
  else
    let s:git_log_switches[a:key].enable = 1
  endif
  call s:highlight_switches()
endfunction
" }}}

" git popup menu options functions {{{
let s:options_hi_id = 0
function! s:highlight_options() abort
  let line = 1 + len(keys(s:git_log_switches)) + 2
  try
    call matchdelete(s:options_hi_id)
  catch
  endtry
  let poses = []
  for k in keys(s:git_log_options)
    let line += 1
    if s:git_log_options[k].enable
      call add(poses, [line, len(s:git_log_options[k].desc) + 6, len(s:git_log_options[k].option)])
    endif
  endfor
  " vim has a bug, Normal higlight group does not work will matchaddpos
  " So we need to use new highlight group
  " ref: https://github.com/vim/vim/issues/3752
  let s:options_hi_id = s:CMP.matchaddpos('MoreMsg', poses)
endfunction

function! s:change_options(key) abort
  if s:git_log_options[a:key].enable
    let s:git_log_options[a:key].enable = 0
  else
    let s:git_log_options[a:key].enable = 1
    if a:key ==# 'a'
      " change author
      let orig_author = matchstr(s:git_log_options[a:key].option, '\("\)\@<=[^"]*')
      let author = input('--author=', orig_author)
      if !empty(author)
        let s:git_log_options[a:key].option = '--author="' . author . '"'
      else
        let s:git_log_options[a:key].option = '--author='
      endif
    elseif a:key ==# 'n'
      let orig_nr = matchstr(s:git_log_options[a:key].option, '\("\)\@<=[^"]*')
      let nr = str2nr(input('-n', orig_nr))
      if nr > 0
        let s:git_log_options[a:key].option = '-n"' . nr . '"'
      else
        echohl WarningMsg
        echo 'need to input number'
        echohl None
        let s:git_log_options[a:key].enable = 0
        let s:git_log_options[a:key].option = '-n'
      endif
    endif
    setlocal modifiable
    let content = s:generate_git_log_popup_content()
    normal! "_ggdG
    call setline(1, content)
    setlocal nomodifiable
  endif
  call s:highlight_options()
endfunction
" }}}


function! s:open_log_popup_buffer() abort
  exe 'rightbelow  split __SpaceVim_git_log_popup__'
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonumber norelativenumber nocursorline
  setfiletype SpaceVimGitLogPopup
  let content = s:generate_git_log_popup_content()
  exe 'resize ' . len(content)
  call setline(1, content)
  setlocal nomodifiable
  call s:highlight_switches()
  call s:highlight_options()
endfunction

function! s:show_repo_log() abort
  call s:open_log_popup_buffer()
endfunction

function! s:get_log_argv() abort
  let argv = ['git', 'log', '--no-color']
  for k in keys(s:git_log_switches)
    if s:git_log_switches[k].enable
      call add(argv, s:git_log_switches[k].option)
    endif
  endfor
  for k in keys(s:git_log_options)
    if s:git_log_options[k].enable
      call add(argv, s:git_log_options[k].option)
    endif
  endfor
  return argv
endfunction

" git log popup action functions {{{
function! s:Log_current() abort
  close
  tabnew
  setlocal norelativenumber
  let t:_spacevim_tab_name = 'Git log'
  let argv = join(s:get_log_argv(), ' ')
  call SpaceVim#logger#info(argv)
  " in gvim only have term_start function
  if !has('nvim')
    call term_start(argv, {'curwin' : 1, 'term_finish' : 'close'})
  else
    call termopen(argv)
  endif
  nnoremap <buffer><silent> q :bd!<cr>
  startinsert
endfunction
" }}}

function! s:show_diff_of_unstaged_hunks() abort

endfunction

function! s:fetch_repo() abort

endfunction

function! s:pull_repo() abort

endfunction

function! s:push_repo() abort

endfunction

function! s:commit_popup() abort

endfunction

function! s:commit() abort

endfunction

function! s:revert_hunk() abort

endfunction

function! s:stage_hunk() abort

endfunction

function! s:show_hunk_diff() abort

endfunction

function! s:git_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('VCS Transient State')
  call state.defind_keys(
        \ {
        \    'layout' : 'vertical split',
        \    'left' : [
        \       {
        \         'key' : 'n',
        \         'desc' : 'next hunk',
        \         'func' : '',
        \         'cmd' : 'normal ]c',
        \         'exit' : 0,
        \       },
        \       {
        \         'key' : ['N', 'p'],
        \         'desc' : 'previous hunk',
        \         'func' : '',
        \         'cmd' : 'normal [c',
        \         'exit' : 0,
        \       },
        \ {
        \ 'key' : {
        \ 'name' : 'r/s/h',
        \ 'pos' : [[1,2], [3,4], [5,6]],
        \ 'handles' : [
        \ ['r' , 'call call(' . string(s:_function('s:revert_hunk')) . ', [])'],
        \ ['s' , 'call call(' . string(s:_function('s:stage_hunk')) . ', [])'],
        \ ['h' , 'call call(' . string(s:_function('s:show_hunk_diff')) . ', [])'],
        \ ],
        \ },
        \ 'desc' : 'revert/stage/show hunk',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 't',
        \ 'desc' : 'toggle diff signs',
        \ 'func' : '',
        \ 'cmd' : 'SignifyToggle',
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
        \ 'key' : {
        \ 'name' : 'c/C',
        \ 'pos' : [[0,1], [2,3]],
        \ 'handles' : [
        \ ['c' , 'call call(' . string(s:_function('s:commit_popup')) . ', [])'],
        \ ['C' , 'call call(' . string(s:_function('s:commit')) . ', [])'],
        \ ],
        \ },
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
        \ 'key' : 'l',
        \ 'desc' : 'log/diff popup',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ 'exit_cmd' : 'call call(' . string(s:_function('s:show_repo_log')) . ', [])',
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

" function() wrapper {{{
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
" }}}
