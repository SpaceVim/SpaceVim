" Vim filetype detection file
" Language:     PlantUML
" License:      VIM LICENSE

" Note: should not use augroup in ftdetect (see :help ftdetect)
autocmd BufRead,BufNewFile * if !did_filetype() && getline(1) =~# '@startuml\>'| setfiletype plantuml | endif
autocmd BufRead,BufNewFile *.pu,*.uml,*.plantuml,*.puml,*.iuml set filetype=plantuml
