let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#lcd#call(range, args, mods) abort
  let args = a:args.clone()
  call args.set('--local', 1)
  call gina#command#cd#call(a:range, args, a:mods)
endfunction

function! gina#command#lcd#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(1))
    return gina#complete#filename#directory(a:arglead, a:cmdline, a:cursorpos)
  endif
  return []
endfunction
