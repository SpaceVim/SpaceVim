function! SpaceVim#layers#git#plugins() abort
  let plugins = [
        \ ['junegunn/gv.vim',      { 'on_cmd' : ['GV']}],
        \ ['airblade/vim-gitgutter',      { 'merged' : 0}],
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
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  if has('patch-8.0.0027') || has('nvim')
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gina status --opener=10split', 'git status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gina add %', 'stage current file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gina reset -q %', 'unstage current file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gina commit', 'edit git commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gina push', 'git push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gina diff', 'view git diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gina add .', 'stage all files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gina blame', 'view git blame', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gita status', 'git status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gita add %', 'stage current file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gita reset %', 'unstage current file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gita commit', 'edit git commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gita push', 'git push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gita diff', 'view git diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gita add .', 'stage all files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gina blame', 'view git blame', 1)
  endif
  nmap <leader>hj <plug>(signify-next-hunk)
  nmap <leader>hk <plug>(signify-prev-hunk)
  nmap <leader>hJ 9999<leader>gj
  nmap <leader>hK 9999<leader>gk
  augroup spacevim_layer_git
    autocmd!
    autocmd FileType diff nnoremap <buffer><silent> q :bd!<CR>
    autocmd FileType gitcommit setl omnifunc=SpaceVim#plugins#gitcommit#complete
    autocmd User GitGutter let &l:statusline = SpaceVim#layers#core#statusline#get(1)
  augroup END
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'M'], 'call call('
        \ . string(function('s:display_last_commit_of_current_line')) . ', [])',
        \ 'display the last commit message of the current line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'GV!', 'View git log of current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'GV', 'View git log of current repo', 1)
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
