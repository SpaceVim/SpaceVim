runtime! plugin/textobj/entire.vim

let g:filler_line = [
\   'Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
\   'sed do eiusmod tempor incididunt ut labore et dolore magna',
\   'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
\   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
\   'Duis aute irure dolor in reprehenderit in voluptate velit',
\   'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint',
\   'occaecat cupidatat non proident, sunt in culpa qui officia',
\   'deserunt mollit anim id est laborum.',
\ ]

function! FillBuffer()
  put =['', ''] + g:filler_line + ['', '']
  1 delete _
endfunction

describe '<Plug>(textobj-entire-a)'
  before
    new
    call FillBuffer()
  end

  after
    close!
  end

  it 'does not change the jumplist'
    normal! 3gg
    normal! 5gg
    normal! 7gg
    normal! 11gg

    execute 'normal' "y\<Plug>(textobj-entire-a)"
    Expect line('.') == 1

    execute 'normal!' "\<C-o>"
    Expect line('.') == 11

    execute 'normal!' "\<C-o>"
    Expect line('.') == 7

    execute 'normal!' "\<C-o>"
    Expect line('.') == 5

    execute 'normal!' "\<C-o>"
    Expect line('.') == 3
  end
end

describe '<Plug>(textobj-entire-i)'
  before
    new
    call FillBuffer()
  end

  after
    close!
  end

  it 'does not change the jumplist'
    normal! 2gg
    normal! 4gg
    normal! 6gg
    normal! 10gg

    execute 'normal' "y\<Plug>(textobj-entire-i)"
    Expect line('.') == 3

    execute 'normal!' "\<C-o>"
    Expect line('.') == 10

    execute 'normal!' "\<C-o>"
    Expect line('.') == 6

    execute 'normal!' "\<C-o>"
    Expect line('.') == 4

    execute 'normal!' "\<C-o>"
    Expect line('.') == 2
  end
end
