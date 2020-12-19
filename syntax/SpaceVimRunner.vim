if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimRunner'
  finish
endif
let b:current_syntax = 'SpaceVimRunner'
syntax case ignore
syn match KeyBindings /\[Running\]/
syn match KeyBindings /\[Compile\]/
syn match RunnerCmd /\(\[Running\]\ \)\@<=.*/
syn match RunnerCmd /\(\[Compile\]\ \)\@<=.*/
syn match DoneSucceeded /\[Done]\(\ exited\ with\ code=0\)\@=/
syn match DoneFailed /\[Done]\(\ exited\ with\ code=[^0]\)\@=/
syn match ExitCode /\(\[Done\]\ exited\ with \)\@<=code=0/
syn match ExitCodeFailed /\(\[Done\]\ exited\ with \)\@<=code=[^0]/

hi def link RunnerCmd Comment
hi def link KeyBindings String
hi def link DoneSucceeded String
hi def link DoneFailed WarningMsg
hi def link ExitCode MoreMsg
hi def link ExitCodeFailed WarningMsg
let s:shellcmd_colors =
      \ [
      \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
      \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
      \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
      \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
      \]
function! s:highlight_shell_cmd() abort

  let highlight_table = {
        \ '0' : ' cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE',
        \ '1' : ' cterm=BOLD gui=BOLD',
        \ '3' : ' cterm=ITALIC gui=ITALIC',
        \ '4' : ' cterm=UNDERLINE gui=UNDERLINE',
        \ '7' : ' cterm=REVERSE gui=REVERSE',
        \ '8' : ' ctermfg=0 ctermbg=0 guifg=#000000 guibg=#000000',
        \ '9' : ' gui=UNDERCURL',
        \ '21' : ' cterm=UNDERLINE gui=UNDERLINE',
        \ '22' : ' gui=NONE',
        \ '23' : ' gui=NONE',
        \ '24' : ' gui=NONE',
        \ '25' : ' gui=NONE',
        \ '27' : ' gui=NONE',
        \ '28' : ' ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE',
        \ '29' : ' gui=NONE',
        \ '39' : ' ctermfg=NONE guifg=NONE',
        \ '49' : ' ctermbg=NONE guibg=NONE',
        \ '90' : ' ctermfg=245 guifg=#928374',
        \ '95' : ' ctermfg=175 guifg=#d3869b',
        \}
  for color in range(30, 37)
    " Foreground color pattern.
    let highlight_table[color] = printf(' ctermfg=%d guifg=%s',
          \ color - 30, s:shellcmd_colors[color - 30])
    for color2 in [1, 3, 4, 7]
      " Type;Foreground color pattern
      let highlight_table[color2 . ';' . color] =
            \ highlight_table[color2] . highlight_table[color]
    endfor
  endfor
  for color in range(40, 47)
    " Background color pattern.
    let highlight_table[color] = printf(' ctermbg=%d guibg=%s',
          \ color - 40, s:shellcmd_colors[color - 40])
    for color2 in range(30, 37)
      " Foreground;Background color pattern.
      let highlight_table[color2 . ';' . color] =
            \ highlight_table[color2] . highlight_table[color]
    endfor
  endfor

  syntax match SpaceVimRunner__Output_Shellcmd_Conceal
        \ contained conceal    '\e\[[0-9;]*m'
        \ containedin=SpaceVimRunner__Output_Shellcmd

  syntax match SpaceVimRunner__Output_Shellcmd_Conceal
        \ contained conceal    '\e\[?1h'
        \ containedin=SpaceVimRunner__Output_Shellcmd

  syntax match uniteSource__Output_Shellcmd_Ignore
        \ contained conceal    '\e\[?\d[hl]\|\e=\r\|\r\|\e>'
        \ containedin=SpaceVimRunner__Output_Shellcmd

  for [key, highlight] in items(highlight_table)
    let syntax_name = 'SpaceVimRunner__Output_Shellcmd_Color'
          \ . substitute(key, ';', '_', 'g')
    let syntax_command = printf('start=+\e\[0\?%sm+ end=+\ze\e[\[0*m]\|$+ ' .
          \ 'contains=SpaceVimRunner__Output_Shellcmd_Conceal ' .
          \ 'containedin=SpaceVimRunner__Output_Shellcmd oneline', key)

    execute 'syntax region' syntax_name syntax_command
    execute 'highlight' syntax_name highlight
  endfor
endfunction

call s:highlight_shell_cmd()
