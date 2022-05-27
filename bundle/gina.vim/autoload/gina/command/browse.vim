let s:Formatter = vital#gina#import('Data.String.Formatter')
let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))
let s:FORMAT_MAP = {
      \ 'pt': 'path',
      \ 'ls': 'line_start',
      \ 'le': 'line_end',
      \ 'c0': 'commit0',
      \ 'c1': 'commit1',
      \ 'c2': 'commit2',
      \ 'h0': 'hash0',
      \ 'h1': 'hash1',
      \ 'h2': 'hash2',
      \ 'r0': 'rev0',
      \ 'r1': 'rev1',
      \ 'r2': 'rev2',
      \}


function! gina#command#browse#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  call gina#process#register(s:SCHEME, 1)
  try
    call s:call(a:range, a:args, a:mods)
  finally
    call gina#process#unregister(s:SCHEME, 1)
  endtry
endfunction

function! gina#command#browse#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#common#treeish(a:arglead, a:cmdline, a:cursorpos)
endfunction


" Private --------------------------------------------------------------------
function! s:get_options() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--scheme=',
        \ 'Specify a URL scheme to open.',
        \ ['_', 'root', 'blame', 'compare'],
        \)
  call options.define(
        \ '--exact',
        \ 'Use a sha1 instead of a branch name.',
        \)
  call options.define(
        \ '--yank',
        \ 'Yank a URL instead of opening.',
        \)
  return options
endfunction

function! s:build_args(git, args, range) abort
  let args = a:args.clone()
  let args.params.yank = args.pop('--yank')
  let args.params.exact = args.pop('--exact')
  let args.params.range = a:range == [1, line('$')] ? [] : a:range
  let args.params.scheme = args.pop('--scheme', v:null)
  call gina#core#args#extend_treeish(a:git, args, args.pop(1))
  return args.lock()
endfunction

function! s:call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args, a:range)
  let rev = gina#util#get(args.params, 'rev')
  let path = gina#util#get(args.params, 'path')
  let revinfo = s:parse_rev(git, rev)
  let base_url = s:build_base_url(
        \ s:get_remote_url(git, revinfo.commit1, revinfo.commit2),
        \ args.params.scheme is# v:null
        \   ? empty(path) ? 'root' : '_'
        \   : args.params.scheme,
        \)
  let url = s:Formatter.format(base_url, s:FORMAT_MAP, {
        \ 'path': substitute(path, ' ', '%20', 'g'),
        \ 'line_start': get(args.params.range, 0, ''),
        \ 'line_end': get(args.params.range, 1, ''),
        \ 'commit0': revinfo.commit0,
        \ 'commit1': revinfo.commit1,
        \ 'commit2': revinfo.commit2,
        \ 'hash0': revinfo.hash0,
        \ 'hash1': revinfo.hash1,
        \ 'hash2': revinfo.hash2,
        \ 'rev0': args.params.exact ? revinfo.hash0 : revinfo.commit0,
        \ 'rev1': args.params.exact ? revinfo.hash1 : revinfo.commit1,
        \ 'rev2': args.params.exact ? revinfo.hash2 : revinfo.commit2,
        \})
  if empty(url)
    throw gina#core#revelator#warning(printf(
          \ 'No url translation pattern for "%s" is found.',
          \ rev,
          \))
  endif
  if args.params.yank
    call gina#util#yank(url)
  else
    call gina#util#open(url)
  endif
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

function! s:parse_rev(git, rev) abort
  let [commit1, commit2] = gina#core#treeish#split(a:rev)
  let commit0 = empty(a:rev) ? 'HEAD' : a:rev
  let commit1 = empty(commit1) ? 'HEAD' : commit1
  let commit2 = empty(commit2) ? 'HEAD' : commit2
  let hash0 = gina#core#treeish#sha1(a:git, commit0)
  let hash1 = gina#core#treeish#sha1(a:git, commit1)
  let hash2 = gina#core#treeish#sha1(a:git, commit2)
  return {
        \ 'commit0': gina#core#treeish#resolve(a:git, commit0, 1),
        \ 'commit1': gina#core#treeish#resolve(a:git, commit1, 1),
        \ 'commit2': gina#core#treeish#resolve(a:git, commit2, 1),
        \ 'hash0': hash0,
        \ 'hash1': hash1,
        \ 'hash2': hash2,
        \}
endfunction

function! s:get_remote_url(git, commit1, commit2) abort
  let config = gina#core#repo#config(a:git)
  " Find a corresponding 'remote'
  let candidates = [a:commit1, a:commit2, 'master']
  for candidate in candidates
    let remote_name = get(config, printf('branch.%s.remote', candidate), '')
    if !empty(remote_name) && remote_name !=# '.'
      break
    endif
  endfor
  let remote_name = empty(remote_name) ? 'origin' : remote_name
  let result = gina#process#call(a:git, ['remote', 'get-url', remote_name])
  if result.status
    throw gina#process#errormsg(result)
  endif
  return result.content[0]
endfunction

function! s:build_base_url(remote_url, scheme) abort
  for [domain, info] in items(g:gina#command#browse#translation_patterns)
    for pattern in info[0]
      let pattern = substitute(pattern, '\C' . '%domain', domain, 'g')
      if a:remote_url =~# pattern
        let repl = get(info[1], a:scheme, a:remote_url)
        let repl = escape(repl, '&')
        return substitute(a:remote_url, '\C' . pattern, repl, 'g')
      endif
    endfor
  endfor
  return ''
endfunction


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'translation_patterns': {
      \   'github\.com': [
      \     [
      \       '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \       '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     ], {
      \       '_': 'https://\1/\2/\3/blob/%r0/%pt%{#L|}ls%{-L|}le',
      \       'root': 'https://\1/\2/\3/tree/%r0/',
      \       'blame': 'https://\1/\2/\3/blame/%r0/%pt%{#L|}ls%{-L|}le',
      \       'compare': 'https://\1/\2/\3/compare/%h1...%h2',
      \     },
      \   ],
      \   'gitlab\.com': [
      \     [
      \       '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \       '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     ], {
      \       '_': 'https://\1/\2/\3/blob/%r0/%pt%{#L|}ls%{-L|}le',
      \       'root': 'https://\1/\2/\3/tree/%r0/',
      \       'blame': 'https://\1/\2/\3/blame/%r0/%pt%{#L|}ls%{-L|}le',
      \       'compare': 'https://\1/\2/\3/compare/%h1...%h2',
      \     },
      \   ],
      \   'bitbucket\.org': [
      \     [
      \       '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \       '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \       '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     ], {
      \       '_': 'https://\1/\2/\3/src/%r0/%pt%{#cl-|}ls',
      \       'root': 'https://\1/\2/\3/commits/%r0',
      \       'blame': 'https://\1/\2/\3/annotate/%r0/%pt',
      \       'compare': 'https://\1/\2/\3/diff/%pt?diff1=%h1&diff2=%h2',
      \     },
      \   ],
      \   '.*\.visualstudio\.com': [
      \     [
      \       '\vhttps?://(%domain)/(.{-})/_git/(.{-})$',
      \     ], {
      \       '_': 'https://\1/\2/_git/\3/?path=%pt&version=GB%r0%{&line=|}ls%{&lineEnd=|}le',
      \       'root': 'https://\1/\2/_git/\3/?version=GB%r0',
      \     },
      \   ],
      \ },
      \})
