" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.  Only define it when not
" defined already.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
command! -nargs=* -complete=custom,SpaceVim#plugins#complete_plugs Plugin :call SpaceVim#plugins#Plugin(<f-args>)
"command for open project
command! -nargs=+ -complete=custom,SpaceVim#plugins#projectmanager#complete_project OpenProject :call SpaceVim#plugins#projectmanager#OpenProject(<f-args>)

command! -nargs=* -complete=custom,SpaceVim#plugins#pmd#complete PMD :call SpaceVim#plugins#pmd#run(<f-args>)

command! -nargs=? -complete=custom,SpaceVim#plugins#a#complete -bang A :call SpaceVim#plugins#a#alt(<bang>0,<f-args>)
