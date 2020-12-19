"=============================================================================
" FILE: dein.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#dein#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name': 'dein',
      \ 'description': 'candidates from dein plugins',
      \ 'hooks': {},
      \ }

function! s:source.hooks.on_init(args, context) abort
  let a:context.source__bang = index(a:args, '!') >= 0
  let a:context.source__plugins = values(dein#get())
endfunction

" Filters
function! s:source.source__converter(candidates, context) abort
  for candidate in a:candidates
    let type = dein#util#_get_type(candidate.source__type)
    let candidate.source__uri = has_key(type, 'get_uri') ?
          \ type.get_uri(candidate.action__plugin.repo,
          \              candidate.action__plugin) : ''
    if candidate.source__uri =~#
          \ '^\%(https\?\|git\)://github.com/'
      let candidate.action__uri = candidate.source__uri
      let candidate.action__uri =
            \ substitute(candidate.action__uri, '^git://', 'https://', '')
      let candidate.action__uri =
            \ substitute(candidate.action__uri, '.git$', '', '')
    endif
  endfor

  return a:candidates
endfunction

let s:source.converters = s:source.source__converter


function! s:source.gather_candidates(args, context) abort
  let _ = map(copy(a:context.source__plugins), "{
        \ 'word': substitute(v:val.repo,
        \  '^\%(https\?\|git\)://\%(github.com/\)\?', '', ''),
        \ 'kind': 'dein',
        \ 'action__path': v:val.path,
        \ 'action__directory': v:val.path,
        \ 'action__plugin': v:val,
        \ 'action__plugin_name': v:val.name,
        \ 'source__type': v:val.type,
        \ 'source__is_sourced': v:val.sourced,
        \ 'source__is_installed': isdirectory(v:val.path),
        \ 'is_multiline': 1,
        \ }
        \")

  let max = max(map(copy(_), 'len(v:val.word)'))

  call unite#print_source_message(
        \ '#: not sourced, X: not installed', self.name)

  for candidate in _
    let candidate.abbr =
          \ !candidate.source__is_installed ? 'X' :
          \ candidate.source__is_sourced ? ' ' : '#'
    let candidate.abbr .= ' ' . unite#util#truncate(candidate.word, max)

    if a:context.source__bang
      let status = s:get_commit_status(candidate.action__plugin)
      if status !=# ''
        let candidate.abbr .= "\n   " . status
      endif
    endif
  endfor

  return _
endfunction

function! s:get_commit_status(plugin) abort
  if !isdirectory(a:plugin.path)
    return 'Not installed'
  endif

  let type = dein#types#git#define()
  let cmd = type.get_revision_number_command(a:plugin)
  if cmd ==# ''
    return ''
  endif

  let cwd = getcwd()
  try
    call dein#install#_cd(a:plugin.path)
    let output = dein#install#_system(cmd)
  finally
    call dein#install#_cd(cwd)
  endtry

  if dein#install#_get_last_status()
    return printf('Error(%d) occurred when executing "%s"',
          \ dein#install#_get_last_status(), cmd)
  endif

  return output
endfunction
