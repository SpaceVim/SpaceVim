"=============================================================================
" FILE: vimfiler/execute.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#vimfiler_execute#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'vimfiler/execute',
      \ 'description' : 'candidates from vimfiler execute list',
      \ 'hooks' : {},
      \ 'is_listed' : 0,
      \ }

function! s:source.hooks.on_init(args, context) abort
  let winnr = winnr()
  try
    call vimfiler#util#winmove(a:context.vimfiler__winnr)

    if &filetype !=# 'vimfiler'
      return []
    endif

    let a:context.source__file = vimfiler#get_file(b:vimfiler, line('.'))
  finally
    call vimfiler#util#winmove(winnr)
  endtry
  if &filetype !=# 'vimfiler'
    return
  endif
endfunction

function! s:source.gather_candidates(args, context) abort
  if !has_key(a:context, 'source__file')
    return []
  endif

  " Search user execute file.
  let ext = a:context.source__file.vimfiler__extension

  let candidates = []
  let commands = get(g:vimfiler_execute_file_list, ext,
        \ get(g:vimfiler_execute_file_list, '_', []))
  for command in type(commands) == type([]) ?
        \ commands : [commands]
    let dict = { 'word' : command }

    if command ==# 'vim'
        call unite#print_error(printf(
              \ '[vimfiler/execute] You cannot edit "%s" by vimfiler/execute.',
              \ a:context.source__file.action__path))
        return []
    elseif !executable(command)
        call unite#print_error(printf(
              \ '[vimfiler/execute] Command "%s" is not executable file.', command))
        return []
    else
      let dict.kind = 'guicmd'
      let dict.action__path = command
      let dict.action__args =
            \ [a:context.source__file.action__path]
    endif

    call add(candidates, dict)
  endfor

  return candidates
endfunction
