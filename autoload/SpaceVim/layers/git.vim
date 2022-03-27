"=============================================================================
" git.vim --- SpaceVim git layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section git, layers-git
" @parentsection layers
" `git` layer provides git integration for SpaceVim.
"
" @subsection Layer options
"
" `git_plugin`: Set the background plugin used in `git` layer. The default
" value is `git`, the following plugins are supported: `gina`, `fugitive` and
" `gita`.
" >
"   [[layers]]
"     name = 'git'
"     git_plugin = 'git'
" <
" `git_diff_position`: set the default command to split diff windows, by
" default it is `10split`. Example:
" >
"   [[layers]]
"     name = 'git'
"     git_diff_position = 'vsplit'
" <
" @subsection Key bindings
"
" The following key bindings will be definded when the `git` layer is loaded.
" >
"   Key Binding   Description
"   SPC g s       view git status
"   SPC g S       stage current file
"   SPC g U       unstage current file
"   SPC g c       edit git commit
"   SPC g p       git push
"   SPC g m       git branch manager
"   SPC g d       view git diff
"   SPC g A       stage all files
"   SPC g b       open git blame windows
"   SPC g h a     stage current hunk
"   SPC g h r     undo cursor hunk
"   SPC g h v     preview cursor hunk
" <


if exists('s:git_plugin')
  finish
endif

let s:git_plugin = 'git'



function! SpaceVim#layers#git#plugins() abort
  let plugins = [
        \ ]
  call add(plugins, ['airblade/vim-gitgutter',   { 'merged' : 0}])
  if s:git_plugin ==# 'gina'
    call add(plugins, ['lambdalisue/gina.vim', { 'on_cmd' : 'Gina'}])
  elseif s:git_plugin ==# 'fugitive'
    call add(plugins, ['tpope/vim-fugitive',   { 'merged' : 0}])
    call add(plugins, ['tpope/vim-dispatch', { 'merged' : 0}])
  elseif s:git_plugin ==# 'gita'
    call add(plugins, ['lambdalisue/vim-gita', { 'on_cmd' : 'Gita'}])
  else
    call add(plugins, [g:_spacevim_root_dir . 'bundle/git.vim', { 'merged' : 0}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#git#config() abort
  let g:signify_vcs_list = ['hg']
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VCS/git'})
  if s:git_plugin ==# 'gina'
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gina status --opener=10split', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gina add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gina reset -q %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gina commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gina push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gina diff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gina add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gina blame', 'view-git-blame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'Gina log %', 'git-log-of-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'Gina log', 'git-log-of-current-repo', 1)
  elseif s:git_plugin ==# 'fugitive'
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Git', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Git add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Git reset -q %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Git commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Git push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gdiffsplit', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Git add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Git blame', 'view-git-blame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'Gclog -- %', 'git-log-of-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'Gclog --', 'git-log-of-current-repo', 1)
  elseif s:git_plugin ==# 'gita'
    let g:gita#suppress_warning = 1
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gita status', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gita add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gita reset %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gita commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gita push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gita diff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gita add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gita blame', 'view-git-blame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'Gita log %', 'git-log-of-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'Gita log', 'git-log-of-current-repo', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Git status', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Git add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Git reset %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Git commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Git push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Git diff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Git add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Git blame', 'view-git-blame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'Git log %', 'git-log-of-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'Git log', 'git-log-of-current-repo', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'm'], 'Git branch', 'branch-manager', 1)
  endif
  augroup spacevim_layer_git
    autocmd!
    autocmd FileType diff nnoremap <buffer><silent> q :call SpaceVim#mapping#close_current_buffer()<CR>
    autocmd FileType gitcommit setl omnifunc=SpaceVim#plugins#gitcommit#complete
    if SpaceVim#layers#isLoaded('core#statusline')
      autocmd User GitGutter let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    endif
    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  augroup END
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'M'], 'call call('
        \ . string(function('s:display_last_commit_of_current_line')) . ', [])',
        \ 'commit-message-of-current-line', 1)

  if !exists('g:_spacevim_mappings_space.g.h')
    let g:_spacevim_mappings_space.g.h = {'name' : ''}
  endif
  let l:h_submenu_name = SpaceVim#layers#isLoaded('github') ? '+GitHub/Hunks' : '+Hunks'
  let g:_spacevim_mappings_space.g.h['name'] = l:h_submenu_name

  let l:stage_hunk_key = SpaceVim#layers#isLoaded('github') ? 's' : 'a'
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', l:stage_hunk_key], '<Plug>(GitGutterStageHunk)', 'stage-current-hunk', 0)
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', 'r'], '<Plug>(GitGutterUndoHunk)', 'undo-cursor-hunk', 0)
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', 'v'], '<Plug>(GitGutterPreviewHunk)', 'preview-cursor-hunk', 0)
endfunction

function! SpaceVim#layers#git#set_variable(var) abort

  let s:git_plugin = get(a:var,
        \ 'git_plugin',
        \ get(a:var,
        \ 'git-plugin',
        \ s:git_plugin))
  let g:git_diff_position = get(a:var, 'git_diff_position', '10split')

endfunction

function! s:display_last_commit_of_current_line() abort
  let line = line('.')
  let file = expand('%')
  let cmd = 'git log -L ' . line . ',' . line . ':' . file
  let cmd .= ' --pretty=format:"%s" -1'
  let title = systemlist(cmd)[0]
  if v:shell_error == 0
    echo 'Last commit of current line is: ' . title
  endif
endfunction


function! SpaceVim#layers#git#health() abort
  call SpaceVim#layers#git#plugins()
  call SpaceVim#layers#git#config()

  return 1

endfunction

" vim:set et sw=2 cc=80:
