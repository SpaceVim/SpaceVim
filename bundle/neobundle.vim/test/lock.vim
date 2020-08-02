" Lock file test.
set verbose=1

let path = expand('~/test-bundle/'.fnamemodify(expand('<sfile>'), ':t:r'))

if isdirectory(path)
  let rm_command = neobundle#util#is_windows() ? 'rmdir /S /Q' : 'rm -rf'
  call system(printf('%s "%s"', rm_command, path))
endif

call mkdir(path, 'p')

call neobundle#begin(path)

NeoBundleFetch 'Shougo/neocomplete.vim'

call neobundle#end()

filetype plugin indent on     " Required!

" Create lock file
call writefile([
      \ 'NeoBundleLock neocomplete.vim 8200dfd83ba829f77f028ea26e81eebbe95e6a89',
      \ ], path . '/NeoBundle.lock')

NeoBundleInstall

let s:suite = themis#suite('lock')
let s:assert = themis#helper('assert')

function! s:suite.revision_check() abort
  let bundle = neobundle#get('neocomplete.vim')
  call s:assert.equals(neobundle#installer#get_revision_number(bundle),
        \ '8200dfd83ba829f77f028ea26e81eebbe95e6a89')
endfunction
