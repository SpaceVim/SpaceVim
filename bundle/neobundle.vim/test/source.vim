" Source test.
set verbose=1

let path = expand('~/test-bundle/'.fnamemodify(expand('<sfile>'), ':t:r'))

if isdirectory(path)
  let rm_command = neobundle#util#is_windows() ? 'rmdir /S /Q' : 'rm -rf'
  call system(printf('%s "%s"', rm_command, path))
endif

let neobundle#types#git#default_protocol = 'https'

call neobundle#begin(path)

" Test dependencies.

let s:suite = themis#suite('source')
let s:assert = themis#helper('assert')

NeoBundleLazy 'Shougo/echodoc'
NeoBundle 'Shougo/unite-build', { 'depends' : 'Shougo/echodoc' }

NeoBundle 'Shougo/unite-ssh',  { 'depends' : 'Shougo/unite-sudo' }
NeoBundleLazy 'Shougo/unite-sudo'

NeoBundleLazy 'Shougo/neomru.vim', { 'depends': 'Shougo/neocomplcache' }
NeoBundle 'Shougo/neocomplcache.vim', 'ver.8'

NeoBundleLazy 'Shougo/vimshell', { 'depends': 'Shougo/vinarise' }
NeoBundleLazy 'Shougo/vinarise'

NeoBundle 'Shougo/vimfiler', { 'depends' : 'foo/var' }

NeoBundleLazy 'Shougo/unite.vim', {
      \ 'depends' : ['Shougo/unite-outline', 'basyura/TweetVim'],
      \ 'autoload' : { 'commands' : 'Unite' } }
NeoBundleLazy 'Shougo/unite-outline', {
      \ 'depends' : 'Shougo/unite.vim' }

" Dependencies test.
NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'yomi322/neco-tweetvim'
NeoBundleLazy 'rhysd/tweetvim-advanced-filter'
NeoBundleLazy 'rhysd/TweetVim', {
\ 'depends' :
\ ['basyura/twibill.vim',
\ 'tyru/open-browser.vim',
\ 'yomi322/neco-tweetvim',
\ 'rhysd/tweetvim-advanced-filter'],
\ 'autoload' : {
\ 'commands' :
\ ['TweetVimHomeTimeline',
\ 'TweetVimMentions',
\ 'TweetVimSay',
\ 'TweetVimUserTimeline']
\ }
\ }

" Law.
NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim',
      \ {'script_type' : 'plugin', 'rev' : '0'}
" NeoBundleReinstall rsense.vim

call neobundle#end()

filetype plugin indent on       " required!

" Should not break helptags.
set wildignore+=doc

" Should not break clone.
set wildignore+=.git
set wildignore+=.git/*
set wildignore+=*/.git/*

function! s:suite.pattern_a() abort
  call s:assert.equals(neobundle#is_sourced('echodoc'), 1)
  call s:assert.equals(neobundle#is_sourced('unite-build'), 1)
endfunction

function! s:suite.pattern_b() abort
  call s:assert.equals(neobundle#is_sourced('unite-ssh'), 1)
  call s:assert.equals(neobundle#is_sourced('unite-sudo'), 1)
endfunction

function! s:suite.pattern_c() abort
  call s:assert.equals(neobundle#is_sourced('neomru.vim'), 0)
  call s:assert.equals(neobundle#is_sourced('neocomplcache.vim'), 1)
endfunction

function! s:suite.pattern_d() abort
  call s:assert.equals(neobundle#is_sourced('vimshell'), 0)
  call s:assert.equals(neobundle#is_sourced('vinarise'), 0)
endfunction

