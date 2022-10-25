" vim-cheat
"
" Maintainer:   Wang Shidong <wsdjeg@outlook.com>
" License:      MIT
" Version:      0.1.0

if exists('g:loaded_cheat')
    finish
endif

" Set the path to the cheat sheets cache file, can be overriden from
" .vimrc with:
"               let g:cheats_dir = '/path/to/your/cache/file'
let g:cheats_dir = get(g:, 'cheats_dir', $HOME . '/.cheat/')

" Set the split direction for the output buffer.
" It can be overriden from .vimrc as well, by setting g:cheats_split to hor | ver
let s:cheats_split = get(g:, 'cheats_split', 'hor')

" Constants
let s:splitCmdMap = { 'ver' : 'vsp' ,  'hor' : 'sp' }

let s:cheat_options = {"-add" : "add new cheatsheet" , "-update" : "update current cheatsheet"}

" Func Defs
func! FindOrCreateOutWin(bufName)
    let l:outWinNr = bufwinnr(a:bufName)
    let l:outBufNr = bufnr(a:bufName)

    " Find or create a window for the bufName
    if l:outWinNr == -1
        " Create a new window
        exec s:splitCmdMap[s:cheats_split]

        let l:outWinNr = bufwinnr('%')
        if l:outBufNr != -1
            " The buffer already exists. Open it here.
            exec 'b'.l:outBufNr
        endif
        " Jump back to the previous window the user was editing in.
        exec 'wincmd p'
    endif

    " Find the buffer number or create one for bufName
    if l:outBufNr == -1
        " Jump to the output window
        exec l:outWinNr.' wincmd w'
        " Open a new output buffer
        exec 'e '.a:bufName
        setlocal noswapfile
        setlocal buftype=nofile
        setlocal wrap
        let l:outBufNr = bufnr('%')
        " Jump back to the previous window the user was editing in.
        exec 'wincmd p'
    endif
    return l:outBufNr
endf

func! RunAndRedirectOut(cheatName, bufName)
    " Change to the output buffer window
    let l:outWinNr = bufwinnr(a:bufName)
    exec l:outWinNr.' wincmd w'

    call append(0, readfile(fnameescape(g:cheats_dir . a:cheatName)))
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
    let l:c = a:0 != 0 ? a:000 : split(input('Cheat Sheet: ', '', 'custom,CheatCompletion'),' ')
    if len(l:c) == 1 && l:c[0] !~ '^-\w*'
        let l:outBuf = FindOrCreateOutWin('-cheat_output-')
        call RunAndRedirectOut(l:c[0], l:outBuf)
    elseif len(l:c) == 2 && l:c[0] ==# '-add' && l:c[1] !~ '^-\w*'
        if index(cheat#List_sheets(), l:c[1]) == -1
            exe "split ". g:cheats_dir . fnameescape(l:c[1])
        else
            echohl WarningMsg | echom "cheets " . l:c[1] . " already exists" | echohl None
        endif
    elseif len(l:c) == 2 && l:c[0] ==# '-update' && l:c[1] !~ '^-\w*'
        call cheat#Update(l:c[1])
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
