let s:Cache = vital#gina#import('System.Cache.Memory')
let s:Path = vital#gina#import('System.Filepath')


function! gina#complete#common#opener(arglead, cmdline, cursorpos) abort
  if a:arglead !~# '^--opener='
    return []
  endif
  let candidates = [
        \ 'split',
        \ 'vsplit',
        \ 'tabedit',
        \ 'pedit',
        \]
  let prefix = '--opener='
  return gina#util#filter(a:arglead, map(candidates, 'prefix . v:val'))
endfunction

function! gina#complete#common#treeish(arglead, cmdline, cursorpos) abort
  if a:arglead =~# '^[^:]*:'
    let revision = matchstr(a:arglead, '^[^:]*\ze:')
    let candidates = gina#complete#filename#tracked(
          \ matchstr(a:arglead, '^[^:]*:\zs.*'),
          \ a:cmdline,
          \ a:cursorpos,
          \ revision,
          \)
    return map(candidates, 'revision . '':'' . v:val')
  else
    let candidates = gina#complete#range#any(a:arglead, a:cmdline, a:cursorpos)
    return map(candidates, 'v:val . '':''')
  endif
endfunction

function! gina#complete#common#command(arglead, cmdline, cursorpos) abort
  let cache = s:get_cache()
  if !cache.has('command_names')
    call cache.set('command_names', s:get_command_names())
  endif
  let command_names = cache.get('command_names')
  return gina#util#filter(a:arglead, command_names, '^_')
endfunction

function! gina#complete#common#raw_command(arglead, cmdline, cursorpos) abort
  return gina#util#filter(a:arglead, [
        \ 'add',
        \ 'bisect',
        \ 'branch',
        \ 'checkout',
        \ 'clone',
        \ 'commit',
        \ 'diff',
        \ 'fetch',
        \ 'grep',
        \ 'init',
        \ 'log',
        \ 'merge',
        \ 'mv',
        \ 'pull',
        \ 'push',
        \ 'rebase',
        \ 'reset',
        \ 'restore',
        \ 'rm',
        \ 'show',
        \ 'status',
        \ 'switch',
        \ 'tag',
        \])
endfunction

function! gina#complete#common#remote(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let result = gina#process#call(git, ['remote'])
  if result.status
    return []
  endif
  return gina#util#filter(a:arglead, result.stdout)
endfunction

" Private --------------------------------------------------------------------
function! s:get_cache() abort
  if exists('s:cache')
    return s:cache
  endif
  let s:cache = s:Cache.new()
  return s:cache
endfunction

function! s:get_command_names() abort
  let suffix = s:Path.realpath('autoload/gina/command/*.vim')
  let command_names = []
  for runtimepath in split(&runtimepath, ',')
    let names = map(
          \ glob(s:Path.join(runtimepath, suffix), 0, 1),
          \ 'matchstr(fnamemodify(v:val, '':t''), ''^.\+\ze\.vim$'')',
          \)
    call extend(command_names, names)
  endfor
  return sort(command_names)
endfunction
