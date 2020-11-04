"=============================================================================
" $Id: path.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		tests/lh/path.vim                                      {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	28th May 2009
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:
" 	Tests for autoload/lh/path.vim
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

UTSuite [lh-vim-lib] Testing lh#path functions

runtime autoload/lh/path.vim
let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! s:Test_simplify()
  Assert lh#path#simplify('a/b/c') == 'a/b/c'
  Assert lh#path#simplify('a/b/./c') == 'a/b/c'
  Assert lh#path#simplify('./a/b/./c') == 'a/b/c'
  Assert lh#path#simplify('./a/../b/./c') == 'b/c'
  Assert lh#path#simplify('../a/../b/./c') == '../b/c'
  Assert lh#path#simplify('a\b\c') == 'a\b\c'
  Assert lh#path#simplify('a\b\.\c') == 'a\b\c'
  Assert lh#path#simplify('.\a\b\.\c') == 'a\b\c'
  if exists('+shellslash')
    Assert lh#path#simplify('.\a\..\b\.\c') == 'b\c'
    Assert lh#path#simplify('..\a\..\b\.\c') == '..\b\c'
  endif
endfunction

function! s:Test_strip_common()
  let paths = ['foo/bar/file', 'foo/file', 'foo/foo/file']
  let expected = [ 'bar/file', 'file', 'foo/file']
  Assert lh#path#strip_common(paths) == expected
endfunction

function! s:Test_common()
  Assert 'foo/' == lh#path#common(['foo/bar/dir', 'foo'])
  Assert 'foo/bar/' == lh#path#common(['foo/bar/dir', 'foo/bar'])
  Assert 'foo/' == lh#path#common(['foo/bar/dir', 'foo/bar2'])
endfunction

function! s:Test_strip_start()
  let expected = 'template/bar.template'
  Assert lh#path#strip_start($HOME.'/.vim/template/bar.template',
	\ [ $HOME.'/.vim', $HOME.'/vimfiles', '/usr/local/share/vim' ]) 
	\ == expected

  Assert lh#path#strip_start($HOME.'/vimfiles/template/bar.template',
	\ [ $HOME.'/.vim', $HOME.'/vimfiles', '/usr/local/share/vim' ]) 
	\ == expected

  Assert lh#path#strip_start('/usr/local/share/vim/template/bar.template',
	\ [ $HOME.'/.vim', $HOME.'/vimfiles', '/usr/local/share/vim' ]) 
	\ == expected
endfunction

function! s:Test_IsAbsolutePath()
  " nix paths
  Assert lh#path#is_absolute_path('/usr/local')
  Assert lh#path#is_absolute_path($HOME)
  Assert ! lh#path#is_absolute_path('./usr/local')
  Assert ! lh#path#is_absolute_path('.usr/local')

  " windows paths
  Assert lh#path#is_absolute_path('e:\usr\local')
  Assert ! lh#path#is_absolute_path('.\usr\local')
  Assert ! lh#path#is_absolute_path('.usr\local')

  " UNC paths
  Assert lh#path#is_absolute_path('\\usr\local')
  Assert lh#path#is_absolute_path('//usr/local')
endfunction

function! s:Test_IsURL()
  " nix paths
  Assert ! lh#path#is_url('/usr/local')
  Assert ! lh#path#is_url($HOME)
  Assert ! lh#path#is_url('./usr/local')
  Assert ! lh#path#is_url('.usr/local')

  " windows paths
  Assert ! lh#path#is_url('e:\usr\local')
  Assert ! lh#path#is_url('.\usr\local')
  Assert ! lh#path#is_url('.usr\local')

  " UNC paths
  Assert ! lh#path#is_url('\\usr\local')
  Assert ! lh#path#is_url('//usr/local')

  " URLs
  Assert lh#path#is_url('http://www.usr/local')
  Assert lh#path#is_url('https://www.usr/local')
  Assert lh#path#is_url('ftp://www.usr/local')
  Assert lh#path#is_url('sftp://www.usr/local')
  Assert lh#path#is_url('dav://www.usr/local')
  Assert lh#path#is_url('fetch://www.usr/local')
  Assert lh#path#is_url('file://www.usr/local')
  Assert lh#path#is_url('rcp://www.usr/local')
  Assert lh#path#is_url('rsynch://www.usr/local')
  Assert lh#path#is_url('scp://www.usr/local')
endfunction

function! s:Test_ToRelative()
  let pwd = getcwd()
  Assert lh#path#to_relative(pwd.'/foo/bar') == 'foo/bar'
  Assert lh#path#to_relative(pwd.'/./foo') == 'foo'
  Assert lh#path#to_relative(pwd.'/foo/../bar') == 'bar'

  " Does not work yet as it returns an absolute path it that case
  Assert lh#path#to_relative(pwd.'/../bar') == '../bar'
endfunction

function! s:Test_relative_path()
  Assert lh#path#relative_to('foo/bar/dir', 'foo') == '../../'
  Assert lh#path#relative_to('foo', 'foo/bar/dir') == 'bar/dir/'
  Assert lh#path#relative_to('foo/bar', 'foo/bar2/dir') == '../bar2/dir/'

  let pwd = getcwd()
  Assert lh#path#relative_to(pwd ,pwd.'/../bar') == '../bar/'
endfunction

function! s:Test_search_vimfiles()
  let expected_win = $HOME . '/vimfiles'
  let expected_nix = $HOME . '/.vim'
  let what =  lh#path#to_regex($HOME.'/').'\(vimfiles\|.vim\)'
  " Comment what
  let z = lh#path#find(&rtp,what)
  if has('win16')||has('win32')||has('win64')
    Assert z == expected_win
  else
    Assert z == expected_nix
  endif
endfunction

function! s:Test_path_depth()
  Assert 0 == lh#path#depth('.')
  Assert 0 == lh#path#depth('./')
  Assert 0 == lh#path#depth('.\')
  Assert 1 == lh#path#depth('toto')
  Assert 1 == lh#path#depth('toto/')
  Assert 1 == lh#path#depth('toto\')
  Assert 1 == lh#path#depth('toto/.')
  Assert 1 == lh#path#depth('toto\.')
  Assert 1 == lh#path#depth('toto/./.')
  Assert 1 == lh#path#depth('toto\.\.')
  Assert 0 == lh#path#depth('toto/..')
  if exists('+shellslash')
    Assert 0 == lh#path#depth('toto\..')
  endif
  Assert 2 == lh#path#depth('toto/titi/')
  Assert 2 == lh#path#depth('toto\titi\')
  Assert 2 == lh#path#depth('/toto/titi/')
  Assert 2 == lh#path#depth('c:/toto/titi/')
  Assert 2 == lh#path#depth('c:\toto/titi/')
" todo: make a choice about "negative" paths like "../../foo"
  Assert -1 == lh#path#depth('../../foo')
endfunction

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
