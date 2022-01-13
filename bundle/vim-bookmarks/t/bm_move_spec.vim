
" custom matchers
function! ToHaveBookmark(file, line)
  return bm#has_bookmark_at_line(a:file, a:line)
endfunction
function! ToHaveBookmark_should_msg(file, line)
  return a:file . ' should have a bookmark at line ' . a:line
endfunction
function! ToHaveBookmark_should_not_msg(file, line)
  return a:file . ' should not have a bookmark at line ' . a:line
endfunction
call vspec#customize_matcher('to_have_bookmark_at', {
      \ 'match': function('ToHaveBookmark'),
      \ 'failure_message_for_should': function('ToHaveBookmark_should_msg'),
      \ 'failure_message_for_should_not': function('ToHaveBookmark_should_not_msg')
      \ })

function! ToHaveBookmarks(file)
  return bm#has_bookmarks_in_file(a:file)
endfunction
function! ToHaveBookmarks_should_msg(file)
  return a:file . ' should have bookmarks'
endfunction
function! ToHaveBookmarks_should_not_msg(file)
  return a:file . ' should not have bookmarks'
endfunction
call vspec#customize_matcher('to_have_bookmarks', {
      \ 'match': function('ToHaveBookmarks'),
      \ 'failure_message_for_should': function('ToHaveBookmarks_should_msg'),
      \ 'failure_message_for_should_not': function('ToHaveBookmarks_should_not_msg')
      \ })

" source the plugin file
source plugin/bookmark.vim

describe 'BookmarkMove* commands'

  before
    edit! LICENSE
    let g:file = expand('%:p')
  end

  it 'should work with and without arguments'
    Expect g:file not to_have_bookmarks
    normal 3G
    BookmarkToggle
    Expect g:file to_have_bookmark_at 3
    BookmarkMoveUp
    Expect g:file to_have_bookmark_at 2
    BookmarkMoveDown 3
    Expect g:file to_have_bookmark_at 5
    BookmarkMoveDown
    Expect g:file to_have_bookmark_at 6
    BookmarkMoveDown 1
    Expect g:file to_have_bookmark_at 7
    BookmarkMoveUp 3
    Expect g:file to_have_bookmark_at 4

    " bad input
    BookmarkMoveDown 2abc
    Expect g:file not to_have_bookmark_at 2
    BookmarkMoveUp xyz2
    Expect g:file not to_have_bookmark_at 2
    " invalid range
    BookmarkMoveDown 999
    Expect g:file to_have_bookmark_at 4
    BookmarkMoveUp 999
    Expect g:file to_have_bookmark_at 4

    normal 10G
    BookmarkToggle
    Expect g:file to_have_bookmark_at 10
    execute "BookmarkMoveToLine " . line('$')
    Expect g:file to_have_bookmark_at line('$')
    execute "normal :BookmarkMoveToLine\<CR>12\<CR>"
    Expect g:file to_have_bookmark_at 12
    execute "normal :BookmarkMoveToLine\<CR>13abc\<CR>"
    Expect g:file not to_have_bookmark_at 13
    " sadly this doesn't work in the test runner - possibly related to vspec-faq/c
    " execute "normal :BookmarkMoveToLine\<CR>13\<Esc>"
    " Expect g:file not to_have_bookmark_at 13
    BookmarkMoveToLine 13abc
    Expect g:file not to_have_bookmark_at 13
    BookmarkMoveToLine 4
    Expect g:file to_have_bookmark_at 12

    normal 4G
    BookmarkToggle
    normal 12G
    BookmarkToggle
    Expect g:file not to_have_bookmarks
  end

  after
    call BookmarkClear()
  end

end

describe 'BookmarkMove* mappings'

  before
    edit! LICENSE
    let g:file = expand('%:p')
  end

  it 'should move a bookmark when count is not specified'
    Expect g:file not to_have_bookmarks
    normal gg
    normal mm
    Expect g:file to_have_bookmark_at 1
    normal mkk
    Expect g:file to_have_bookmark_at 1
    normal mjj
    normal mjj
    normal mjj
    Expect g:file to_have_bookmark_at 4
    normal mkk
    normal mkk
    Expect g:file to_have_bookmark_at 2

    normal G
    normal mm
    Expect g:file to_have_bookmark_at line('$')
    normal mjj
    Expect g:file to_have_bookmark_at line('$')

    execute "normal mg7abc\<CR>"
    Expect g:file not to_have_bookmark_at 7
    execute "normal mg7\<CR>"
    Expect g:file to_have_bookmark_at 7

    normal mm
    normal 2G
    normal mm
    Expect g:file not to_have_bookmarks
  end

  it 'should respect [count] when specified'
    Expect g:file not to_have_bookmarks
    normal gg
    normal mm
    normal 2mjj
    normal 3mjj
    Expect g:file to_have_bookmark_at 6
    normal 3mkk
    normal mkk
    Expect g:file to_have_bookmark_at 2

    normal 999mkk
    Expect g:file to_have_bookmark_at 2
    normal 999mjj
    Expect g:file to_have_bookmark_at 2

    normal 5G
    normal mm
    Expect g:file to_have_bookmark_at 5
    normal 2mg
    Expect g:file to_have_bookmark_at 5
    normal 1000mg
    Expect g:file to_have_bookmark_at 5
    normal 8mg
    Expect g:file to_have_bookmark_at 8

    normal 2G
    normal mm
    normal 8G
    normal mm
    Expect g:file not to_have_bookmarks
  end

  after
    call BookmarkClear()
  end

end
