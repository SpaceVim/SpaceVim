let s:Git = vital#gina#import('Git')
let s:Store = vital#gina#import('System.Store')


function! gina#complete#tag#any(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_tags(git, [])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

" Public ---------------------------------------------------------------------
function! s:filter(arglead, candidates) abort
  return gina#util#filter(a:arglead, a:candidates)
endfunction

function! s:get_available_tags(git, args) abort
  let args = ['tag', '--list', '--format=%(refname:strip=2)'] + a:args
  let result = gina#process#call(a:git, args)
  if result.status
    return []
  endif
  let candidates = result.stdout
  return filter(candidates, '!empty(v:val)')
endfunction


