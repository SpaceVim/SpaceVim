" MIT License. Copyright (c) 2013-2020 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#init#bootstrap()

" couple of static variables. Those should not change within a session, thus
" can be initialized here as "static"
let s:spc = g:airline_symbols.space
let s:nomodeline = (v:version > 703 || (v:version == 703 && has("patch438"))) ? '<nomodeline>' : ''
let s:has_strchars = exists('*strchars')
let s:has_strcharpart = exists('*strcharpart')
let s:focusgained_ignore_time = 0

" TODO: Try to cache winwidth(0) function
" e.g. store winwidth per window and access that, only update it, if the size
" actually changed.
function! airline#util#winwidth(...)
  let nr = get(a:000, 0, 0)
  if get(g:, 'airline_statusline_ontop', 0)
    return &columns
  else
    return winwidth(nr)
  endif
endfunction

function! airline#util#shorten(text, winwidth, minwidth, ...)
  if airline#util#winwidth() < a:winwidth && len(split(a:text, '\zs')) > a:minwidth
    if get(a:000, 0, 0)
      " shorten from tail
      return '…'.matchstr(a:text, '.\{'.a:minwidth.'}$')
    else
      " shorten from beginning of string
      return matchstr(a:text, '^.\{'.a:minwidth.'}').'…'
    endif
  else
    return a:text
  endif
endfunction

function! airline#util#wrap(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  return a:text
endfunction

function! airline#util#append(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  let prefix = s:spc == "\ua0" ? s:spc : s:spc.s:spc
  return empty(a:text) ? '' : prefix.g:airline_left_alt_sep.s:spc.a:text
endfunction

function! airline#util#warning(msg)
  echohl WarningMsg
  echomsg "airline: ".a:msg
  echohl Normal
endfunction

function! airline#util#prepend(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  return empty(a:text) ? '' : a:text.s:spc.g:airline_right_alt_sep.s:spc
endfunction

if v:version >= 704
  function! airline#util#getbufvar(bufnr, key, def)
    return getbufvar(a:bufnr, a:key, a:def)
  endfunction
else
  function! airline#util#getbufvar(bufnr, key, def)
    let bufvals = getbufvar(a:bufnr, '')
    return get(bufvals, a:key, a:def)
  endfunction
endif

if v:version >= 704
  function! airline#util#getwinvar(winnr, key, def)
    return getwinvar(a:winnr, a:key, a:def)
  endfunction
else
  function! airline#util#getwinvar(winnr, key, def)
    let winvals = getwinvar(a:winnr, '')
    return get(winvals, a:key, a:def)
  endfunction
endif

if v:version >= 704
  function! airline#util#exec_funcrefs(list, ...)
    for Fn in a:list
      let code = call(Fn, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
else
  function! airline#util#exec_funcrefs(list, ...)
    " for 7.2; we cannot iterate the list, hence why we use range()
    " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
    for i in range(0, len(a:list) - 1)
      let Fn{i} = a:list[i]
      let code = call(Fn{i}, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
endif

" Compatibility wrapper for strchars, in case this vim version does not
" have it natively
function! airline#util#strchars(str)
  if s:has_strchars
    return strchars(a:str)
  else
    return strlen(substitute(a:str, '.', 'a', 'g'))
  endif
endfunction

function! airline#util#strcharpart(...)
  if s:has_strcharpart
    return call('strcharpart',  a:000)
  else
    " does not handle multibyte chars :(
    return a:1[(a:2):(a:3)]
  endif
endfunction

function! airline#util#ignore_buf(name)
  let pat = '\c\v'. get(g:, 'airline#ignore_bufadd_pat', '').
        \ get(g:, 'airline#extensions#tabline#ignore_bufadd_pat', 
        \ '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler')
  return match(a:name, pat) > -1
endfunction

function! airline#util#has_fugitive()
  if !exists("s:has_fugitive")
    let s:has_fugitive = exists('*fugitive#head') || exists('*FugitiveHead')
  endif
  return s:has_fugitive
endfunction

function! airline#util#has_gina()
  if !exists("s:has_gina")
    let s:has_gina = (exists(':Gina') && v:version >= 800)
  endif
  return s:has_gina
endfunction


function! airline#util#has_lawrencium()
  if !exists("s:has_lawrencium")
    let s:has_lawrencium  = exists('*lawrencium#statusline')
  endif
  return s:has_lawrencium
endfunction

function! airline#util#has_vcscommand()
  if !exists("s:has_vcscommand")
    let s:has_vcscommand = exists('*VCSCommandGetStatusLine')
  endif
  return get(g:, 'airline#extensions#branch#use_vcscommand', 0) && s:has_vcscommand
endfunction

function! airline#util#has_custom_scm()
  return !empty(get(g:, 'airline#extensions#branch#custom_head', ''))
endfunction

function! airline#util#doautocmd(event)
  exe printf("silent doautocmd %s User %s", s:nomodeline, a:event)
endfunction

function! airline#util#themes(match)
  let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:match.'*.vim'), "\n")
  return sort(map(files, 'fnamemodify(v:val, ":t:r")') + ('random' =~ a:match ? ['random'] : []))
endfunction

function! airline#util#stl_disabled(winnr)
  " setting the statusline is disabled,
  " either globally, per window, or per buffer
  " w:airline_disabled is deprecated!
  return get(g:, 'airline_disable_statusline', 0) ||
   \ airline#util#getwinvar(a:winnr, 'airline_disable_statusline', 0) ||
   \ airline#util#getwinvar(a:winnr, 'airline_disabled', 0) ||
   \ airline#util#getbufvar(winbufnr(a:winnr), 'airline_disable_statusline', 0)
endfunction

function! airline#util#ignore_next_focusgain()
  if has('win32')
    " Setup an ignore for platforms that trigger FocusLost on calls to
    " system(). macvim (gui and terminal) and Linux terminal vim do not.
    let s:focusgained_ignore_time = localtime()
  endif
endfunction

function! airline#util#try_focusgained()
  " Ignore lasts for at most one second and is cleared on the first
  " focusgained. We use ignore to prevent system() calls from triggering
  " FocusGained (which occurs 100% on win32 and seem to sometimes occur under
  " tmux).
  let dt = localtime() - s:focusgained_ignore_time
  let s:focusgained_ignore_time = 0
  return dt >= 1
endfunction

