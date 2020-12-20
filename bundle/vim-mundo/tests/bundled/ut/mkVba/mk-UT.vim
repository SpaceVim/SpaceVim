"=============================================================================
" $Id: mk-UT.vim 194 2010-05-17 23:26:14Z luc.hermitte $
" File:		mk-UT.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	0.0.3
let s:version = '0.0.3'
" Created:	19th Feb 2009
" Last Update:	$Date: 2010-05-17 19:26:14 -0400 (Mon, 17 May 2010) $
"------------------------------------------------------------------------
cd <sfile>:p:h
try 
  let save_rtp = &rtp
  let &rtp = expand('<sfile>:p:h:h').','.&rtp
  exe '22,$MkVimball! UT-'.s:version
  set modifiable
  set buftype=
finally
  let &rtp = save_rtp
endtry
finish
UT.README
autoload/lh/UT.vim
autoload/should.vim
autoload/should/be.vim
doc/UT.txt
ftplugin/vim/vim_UT.vim
mkVba/mk-UT.vim
plugin/UT.vim
tests/lh/UT-fixtures.vim
tests/lh/UT.vim
tests/lh/assert.vim
