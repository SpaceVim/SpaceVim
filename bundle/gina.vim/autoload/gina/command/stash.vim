let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#stash#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options_save())

  let git = gina#core#get_or_fail()
  let command = a:args.get(1, 'save')
  if command ==# 'show'
    return gina#command#stash#show#call(a:range, a:args, a:mods)
  elseif command ==# 'list'
    return gina#command#stash#list#call(a:range, a:args, a:mods)
  endif
  return gina#command#_raw#call(a:range, a:args, a:mods)
endfunction

function! gina#command#stash#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if args.get(1) ==# 'list'
    return gina#command#stash#list#complete(a:arglead, a:cmdline, a:cursorpos)
  elseif args.get(1) ==# 'show'
    return gina#command#stash#show#complete(a:arglead, a:cmdline, a:cursorpos)
  elseif args.get(1) =~# '^\%(save\|\)$'
    if a:arglead =~# '^-'
      let options = s:get_options_save()
      return options.complete(a:arglead, a:cmdline, a:cursorpos)
    endif
  elseif args.get(1) ==# 'drop'
    return gina#complete#stash#any(a:arglead, a:cmdline, a:cursorpos)
  elseif args.get(1) =~# '^\%(pop\|apply\)$'
    if a:arglead =~# '^-' || !empty(args.get(2))
      let options = s:get_options_pop()
      return options.complete(a:arglead, a:cmdline, a:cursorpos)
    endif
    return gina#complete#stash#any(a:arglead, a:cmdline, a:cursorpos)
  elseif args.get(1) ==# 'branch'
    if empty(args.get(2))
      return gina#complete#commit#branch(a:arglead, a:cmdline, a:cursorpos)
    endif
    return gina#complete#stash#any(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#util#filter(a:arglead, [
        \ 'list',
        \ 'show',
        \ 'drop',
        \ 'pop',
        \ 'apply',
        \ 'branch',
        \ 'save',
        \ 'clear',
        \ 'create',
        \ 'store',
        \])
endfunction


" Private --------------------------------------------------------------------
function! s:get_options_save() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '-k|--keep-index',
        \ 'Left intact all changes already added to the index',
        \)
  call options.define(
        \ '--no-keep-index',
        \ 'Do not left intact all changes already added to the index',
        \)
  call options.define(
        \ '-a|--all',
        \ 'The ignored files and untracked files are stashed and cleaned',
        \)
  call options.define(
        \ '--include-untracked',
        \ 'The untracked files are stashed and cleaned',
        \)
  return options
endfunction

function! s:get_options_pop() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--index',
        \ 'Tries to reinstate not only the working tree but also index',
        \)
  return options
endfunction
