if exists('g:loaded_unstack')
  finish
endif
let g:loaded_unstack = 1

"Settings {{{
if !exists('g:unstack_mapkey')
  let g:unstack_mapkey = '<leader>s'
endif
if g:unstack_mapkey !~# '^\s*$'
  exe 'nnoremap <silent> '.g:unstack_mapkey.' :set operatorfunc=unstack#Unstack<cr>g@'
  exe 'vnoremap <silent> '.g:unstack_mapkey.' :<c-u>call unstack#Unstack(visualmode())<cr>'
endif

"List of text extractors
if (!exists('g:unstack_extractors'))
  let g:unstack_extractors = unstack#extractors#GetDefaults()
endif

"populate quickfix with stack
if (!exists('g:unstack_populate_quickfix'))
  let g:unstack_populate_quickfix = 0
endif

"open stack in vsplits in a new tab
if (!exists('g:unstack_open_tab'))
  let g:unstack_open_tab = 1
endif

"Either landscape (vsplits) or portrait (splits)
if (!exists('g:unstack_layout'))
  let g:unstack_layout = "landscape"
endif

"'scrolloff' value while files are opened
if (!exists('g:unstack_scrolloff'))
  let g:unstack_scrolloff = 0
endif

"where to put the line from the stack trace
if (!exists('g:unstack_vertical_alignment'))
  let g:unstack_vertical_alignment = "middle"
endif

"Whether or not to show signs on error lines (highlights them red)
if !exists('g:unstack_showsigns')
  let g:unstack_showsigns = 1
endif "}}}
"Commands {{{
command! -nargs=1 UnstackFromText call unstack#UnstackFromText(eval(<f-args>))
command! UnstackFromClipboard call unstack#UnstackFromText(@+)
command! UnstackFromSelection call unstack#UnstackFromText(@*)
command! UnstackFromTmux call unstack#UnstackFromTmuxPasteBuffer()
"}}}

" vim: et sw=2 sts=2 foldmethod=marker foldmarker={{{,}}}
