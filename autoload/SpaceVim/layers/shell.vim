""
" @section shell, layer-shell
" @parentsection layers
" SpaceVim uses deol.nvim for shell support in neovim and uses vimshell for
" vim. For more info, read |deol| and |vimshell|.
" @subsection variable
" default_shell
"

function! SpaceVim#layers#shell#plugins() abort
  let plugins = []
  if has('nvim')
    call add(plugins,['Shougo/deol.nvim'])
  endif
  call add(plugins,['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}])
  return plugins
endfunction

let s:file = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#shell#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ["'"], 'call call('
        \ . string(function('s:open_default_shell')) . ', [])',
        \ ['open shell',
        \ [
        \ "[SPC '] is to open or jump to default shell window",
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ], 1)

endfunction


let s:default_shell = 'terminal'
let s:default_position = 'top'
let s:default_height = 30

function! SpaceVim#layers#shell#set_variable(var) abort
  let s:default_shell = get(a:var, 'default_shell', 'terminal')
  let s:default_position = get(a:var, 'default_position', 'top')
  let s:default_height = get(a:var, 'default_height', 30)
endfunction

let s:shell_win_nr = 0
function! s:open_default_shell() abort
  if s:shell_win_nr != 0 && getwinvar(s:shell_win_nr, '&buftype') ==# 'terminal' && &buftype !=# 'terminal'
    exe s:shell_win_nr .  'wincmd w'
    startinsert
    return
  endif
  if &buftype ==# 'terminal'
    bwipeout! %
    return
  endif
  let cmd = s:default_position ==# 'top' ?
        \ 'topleft split' :
        \ s:default_position ==# 'bottom' ?
        \ 'botright split' :
        \ s:default_position ==# 'right' ?
        \ 'rightbelow vsplit' : 'leftabove vsplit'
  exe cmd
  let lines = &lines * s:default_height / 100
  if lines < winheight(0) && (s:default_position ==# 'top' || s:default_position ==# 'bottom')
    exe 'resize ' . lines
  endif
  if s:default_shell ==# 'terminal'
    if exists(':terminal')
      if has('nvim')
        exe 'terminal'
      else
        call term_start($SHELL, {'curwin' : 1, 'term_finish' : 'close'})
      endif
      let s:shell_win_nr = winnr()
      let w:shell_layer_win = 1
      startinsert
    else
      echo ':terminal is not supported in this version'
    endif
  elseif s:default_shell ==# 'VimShell'
    VimShell
    imap <buffer> <C-d> exit<esc><Plug>(vimshell_enter)
  endif
endfunction
