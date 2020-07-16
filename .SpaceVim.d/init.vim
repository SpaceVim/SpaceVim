"=============================================================================
" init.vim --- local config for SpaceVim development
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:spacevim_force_global_config = 1
call SpaceVim#custom#SPC('nnoremap', ['a', 'r'], 'call SpaceVim#dev#releases#open()', 'Release SpaceVim', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 'w'], 'call SpaceVim#dev#website#open()', 'Open SpaceVim local website', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 't'], 'call SpaceVim#dev#website#terminal()', 'Close SpaceVim local website', 1)

" after run make test, the vader will be downloaded to ./build/vader/

let &runtimepath .= ',' . fnamemodify(g:_spacevim_root_dir, ':p:h') . '/build/vader'

augroup vader_filetype
  autocmd!
  autocmd FileType vader-result setlocal nobuflisted
augroup END

" vader language specific key bindings

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'Vader',
        \ 'execute current file', 1)
endfunction
call SpaceVim#mapping#space#regesit_lang_mappings('vader', function('s:language_specified_mappings'))
call SpaceVim#plugins#a#set_config_name('.projections.json')
command! -nargs=1 IssueEdit call SpaceVim#dev#issuemanager#edit(<f-args>)
command! -nargs=1 PullCreate call SpaceVim#dev#pull#create(<f-args>)
command! -nargs=1 PullMerge call SpaceVim#dev#pull#merge(<f-args>)
command! ReleaseSpaceVim call SpaceVim#dev#releases#open()
command! -nargs=* -complete=file Profile call SpaceVim#dev#profile#run(<f-args>)
