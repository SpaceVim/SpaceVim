function! gina#command#_shell#call(range, args, mods) abort
  let git = gina#core#get()
  let args = gina#process#build_raw_args(git, s:build_args(git, a:args))
  let cmdline = join(map(args, 's:shellescape(v:val)'))
  if has('nvim')
    tabnew
    execute ':terminal' cmdline
    augroup gina_command__shell_internal
      autocmd! * <buffer>
      autocmd TermClose <buffer> call gina#core#emitter#emit('modified:delay')
    augroup END
  else
    execute ':!' cmdline
    call gina#core#emitter#emit('modified:delay')
  endif
endfunction


" Private --------------------------------------------------------------------
function! s:build_args(git, args) abort
  let args = a:args.clone()
  if args.get(0) ==# '_shell'
    " Remove leading '_shell' if exists
    call args.pop(0)
  endif
  return args.lock()
endfunction

function! s:shellescape(val) abort
  return a:val =~# '\s' ? shellescape(a:val) : a:val
endfunction
