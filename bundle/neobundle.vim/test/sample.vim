" Sample configurations test.
set verbose=1

let path = expand('~/test-bundle/'.fnamemodify(expand('<sfile>'), ':t:r'))

if isdirectory(path)
  let rm_command = neobundle#util#is_windows() ? 'rmdir /S /Q' : 'rm -rf'
  call system(printf('%s "%s"', rm_command, path))
endif

let neobundle#types#git#default_protocol = 'git'

call neobundle#begin(path)

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

" My Bundles here:
"
" Note: You don't set neobundle setting in .gvimrc!
" Original repos on github
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
NeoBundle 'rails.vim'
" Non git repos
NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'

call neobundle#end()

filetype plugin indent on     " Required!

