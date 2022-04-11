" lookup#lookup() {{{1
"
" Entry point. Map this function to your favourite keys.
"
" autocmd FileType vim nnoremap <buffer><silent> <cr> :call lookup#lookup()<cr>
"
function! lookup#lookup() abort
  let dispatch = [
        \ [function('s:find_local_var_def'), function('s:find_local_func_def')],
        \ [function('s:find_autoload_var_def'), function('s:find_autoload_func_def')]]
  let isk = &iskeyword
  setlocal iskeyword+=:,<,>,#
  let name = matchstr(getline('.'), '\k*\%'.col('.').'c\k*[("'']\?')
  let plug = matchstr(getline('.'), '\c<plug>\k*\%'.col('.').'c\k*[("'']\?')
  let &iskeyword = isk
  let is_func = name =~ '($' ? 1 : 0
  let could_be_funcref = name =~ '[''"]$' ? 1 : 0
  let is_cmd = name =~# '\v^\u\w*>'
  let name = matchstr(name, '\c\v^%(s:|\<sid\>)?\zs.{-}\ze[\("'']?$')
  let is_auto = name =~ '#' ? 1 : 0
  let position = s:getcurpos()
  try
    if is_cmd && s:find_local_cmd_def(name)
      " Found command.
    elseif !dispatch[is_auto][is_func](name) && !is_func && could_be_funcref
      let is_func = 1
      call dispatch[is_auto][is_func](name)
    elseif !empty(plug) && s:find_plug_map_def(plug)
      " Found plug.
    endif
  catch /^Vim\%((\a\+)\)\=:/
    echohl ErrorMsg
    " Strip off the :edit command prefix to make it look like a normal vim
    " error message.
    echomsg substitute(v:exception, "^[^:]*:", "", "")
    echohl NONE
    return 0
  endtry
  let didmove = position != s:getcurpos() ? 1 : 0
  if didmove
    call s:push(position, name)
  else
    echo 'No match'
    return 0
  endif
  normal! zv
  return didmove
endfunction

" lookup#pop() {{{1
function! lookup#pop()
  if !has_key(w:, 'lookup_stack') || empty(w:lookup_stack)
    echohl ErrorMsg
    echo "lookup stack empty"
    echohl NONE
    return
  endif
  let pos = remove(w:lookup_stack, 0)
  execute 'silent!' (bufexists(pos[0]) ? 'buffer' : 'edit') fnameescape(pos[0])
  call cursor(pos[2:])
endfunction

" s:find_local_func_def() {{{1
function! s:find_local_func_def(funcname) abort
  if search('\c\v<fu%[nction]!?\s+%(s:|\<sid\>)\zs\V'.a:funcname.'\>', 'bsw') != 0
    return
  endif

  call s:jump_to_file_defining('function', a:funcname)
  let fn = substitute(a:funcname, '^g:', '', '')
  return search('\c\v<fu%[nction]!?\s+%(g:)?\zs\V'.fn.'\>', 'bsw')
endfunction

" s:find_local_cmd_def() {{{1
function! s:find_local_cmd_def(cmdname) abort
  let pattern = '\c\v<com%[mand]!?\s+(-\w+.{-}\s+)*\zs\V'.a:cmdname.'\>'
  if search(pattern, 'bsw') != 0
    return
  endif

  call s:jump_to_file_defining('command', a:cmdname)
  return search(pattern, 'bsw')
endfunction

" s:find_plug_map_def() {{{1
function! s:find_plug_map_def(plugname) abort
  let pattern = '\c\v<[nvxsoilct]?(nore)?m%[ap]\s*(\<[bnseu]\w+\>\s*)*\s+\zs\V'.a:plugname.'\>'
  if search(pattern, 'bsw') != 0
    return
  endif

  call s:jump_to_file_defining('map', a:plugname)
  return search(pattern, 'bsw')
endfunction

" s:jump_to_file_defining() {{{1
" Expects symbol_type = 'command' or 'function'
function! s:jump_to_file_defining(symbol_type, symbol_name) abort
  let lang = v:lang
  language message C
  redir => location
    silent! execute 'verbose ' a:symbol_type a:symbol_name
  redir END
  let failed = 0
  if a:symbol_type == 'command'
    let failed = location =~# 'No user-defined commands found'
  endif
  silent! execute 'language message' lang

  if failed || location =~# 'E\d\{2,3}:'
    return
  endif

  let matches = matchlist(location, '\v.*Last set from (.*) line (\d+)>')
  execute 'silent edit +'. matches[2] matches[1]
endfunction

" s:find_local_var_def() {{{1
function! s:find_local_var_def(name) abort
  return search('\c\v<let\s+s:\zs\V'.a:name.'\>', 'bsw')
endfunction

" s:find_autoload_func_def() {{{1
function! s:find_autoload_func_def(name) abort
  let [path, func] = split(a:name, '.*\zs#')
  let pattern = '\c\v<fu%[nction]!?\s+\zs\V'. path .'#'. func .'\>'
  return s:find_autoload_def(path, pattern)
endfunction

" s:find_autoload_var_def() {{{1
function! s:find_autoload_var_def(name) abort
  let [path, var] = split(a:name, '.*\zs#')
  let pattern = '\c\v<let\s+\zs\V'. path .'#'. var .'\>'
  return s:find_autoload_def(path, pattern)
endfunction

" s:find_autoload_def() {{{1
function! s:find_autoload_def(name, pattern) abort
  for dir in ['autoload', 'plugin']
    let path = printf('%s/%s.vim', dir, substitute(a:name, '#', '/', 'g'))
    let aufiles = globpath(&runtimepath, path, '', 1)
    if empty(aufiles) && exists('b:git_dir')
      let aufiles = [fnamemodify(b:git_dir, ':h') .'/'. path]
    endif
    if empty(aufiles)
      return search(a:pattern)
    else
      for file in aufiles
        if !filereadable(file)
          continue
        endif
        let lnum = match(readfile(file), a:pattern)
        if lnum > -1
          execute 'silent edit +'. (lnum+1) fnameescape(file)
          call search(a:pattern)
          return 1
          break
        endif
      endfor
    endif
  endfor
  return 0
endfunction

" s:push() {{{1
function! s:push(position, tagname) abort
  call s:pushtagstack(a:position[1:], a:tagname)
  if !has_key(w:, 'lookup_stack') || empty(w:lookup_stack)
    let w:lookup_stack = [a:position]
    return
  endif
  if w:lookup_stack[0] != a:position
    call insert(w:lookup_stack, a:position)
  endif
endfunction

" s:pushtagstack() {{{1
function! s:pushtagstack(curpos, tagname) abort
    if !exists('*gettagstack') || !exists('*settagstack') || !has('patch-8.2.0077') " patch that adds 't' argument
        " do nothing
        return
    endif

    let item = {'bufnr': a:curpos[0], 'from': a:curpos, 'tagname': a:tagname}

    let winid = win_getid()
    let stack = gettagstack(winid)
    let stack['items'] = [item]
    call settagstack(winid, stack, 't')
endfunction

" s:getcurpos() {{{1
function! s:getcurpos() abort
  let pos = getcurpos()
  " getcurpos always returns bufnr 0.
  let pos[0] = bufnr('%')
  return [expand('%:p')] + pos
endfunction
