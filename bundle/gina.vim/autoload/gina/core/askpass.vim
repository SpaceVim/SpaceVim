let s:Path = vital#gina#import('System.Filepath')

let s:is_windows = has('win32') || has('win64')
let s:is_darwin = has('mac') || has('macunix')
let s:repository_root = expand('<sfile>:p:h:h:h:h')
let s:askpass_script = s:Path.join(s:repository_root, 'scripts', 'askpass')

if s:is_windows
  " Using an official credential helper 'wincred' helps.
  " See https://github.com/lambdalisue/gina.vim/pull/11#issuecomment-279541140
  let s:askpass_script = ''
elseif s:is_darwin
  " AFAI, no usable GUI ssh-askpass exist
  let s:askpass_script .= '.mac'
else
  if executable('zenity')
    let s:askpass_script .= '.zenity'
  else
    " ssh-askpass-gnome would help in this case
    let s:askpass_script = ''
  endif
endif

if s:is_windows
  " While Windows has an official credential which raise a GUI prompt, gina
  " won't touch askpass for Windows
  function! gina#core#askpass#wrap(git, args) abort
    return a:args
  endfunction
else
  function! gina#core#askpass#wrap(git, args) abort
    if empty(a:git)
      return a:args
    endif
    let prefix = ['env', 'GIT_TERMINAL_PROMPT=0']
    let askpass = s:askpass(a:git)
    if !empty(askpass)
      " NOTE:
      " '$GIT_ASKPASS' has a higest priority so use this instead of
      " '-c core.askpass=...' in Mac/Linux environment while 'env'
      " is available.
      let prefix += ['GIT_ASKPASS=' . askpass]
    endif
    return extend(a:args, prefix, 0)
  endfunction
endif


function! s:askpass(git) abort
  let config = gina#core#repo#config(a:git)
  let askpass = get(config, 'core.askpass', '')
  if !empty(g:gina#core#askpass#askpass_program)
    return g:gina#core#askpas#askpass_program
  elseif g:gina#core#askpass#force_internal
    return s:askpass_script
  elseif exists('$GIT_ASKPASS')
    return $GIT_ASKPASS
  elseif !empty(askpass)
    return askpass
  elseif exists('$SSH_ASKPASS')
    return $SSH_ASKPASS
  endif
  return s:askpass_script
endfunction


call gina#config(expand('<sfile>'), {
      \ 'askpass_program': '',
      \ 'force_internal': 0,
      \})
