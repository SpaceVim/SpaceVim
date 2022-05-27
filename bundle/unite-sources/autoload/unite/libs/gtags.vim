
let s:save_cpo = &cpo
set cpo&vim

" global cmd result option formats {{{
let s:format = {
      \ "ctags-mod" : {},
      \ "ctags-x" : {},
      \ }

function! s:format["ctags-x"].func(line)
  let l:items = matchlist(a:line, '\s\+\(\d\+\)\s\+\(.*\.\S\+\)\s\(.*\)$')
  if empty(l:items)
    call unite#print_error('[unite-gtags] unexpected result for ctags-x: ' . a:line)
    return {}
  else
    return {
          \  "kind": "jump_list",
          \  "word" : l:items[2] . ' |' . l:items[1] . '| ' . l:items[3],
          \  "action__path" : l:items[2],
          \  "action__line" : l:items[1],
          \  "action__text" : l:items[3],
          \}
  endif
endfunction

function! s:format["ctags-mod"].func(line)
  let l:items = matchlist(a:line, '^\([^\t]\+\)\t\+\(\d\+\)\t\+\(.\+\)$')
  if empty(l:items)
    call unite#print_error('[unite-gtags] unexpected result for ctags-mod: ' . a:line)
    return {}
  else
    return {
          \  "kind": "jump_list",
          \  "word" : l:items[1] . ' |' .  l:items[2] . '| ' . l:items[3],
          \  "action__path" : l:items[1],
          \  "action__line" : l:items[2],
          \  "action__text" : l:items[3],
          \}
  endif
endfunction
" }}}

let s:default_config = {
      \ "ref_option" : "rs -e",
      \ "def_option" : "d -e",
      \ "result_option" : "ctags-mod",
      \ "path_option" : "P -e",
      \ "global_cmd" : "global",
      \ "enable_nearness" : 0,
      \ }

let s:default_project_config_value = {
      \ 'treelize': 0,
      \ 'absolute_path': 0,
      \ 'gtags_libpath': [],
      \ 'through_all_tags': 0,
      \ }

function! unite#libs#gtags#get_global_config(key)
  return get(g:, "unite_source_gtags_". a:key, s:default_config[a:key])
endfunction

function! unite#libs#gtags#get_project_config(key)
  if !exists("g:unite_source_gtags_project_config") || type(g:unite_source_gtags_project_config) != type({})
    return s:default_project_config_value[a:key]
  endif
  let l:gtags_root_dir = exists("$GTAGSROOT") ? $GTAGSROOT : fnamemodify(".", ':p')
  let l:cd_config = get(g:unite_source_gtags_project_config, l:gtags_root_dir, get(g:unite_source_gtags_project_config, '_'))
  if type(l:cd_config) == type({})
    return get(l:cd_config, a:key, s:default_project_config_value[a:key])
  else
    return s:default_project_config_value[a:key]
endif
endfunction

" execute global command and return result
function! unite#libs#gtags#exec_global(options)
  let l:long = get(a:options, 'long', '') .
        \ (unite#libs#gtags#get_global_config("enable_nearness") ? " --nearness=\"" . fnamemodify(expand('%:p'), ':h') . "\"" : '') .
        \ (unite#libs#gtags#get_project_config("through_all_tags") ? " --through" : '')
  let l:short = get(a:options, 'short', '') . (unite#libs#gtags#get_project_config("absolute_path") ? "a" : '')
  " build command
  let l:cmd = printf("%s %s -q%s %s",
        \ unite#libs#gtags#get_global_config("global_cmd"),
        \ l:long,
        \ l:short,
        \ g:unite_source_gtags_shell_quote . get(a:options, 'pattern', '') . g:unite_source_gtags_shell_quote)

  let l:gtags_libpath = unite#libs#gtags#get_project_config("gtags_libpath")
  if !empty(l:gtags_libpath)
    if type(l:gtags_libpath) == type([])
      " TODO: judge platform (*nix or windows)
      let l:cmd = "GTAGSLIBPATH=" . $GTAGSLIBPATH . ':' . join(l:gtags_libpath, ':') . ' ' . l:cmd
    else
      call unite#print_error('[unite-gtags] gtags_libpath must be list')
    endif
  endif

  " specify --result option
  if get(a:options, 'disable_result_option', 0)
    let l:built_cmd = printf("%s", l:cmd)
  else
    let l:result_option = unite#libs#gtags#get_global_config("result_option")
    let l:built_cmd = printf("%s --result=%s", l:cmd, result_option)
  endif

  let l:result = system(l:built_cmd)

  if v:shell_error != 0
    " exit global command with error
    if v:shell_error == 1
      call unite#print_error("[unite-gtags] Warning: file does not exists")
    elseif v:shell_error == 2
      " specified args include unsupported one
      call unite#print_error('[unite-gtags] any specified args are not supported cmd:"'. l:built_cmd . '". outputs: '. l:result)
      let l:versoin_info = get(split(system(printf("%s --version", unite#libs#gtags#get_global_config("global_cmd"))), '\r\n\|\r\|\n'), 0)
      call unite#print_error('[unite-gtags] ' . l:versoin_info)
      return ''
    elseif v:shell_error == 3
      call unite#print_error("[unite-gtags] Warning: GTAGS not found")
    elseif v:shell_error == 126
      call unite#print_error("[unite-gtags] Warning: ". g:unite_source_gtags_global_cmd . " permission denied")
    elseif v:shell_error == 127
      call unite#print_error("[unite-gtags] Warning: ". g:unite_source_gtags_global_cmd . " command not found in PATH")
    else
      " unknown error
      call unite#print_error('[unite-gtags] global command failed. command line: ' . l:built_cmd . '. exit with '. string(v:shell_error))
    endif
    " interruppt execution
    return ''
  else
    return l:result
  endif
endfunction

function! unite#libs#gtags#result_as_filepath(source, result, context)
  if empty(a:result)
    return []
  endif
  return unite#helper#paths2candidates(split(a:result, '\r\n\|\r\|\n'))
endfunction

" build unite items from global command result
function! unite#libs#gtags#result2unite(source, result, context)
  if empty(a:result)
    return []
  endif
  let l:candidates =  map(split(a:result, '\r\n\|\r\|\n'),
        \ 's:format["'. unite#libs#gtags#get_global_config("result_option") . '"].func(v:val)')
  let l:candidates = filter(l:candidates, '!empty(v:val)')
  let l:candidates = map(l:candidates, 'extend(v:val, {"source" : a:source})')
  let a:context.is_treelized = !(a:context.immediately && len(l:candidates) == 1) &&
        \ unite#libs#gtags#get_project_config('treelize')
  if a:context.is_treelized
    return unite#libs#gtags#treelize(l:candidates)
  else
    return l:candidates
  endif
endfunction

" group candidates by action__path for tree like view
function! unite#libs#gtags#treelize(candidates)
  let l:candidates = []
  let l:root = {}
  for l:cand in a:candidates
    if !has_key(l:root, l:cand.action__path)
      let l:root[l:cand.action__path] = {
            \ 'abbr' : "[path] " . l:cand.action__path,
            \ 'word' : l:cand.action__path,
            \ 'action__path' : l:cand.action__path,
            \ 'kind' : 'jump_list',
            \ 'node' : 1,
            \ 'children' : []
            \}
    endif
    let l:node = l:root[l:cand.action__path]
    let l:cand['word'] = "|" . l:cand['action__line'] . "|  " . l:cand['action__text']
    call add(l:node.children, l:cand)
  endfor
  for l:cand in values(l:root)
    call add(l:candidates, l:cand)
    call extend(l:candidates, l:cand.children)
  endfor
  return l:candidates
endfunction

" group candidates by action__path for tree like view
function! unite#libs#gtags#on_syntax(args, context)
  if a:context.is_treelized
    syntax match uniteSource__Gtags_LineNr /\zs|\d\+|\ze/  contained containedin=uniteSource__Gtags
    syntax match uniteSource__Gtags_Path /\[path\]\s[^\s].*$/ contained containedin=uniteSource__Gtags
  else
    syntax match uniteSource__Gtags_LineNr /\s\zs|\d\+|\ze\s/  contained containedin=uniteSource__Gtags
    syntax match uniteSource__Gtags_Path /\zs.\+\ze\s|\d\+|\s/ contained containedin=uniteSource__Gtags
  endif
  highlight default link uniteSource__Gtags_LineNr LineNr
  highlight default link uniteSource__Gtags_Path File
endfunction

" initialize context.treelize
function! unite#libs#gtags#on_init_common(args, context)
  let a:context.is_treelized = 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
