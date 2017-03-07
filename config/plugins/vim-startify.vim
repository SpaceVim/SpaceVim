let g:startify_custom_header = get(g:, 'startify_custom_header', [
      \'',
      \'',
      \'        /######                                     /##    /##/##             ',
      \'       /##__  ##                                   | ##   | #|__/             ',
      \'      | ##  \__/ /######  /######  /####### /######| ##   | ##/##/######/#### ',
      \'      |  ###### /##__  ##|____  ##/##_____//##__  #|  ## / ##| #| ##_  ##_  ##',
      \'       \____  #| ##  \ ## /######| ##     | ########\  ## ##/| #| ## \ ## \ ##',
      \'       /##  \ #| ##  | ##/##__  #| ##     | ##_____/ \  ###/ | #| ## | ## | ##',
      \'      |  ######| #######|  ######|  ######|  #######  \  #/  | #| ## | ## | ##',
      \'       \______/| ##____/ \_______/\_______/\_______/   \_/   |__|__/ |__/ |__/',
      \'               | ##                                                           ',
      \'               | ##                                                           ',
      \'               |__/                                                           ',
      \'                      version : ' . g:spacevim_version . '   by : spacevim.org',
      \'',
      \ ])
let g:startify_session_dir = $HOME .  '/.data/' . ( has('nvim') ? 'nvim' : 'vim' ) . '/session'
let g:startify_files_number = 6
let g:startify_list_order = [
      \ ['   My most recently used files in the current directory:'],
      \ 'dir',
      \ ['   My most recently used files:'],
      \ 'files',
      \ ['   These are my sessions:'],
      \ 'sessions',
      \ ['   These are my bookmarks:'],
      \ 'bookmarks',
      \ ]
"let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.zshrc' ]
let g:startify_update_oldfiles = 1
let g:startify_disable_at_vimenter = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
"let g:startify_session_delete_buffers = 0
let g:startify_change_to_dir = 0
"let g:startify_change_to_vcs_root = 0  " vim-rooter has same feature
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ 'bundle/.*/doc',
      \ ]
fu! <SID>startify_mapping()
  if getcwd() == $VIM || getcwd() == expand('~')
    nnoremap <silent><buffer> <c-p> :<c-u>CtrlP ~\DotFiles<cr>
  endif
endf
augroup startify_map
  au!
  autocmd FileType startify nnoremap <buffer><F2> <Nop>
  autocmd FileType startify call <SID>startify_mapping()
  autocmd FileType startify set scrolloff=0
augroup END

" vim:set et sw=2:
