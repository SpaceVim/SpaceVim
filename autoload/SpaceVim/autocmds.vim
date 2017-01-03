"autocmds
function! SpaceVim#autocmds#init() abort
    augroup My_autocmds
        au!
        autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
                    \   q :cclose<cr>:lclose<cr>
        autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
                    \   bd|
                    \   q | endif
        autocmd FileType jsp call JspFileTypeInit()
        autocmd FileType html,css,jsp EmmetInstall
        autocmd FileType java call JavaFileTypeInit()
        autocmd BufEnter,WinEnter,InsertLeave * set cursorline
        autocmd BufLeave,WinLeave,InsertEnter * set nocursorline
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
        autocmd BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
        autocmd BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.
        autocmd FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        autocmd FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
        autocmd FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        autocmd FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        autocmd FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        autocmd FileType lua set comments=f:--
        autocmd FileType vim setlocal foldmethod=marker
        autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType xml call XmlFileTypeInit()
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
        autocmd BufEnter *
                    \   if empty(&buftype)&&has('nvim')
                    \|      nnoremap <silent><buffer> <C-]> :call MyTagfunc()<CR>
                    \|      nnoremap <silent><buffer> <C-[> :call MyTagfuncBack()<CR>
                    \|  else
                        \|      nnoremap <silent><buffer> <leader>] :call MyTagfunc()<CR>
                        \|      nnoremap <silent><buffer> <leader>[ :call MyTagfuncBack()<CR>
                        \|  endif
        "}}}
        autocmd FileType python,coffee call zvim#util#check_if_expand_tab()
        " Instead of reverting the cursor to the last position in the buffer, we
        " set it to the first line when editing a git commit message
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
        autocmd InsertEnter * call s:tool()
        if executable('synclient')
            let s:touchpadoff = 0
            autocmd InsertEnter * call s:disable_touchpad()
            autocmd InsertLeave * call s:enable_touchpad()
            autocmd FocusLost * call system('synclient touchpadoff=0')
            autocmd FocusGained * call s:reload_touchpad_status()
        endif
        autocmd VimResized * wincmd =
        autocmd BufWritePost *.vim call s:generate_doc()
    augroup END
endfunction
function! s:reload_touchpad_status() abort
    if s:touchpadoff
        call s:disable_touchpad()
    endif
endf
function! s:disable_touchpad() abort
    let s:touchpadoff = 1
    call system('synclient touchpadoff=1')
endfunction
function! s:enable_touchpad() abort
    let s:touchpadoff = 0
    call system('synclient touchpadoff=0')
endfunction
function! s:tool() abort
    if !exists('s:done')
        IndentLinesToggle
        IndentLinesToggle
        let s:done = 1
    endif
endfunction
function! s:generate_doc() abort
    if filereadable('./addon-info.json') && executable('vimdoc')
        call system('vimdoc .')
    endif
endfunction
