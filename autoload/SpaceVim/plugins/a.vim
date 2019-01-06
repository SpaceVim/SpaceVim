let s:CMP = SpaceVim#api#import('vim#compatible')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:conf = '.project_alt.json'

let s:project_config = {}

function! SpaceVim#plugins#a#set_config_name(name)

  let s:conf = a:name

endfunction

function! SpaceVim#plugins#a#alt()
  let g:altconfa = {}
  try
    let g:altconfa = s:JSON.json_decode(join(readfile(s:conf), "\n"))
    let s:project_config[s:conf] = {}
  catch
  endtry
  if empty(g:altconfa)
    echohl WarningMsg
    echo 'failed to file .projections.json'
    echohl None
  endif
  let file = s:FILE.unify_path(bufname('%'), ':.')
  if has_key(g:altconfa, file)
    let alt = get(g:altconfa[file], 'alternate', '')
    if !empty(alt)
      exe 'e ' . alt
    endif
  endif
  call s:paser(g:altconfa)
endfunction

function! s:paser(conf) abort
  for key in keys(a:conf)
    for file in s:CMP.globpath('.', key)
      let file = s:FILE.unify_path(file, ':.')
      let conf = a:conf[key]
      if has_key(conf, 'alternate')
        let begin_end = split(key, '*')
        if len(begin_end) == 2
          let s:project_config[s:conf][file] = {'alternate' : s:generate(begin_end, file, a:conf[key]['alternate'])}
        endif
      endif
    endfor
  endfor
endfunction

function! s:generate(a, f, b) abort
  let begin_len = strlen(a:a[0])
  let end_len = strlen(a:a[1])
  "docs/*.md": {"alternate": "docs/cn/{}.md"},
  "begin_end = 5
  "end_len = 3
  "docs/index.md
  return substitute(a:b, '{}', a:f[begin_len : (end_len+1) * -1], 'g')
endfunction

function! Log() abort
  return s:project_config
endfunction
