let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')


function! gina#complete#commit#any(arglead, cmdline, cursorpos) abort
  let candidates = ['']
  let candidates += gina#complete#commit#branch(a:arglead, a:cmdline, a:cursorpos)
  if !empty(a:arglead)
    let candidates += gina#complete#commit#hashref(a:arglead, a:cmdline, a:cursorpos)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#commit#branch(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of(s:Git.resolve(git, 'config'))
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_branches(git, ['--all'])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#commit#local_branch(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of(s:Git.resolve(git, 'config'))
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_branches(git, [])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#commit#remote_branch(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of(s:Git.resolve(git, 'config'))
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_branches(git, ['--remotes'])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#commit#hashref(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of(s:Git.resolve(git, 'config'))
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_commits(git, [])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction


" Public ---------------------------------------------------------------------
function! s:filter(arglead, candidates) abort
  return gina#util#filter(a:arglead, a:candidates)
endfunction

function! s:get_available_commits(git, args) abort
  let args = ['log', '--pretty=%h'] + a:args
  let result = gina#process#call(a:git, args)
  if result.status
    return []
  endif
  return result.stdout
endfunction

function! s:get_available_branches(git, args) abort
  let args = ['branch', '--no-color', '--list'] + a:args
  let result = gina#process#call(a:git, args)
  if result.status
    return []
  endif
  let candidates = filter(copy(result.stdout), 'v:val !~# ''^.* -> .*$''')
  call map(candidates, 'matchstr(v:val, ''^..\zs.*$'')')
  call map(candidates, 'substitute(v:val, ''^remotes/'', '''', '''')')
  return ['HEAD'] + filter(candidates, '!empty(v:val)')
endfunction
