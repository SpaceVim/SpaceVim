" Basic commands test.
set verbose=1

let path = expand('~/test-bundle/'.fnamemodify(expand('<sfile>'), ':t:r'))

if isdirectory(path)
  let rm_command = neobundle#util#is_windows() ? 'rmdir /S /Q' : 'rm -rf'
  call system(printf('%s "%s"', rm_command, path))
endif

call mkdir(path, 'p')

call neobundle#begin(path)

let g:neobundle#types#git#default_protocol = 'https'

" My Bundles here:
"

" Original repositories in github.
NeoBundle 'Shougo/neocomplcache-clang.git'

" Vim-script repositories.
NeoBundle 'rails.vim'

" Username with dashes.
NeoBundle 'vim-scripts/ragtag.vim'

" Original repo.
NeoBundle 'altercation/vim-colors-solarized'

" With extension.
" Comment is allowed.
NeoBundle 'nelstrom/vim-mac-classic-theme.git' " Foo, Bar

" Invalid uri.
NeoBundle 'nonexistinguser/hogehoge.git'

" Full uri.
NeoBundle 'https://github.com/vim-scripts/vim-game-of-life'
NeoBundle 'git@github.com:gmarik/ingretu.git'

" Short uri.
NeoBundle 'gh:gmarik/snipmate.vim.git'
NeoBundle 'github:mattn/gist-vim.git'

" Camel case.
NeoBundle 'vim-scripts/RubySinatra'

" With options.
NeoBundle 'Shougo/vimshell', '3787e5'

" None repos.
NeoBundle 'muttator', {'type' : 'none', 'base' : '~/.vim/bundle'}

" Raw repos.
NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim',
      \ {'script_type' : 'plugin'}

" NeoBundleLocal test.
NeoBundleLocal ~/.vim/bundle/

" Depends repos.
NeoBundle 'Shougo/neocomplcache',
      \ {'depends' : [
      \   'Shougo/neocomplcache-snippets-complete.git',
      \   ['rstacruz/sparkup', {'rtp': 'vim'}],
      \ ]}
NeoBundle 'Shougo/vimfiler',
      \ { 'depends' : 'Shougo/unite.vim' }

" Build repos.
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" Lazy load.
NeoBundleLazy 'c9s/perlomni.vim.git'
NeoBundleSource perlomni.vim
call neobundle#source(['CSApprox'])

NeoBundleLazy 'The-NERD-tree', {'augroup' : 'NERDTree'}
call neobundle#source(['The-NERD-tree'])

NeoBundleLazy 'masudaK/vim-python'
NeoBundleLazy 'klen/python-mode'

NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {
      \     'filetypes' : ['c', 'cpp'],
      \    },
      \ }

" script_type support.
NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim',
       \ {'script_type' : 'plugin'}

" Fetch only.
NeoBundleFetch 'Shougo/neobundle.vim'

call neobundle#end()

filetype plugin indent on       " required!

" Should not break helptags.
set wildignore+=doc

" Should not break clone.
set wildignore+=.git
set wildignore+=.git/*
set wildignore+=*/.git/*

