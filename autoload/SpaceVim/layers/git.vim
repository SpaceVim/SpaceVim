function! SpaceVim#layers#git#plugins() abort
  let plugins = [
        \ ['cohama/agit.vim',      { 'on_cmd' : ['Agit','AgitFile']}],
        \ ['gregsexton/gitv',      { 'on_cmd' : ['Gitv']}],
        \ ['junegunn/gv.vim',      { 'on_cmd' : 'GV'}],
        \ ['tpope/vim-fugitive',   { 'merged' : 0}],
        \ ]
  if has('patch-8.0.0027') || has('nvim')
    call add(plugins, ['lambdalisue/gina.vim', { 'on_cmd' : 'Gina'}])
  else
    call add(plugins, ['lambdalisue/vim-gita', { 'on_cmd' : 'Gita'}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#git#config() abort
  if has('patch-8.0.0027') || has('nvim')
    nnoremap <silent> <Leader>gd :Gina diff<CR>
    nnoremap <silent> <Leader>gs :Gina status<CR>
    nnoremap <silent> <Leader>gc :Gina commit<CR>
    nnoremap <silent> <Leader>gb :Gina blame :<CR>
    nnoremap <silent> <Leader>gp :Gina push<CR>
    nnoremap <silent> <Leader>ga :Gina add %<CR>
    nnoremap <silent> <Leader>gA :Gina add .<CR>
    let g:_spacevim_mappings.g = {'name' : '+git function',
          \ 'd' : ['Gina diff', 'git diff'],
          \ 's' : ['Gina status', 'git status'],
          \ 'c' : ['Gina commit', 'git commit'],
          \ 'b' : ['Gina blame', 'git blame'],
          \ 'p' : ['Gina push', 'git push'],
          \ 'a' : ['Gina add %', 'git add current buffer'],
          \ 'A' : ['Gina add .', 'git add all files'],
          \ }
  else
    nnoremap <silent> <Leader>gd :Gita diff<CR>
    nnoremap <silent> <Leader>gs :Gita status<CR>
    nnoremap <silent> <Leader>gc :Gita commit<CR>
    nnoremap <silent> <Leader>gb :Gita blame :<CR>
    nnoremap <silent> <Leader>gp :Gita push<CR>
    nnoremap <silent> <Leader>ga :Gita add %<CR>
    nnoremap <silent> <Leader>gA :Gita add .<CR>
    let g:_spacevim_mappings.g = {'name' : 'git function',
          \ 'd' : ['Gita diff', 'git diff'],
          \ 's' : ['Gita status', 'git status'],
          \ 'c' : ['Gita commit', 'git commit'],
          \ 'b' : ['Gita blame', 'git blame'],
          \ 'p' : ['Gita push', 'git push'],
          \ 'a' : ['Gita add %', 'git add current buffer'],
          \ 'A' : ['Gita add .', 'git add all files'],
          \ }
  endif
  nmap <leader>hj <plug>(signify-next-hunk)
  nmap <leader>hk <plug>(signify-prev-hunk)
  nmap <leader>hJ 9999<leader>gj
  nmap <leader>hK 9999<leader>gk
  augroup spacevim_layer_git
    autocmd!
    autocmd FileType diff nnoremap <buffer><silent> q :bd!<CR>
    autocmd FileType gitcommit setl omnifunc=SpaceVim#plugins#gitcommit#complete
  augroup END
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gina status', 'git status', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gina add %', 'stage current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gina reset %', 'unstage current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'M'], 'call call('
        \ . string(function('s:display_last_commit_of_current_line')) . ', [])',
        \ 'display the last commit message of the current line', 1)
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

" vim:set et sw=2 cc=80:
