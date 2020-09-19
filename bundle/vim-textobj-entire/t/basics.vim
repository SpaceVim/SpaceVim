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

  it 'targets the whole content of the current buffer'
    execute 'normal' "y\<Plug>(textobj-entire-a)"
    Expect split(@0, '\n', 1) ==# ['', ''] + g:filler_line + ['', ''] + ['']
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

  it 'targets the whole content of the current buffer'
    execute 'normal' "y\<Plug>(textobj-entire-i)"
    Expect split(@0, '\n', 1) ==# g:filler_line + ['']
  end
end
