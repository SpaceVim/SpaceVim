"=============================================================================
" FILE: git.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
"          Robert Nelson     <robert@rnelson.ca>
"          Copyright (C) 2010 http://github.com/gmarik
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
call neobundle#util#set_default(
      \ 'g:neobundle#types#git#command_path', 'git')
call neobundle#util#set_default(
      \ 'g:neobundle#types#git#default_protocol', 'https',
      \ 'g:neobundle_default_git_protocol')
call neobundle#util#set_default(
      \ 'g:neobundle#types#git#enable_submodule', 1)
call neobundle#util#set_default(
      \ 'g:neobundle#types#git#clone_depth', 0,
      \ 'g:neobundle_git_clone_depth')
call neobundle#util#set_default(
      \ 'g:neobundle#types#git#pull_command', 'pull --ff --ff-only')
"}}}

function! neobundle#types#git#define() abort "{{{
  return s:type
endfunction"}}}

let s:type = {
      \ 'name' : 'git',
      \ }

function! s:type.detect(path, opts) abort "{{{
  if a:path =~ '^/\|^\a:/' && s:is_git_dir(a:path.'/.git')
    " Local repository.
    return { 'uri' : a:path, 'type' : 'git' }
  elseif isdirectory(a:path)
    return {}
  endif

  let protocol = matchstr(a:path, '^.\{-}\ze://')
  if protocol == '' || a:path =~#
        \'\<\%(gh\|github\|bb\|bitbucket\):\S\+'
        \ || has_key(a:opts, 'type__protocol')
    let protocol = get(a:opts, 'type__protocol',
          \ g:neobundle#types#git#default_protocol)
  endif

  if protocol !=# 'https' && protocol !=# 'ssh'
    call neobundle#util#print_error(
          \ 'Path: ' . a:path . ' The protocol "' . protocol .
          \ '" is unsecure and invalid.')
    return {}
  endif

  if a:path !~ '/'
    " www.vim.org Vim scripts.
    let name = split(a:path, ':')[-1]
    let uri  = (protocol ==# 'ssh') ?
          \ 'git@github.com:vim-scripts/' :
          \ protocol . '://github.com/vim-scripts/'
    let uri .= name
  else
    let name = substitute(split(a:path, ':')[-1],
          \   '^//github.com/', '', '')
    let uri =  (protocol ==# 'ssh') ?
          \ 'git@github.com:' . name :
          \ protocol . '://github.com/'. name
  endif

  if a:path !~# '\<\%(gh\|github\):\S\+\|://github.com/'
    let uri = s:parse_other_pattern(protocol, a:path, a:opts)
    if uri == ''
      " Parse failure.
      return {}
    endif
  endif

  if uri !~ '\.git\s*$'
    " Add .git suffix.
    let uri .= '.git'
  endif

  return { 'uri': uri, 'type' : 'git' }
endfunction"}}}
function! s:type.get_sync_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return 'E: "git" command is not installed.'
  endif

  if !isdirectory(a:bundle.path)
    let cmd = 'clone'
    if g:neobundle#types#git#enable_submodule
      let cmd .= ' --recursive'
    endif

    let depth = get(a:bundle, 'type__depth',
          \ g:neobundle#types#git#clone_depth)
    if depth > 0 && a:bundle.rev == '' && a:bundle.uri !~ '^git@'
      let cmd .= ' --depth=' . depth
    endif

    let cmd .= printf(' %s "%s"', a:bundle.uri, a:bundle.path)
  else
    let cmd = g:neobundle#types#git#pull_command
    if g:neobundle#types#git#enable_submodule
      let shell = fnamemodify(split(&shell)[0], ':t')
      let and = (!neobundle#util#has_vimproc() && shell ==# 'fish') ?
            \ '; and ' : ' && '

      let cmd .= and . g:neobundle#types#git#command_path
            \ . ' submodule update --init --recursive'
    endif
  endif

  return g:neobundle#types#git#command_path . ' ' . cmd
endfunction"}}}
function! s:type.get_revision_number_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  return g:neobundle#types#git#command_path .' rev-parse HEAD'
endfunction"}}}
function! s:type.get_revision_pretty_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  return g:neobundle#types#git#command_path .
        \ ' log -1 --pretty=format:"%h [%cr] %s"'
endfunction"}}}
function! s:type.get_commit_date_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  return g:neobundle#types#git#command_path .
        \ ' log -1 --pretty=format:"%ct"'
endfunction"}}}
function! s:type.get_log_command(bundle, new_rev, old_rev) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
        \ || a:new_rev == '' || a:old_rev == ''
    return ''
  endif

  " Note: If the a:old_rev is not the ancestor of two branchs. Then do not use
  " %s^.  use %s^ will show one commit message which already shown last time.
  let is_not_ancestor = neobundle#util#system(
        \ g:neobundle#types#git#command_path . ' merge-base '
        \ . a:old_rev . ' ' . a:new_rev) ==# a:old_rev
  return printf(g:neobundle#types#git#command_path .
        \ ' log %s%s..%s --graph --pretty=format:"%%h [%%cr] %%s"',
        \ a:old_rev, (is_not_ancestor ? '' : '^'), a:new_rev)

  " Test.
  " return g:neobundle#types#git#command_path .
  "      \ ' log HEAD^^^^..HEAD --graph --pretty=format:"%h [%cr] %s"'
endfunction"}}}
function! s:type.get_revision_lock_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  let rev = a:bundle.rev
  if rev ==# 'release'
    " Use latest released tag
    let rev = neobundle#installer#get_release_revision(a:bundle,
          \ g:neobundle#types#git#command_path . ' tag')
  endif
  if rev == ''
    " Fix detach HEAD.
    let rev = 'master'
  endif

  return g:neobundle#types#git#command_path . ' checkout ' . rev
endfunction"}}}
function! s:type.get_gc_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  return g:neobundle#types#git#command_path .' gc'
endfunction"}}}
function! s:type.get_revision_remote_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  let rev = a:bundle.rev
  if rev == ''
    let rev = 'HEAD'
  endif

  return g:neobundle#types#git#command_path
        \ .' ls-remote origin ' . rev
endfunction"}}}
function! s:type.get_fetch_remote_command(bundle) abort "{{{
  if !executable(g:neobundle#types#git#command_path)
    return ''
  endif

  return g:neobundle#types#git#command_path
        \ .' fetch origin '
endfunction"}}}

function! s:parse_other_pattern(protocol, path, opts) abort "{{{
  let uri = ''

  if a:path =~# '\<gist:\S\+\|://gist.github.com/'
    let name = split(a:path, ':')[-1]
    let uri =  (a:protocol ==# 'ssh') ?
          \ 'git@gist.github.com:' . split(name, '/')[-1] :
          \ a:protocol . '://gist.github.com/'. split(name, '/')[-1]
  elseif a:path =~# '\<git@\S\+'
        \ || a:path =~# '\.git\s*$'
        \ || get(a:opts, 'type', '') ==# 'git'
    if a:path =~# '\<\%(bb\|bitbucket\):\S\+'
      let name = substitute(split(a:path, ':')[-1],
            \   '^//bitbucket.org/', '', '')
      let uri = (a:protocol ==# 'ssh') ?
            \ 'git@bitbucket.org:' . name :
            \ a:protocol . '://bitbucket.org/' . name
    else
      let uri = a:path
    endif
  endif

  return uri
endfunction"}}}

function! s:is_git_dir(path) abort "{{{
  if isdirectory(a:path)
    let git_dir = a:path
  elseif filereadable(a:path)
    " check if this is a gitdir file
    " File starts with "gitdir: " and all text after this string is treated
    " as the path. Any CR or NLs are stripped off the end of the file.
    let buf = join(readfile(a:path, 'b'), "\n")
    let matches = matchlist(buf, '\C^gitdir: \(\_.*[^\r\n]\)[\r\n]*$')
    if empty(matches)
      return 0
    endif
    let path = fnamemodify(a:path, ':h')
    if fnamemodify(a:path, ':t') == ''
      " if there's no tail, the path probably ends in a directory separator
      let path = fnamemodify(path, ':h')
    endif
    let git_dir = neobundle#util#join_paths(path, matches[1])
    if !isdirectory(git_dir)
      return 0
    endif
  else
    return 0
  endif

  " Git only considers it to be a git dir if a few required files/dirs exist
  " and are accessible inside the directory.
  " Note: we can't actually test file permissions the way we'd like to, since
  " getfperm() gives the mode string but doesn't tell us whether the user or
  " group flags apply to us. Instead, just check if dirname/. is a directory.
  " This should also check if we have search permissions.
  " I'm assuming here that dirname/. works on windows, since I can't test.
  " Note: Git also accepts having the GIT_OBJECT_DIRECTORY env var set instead
  " of using .git/objects, but we don't care about that.
  for name in ['objects', 'refs']
    if !isdirectory(neobundle#util#join_paths(git_dir, name))
      return 0
    endif
  endfor

  " Git also checks if HEAD is a symlink or a properly-formatted file.
  " We don't really care to actually validate this, so let's just make
  " sure the file exists and is readable.
  " Note: it may also be a symlink, which can point to a path that doesn't
  " necessarily exist yet.
  let head = neobundle#util#join_paths(git_dir, 'HEAD')
  if !filereadable(head) && getftype(head) != 'link'
    return 0
  endif

  " Sure looks like a git directory. There's a few subtleties where we'll
  " accept a directory that git itself won't, but I think we can safely ignore
  " those edge cases.
  return 1
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
