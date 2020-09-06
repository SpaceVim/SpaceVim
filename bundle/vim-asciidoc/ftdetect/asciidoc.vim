" Vim filetype detection file
" Language:     AsciiDoc
" Maintainer:   Barry Arthur <barry.arthur@gmail.com>
" URL:          http://asciidoc.org/
"               https://github.com/wsdjeg/vim-asciidoc
" Licence:      Licensed under the same terms as Vim itself
" Remarks:      Vim 6 or greater

augroup asciidoc
  au!
  au BufRead,BufNewFile *.asciidoc,*.adoc,*.asc set filetype=asciidoc
augroup END
