" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.  Only define it when not
" defined already.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
command! -nargs=* -complete=custom,zvim#util#complete_plugs Plugin :call zvim#util#Plugin(<f-args>)
"command for open project
command! -nargs=+ -complete=custom,zvim#util#complete_project OpenProject :call zvim#util#OpenProject(<f-args>)

command! -nargs=* -complete=custom,SpaceVim#plugins#pmd#complete PMD :call SpaceVim#plugins#pmd#run(<f-args>)

command! -nargs=0 A :call SpaceVim#plugins#a#alt()
