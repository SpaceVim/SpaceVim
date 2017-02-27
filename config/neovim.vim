function! s:GetVisual()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][:col2 - 2]
    let lines[0] = lines[0][col1 - 1:]
    return lines
endfunction

function! REPLSend(lines)
    call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction
" }}}
" Commands {{{
" REPL integration {{{
command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
command! REPLSendLine call REPLSend([getline('.')])
" }}}
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2
"silent! let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"silent! let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"silent! let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" dark0 + gray
let g:terminal_color_0 = '#282828'
let g:terminal_color_8 = '#928374'

" neurtral_red + bright_red
let g:terminal_color_1 = '#cc241d'
let g:terminal_color_9 = '#fb4934'

" neutral_green + bright_green
let g:terminal_color_2 = '#98971a'
let g:terminal_color_10 = '#b8bb26'

" neutral_yellow + bright_yellow
let g:terminal_color_3 = '#d79921'
let g:terminal_color_11 = '#fabd2f'

" neutral_blue + bright_blue
let g:terminal_color_4 = '#458588'
let g:terminal_color_12 = '#83a598'

" neutral_purple + bright_purple
let g:terminal_color_5 = '#b16286'
let g:terminal_color_13 = '#d3869b'

" neutral_aqua + faded_aqua
let g:terminal_color_6 = '#689d6a'
let g:terminal_color_14 = '#8ec07c'

" light4 + light1
let g:terminal_color_7 = '#a89984'
let g:terminal_color_15 = '#ebdbb2'
augroup Terminal
    au!
    au TermOpen * let g:last_terminal_job_id = b:terminal_job_id | IndentLinesDisable
    au BufWinEnter term://* startinsert | IndentLinesDisable
    au TermClose * exe expand('<abuf>').'bd!'
augroup END
augroup nvimrc_aucmd
    autocmd!
    autocmd CursorHold,FocusGained,FocusLost * rshada|wshada
augroup END
