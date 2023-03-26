"=============================================================================
" cheat.vim --- cheat plugin
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('g:loaded_cheat')
    finish
endif

""
" Set the path to the cheat sheets cache file, can be overriden from
" .vimrc with:
" >
"   let g:cheats_dir = '/path/to/your/cache/file'
" <
let g:cheats_dir = get(g:, 'cheats_dir', $HOME . '/.cheat/')

" Set the split direction for the output buffer.
" It can be overriden from .vimrc as well, by setting g:cheats_split to hor | ver
let s:cheats_split = get(g:, 'cheats_split', 'hor')

" Constants
let s:splitCmdMap = { 'ver' : 'vsp' ,  'hor' : 'sp' }

let s:cheat_options = {"-add" : "add new cheatsheet" , "-update" : "update current cheatsheet"}

" Func Defs
func! FindOrCreateOutWin(bufName)
    let outWinNr = bufwinnr(a:bufName)
    let outBufNr = bufnr(a:bufName)

    " Find or create a window for the bufName
    if outWinNr == -1
        " Create a new window
        exec s:splitCmdMap[s:cheats_split]

        let outWinNr = bufwinnr('%')
        if outBufNr != -1
            " The buffer already exists. Open it here.
            exec 'b'.outBufNr
        endif
        " Jump back to the previous window the user was editing in.
        exec 'wincmd p'
    endif

    " Find the buffer number or create one for bufName
    if outBufNr == -1
        " Jump to the output window
        exec outWinNr.' wincmd w'
        " Open a new output buffer
        exec 'e '.a:bufName
        setlocal noswapfile
        setlocal buftype=nofile
        setlocal wrap
        setlocal nobuflisted
        let outBufNr = bufnr('%')
        " Jump back to the previous window the user was editing in.
        exec 'wincmd p'
    endif
    return outBufNr
endf

func! s:RunAndRedirectOut(cheatName, bufName)
    " Change to the output buffer window
    let outWinNr = bufwinnr(a:bufName)
    exec outWinNr.' wincmd w'
    let f = fnameescape(g:cheats_dir . a:cheatName)

    if filereadable(f)
      call append(0, readfile(f))
      end
    normal! gg
endf

func! CheatCompletion(ArgLead, CmdLine, CursorPos)
    echom "arglead:[".a:ArgLead ."] cmdline:[" .a:CmdLine ."] cursorpos:[" .a:CursorPos ."]"
    if a:ArgLead =~ '^-\w*'
        return join(keys(s:cheat_options),"\n")
    endif
    return join(cheat#List_sheets(),"\n")
endf

func! Cheat(...)
    let c = a:0 != 0 ? a:000 : split(input('Cheat Sheet: ', '', 'custom,CheatCompletion'),' ')
    if len(c) == 1 && c[0] !~ '^-\w*'
        let outBuf = FindOrCreateOutWin('__cheat_output__')
        call s:RunAndRedirectOut(c[0], outBuf)
    elseif len(c) == 2 && c[0] ==# '-add' && c[1] !~ '^-\w*'
        if index(cheat#List_sheets(), c[1]) == -1
            exe "split ". g:cheats_dir . fnameescape(c[1])
        else
            echohl WarningMsg | echom "cheets " . c[1] . " already exists" | echohl None
        endif
    elseif len(c) == 2 && c[0] ==# '-update' && c[1] !~ '^-\w*'
        call cheat#Update(c[1])
    endif
endf

func! CheatCurrent()
    call Cheat(expand('<cword>'))
endf

" Commands Mappings
comm! -nargs=* -complete=custom,CheatCompletion Cheat :call Cheat(<f-args>)
comm! CheatCurrent :call CheatCurrent()

" Disable default mappings
"       let g:Cheat_EnableDefaultMappings = 0
if get(g:, 'Cheat_EnableDefaultMappings', 1)
    if empty(maparg('<Leader>C', 'n'))
        nnoremap <Leader>C :call Cheat()<CR>
    endif
    " Ask for cheatsheet for the word under cursor
    if empty(maparg('<Leader>ch', 'n'))
        nmap <leader>ch :call CheatCurrent()<CR>
    endif
endif
let g:loaded_cheat = 1
