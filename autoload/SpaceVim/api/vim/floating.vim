"=============================================================================
" floating.vim --- vim floating api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

" this api is based on neovim#floating api
" options:
"   1. col
"   2. row
"   3. width
"   3. height
"   4. relative

" {config}  Map defining the window configuration. Keys:
" • `relative`: Sets the window layout to "floating", placed
" at (row,col) coordinates relative to:
" • "editor" The global editor grid
" • "win" Window given by the `win` field, or
" current window.
" • "cursor" Cursor position in current window.
"
" • `win` : |window-ID| for relative="win".
" • `anchor`: Decides which corner of the float to place
" at (row,col):
" • "NW" northwest (default)
" • "NE" northeast
" • "SW" southwest
" • "SE" southeast
"
" • `width` : Window width (in character cells).
" Minimum of 1.
" • `height` : Window height (in character cells).
" Minimum of 1.
" • `bufpos` : Places float relative to buffer
" text (only when relative="win"). Takes a tuple
" of zero-indexed [line, column]. `row` and
" `col` if given are applied relative to this
" position, else they default to `row=1` and
" `col=0` (thus like a tooltip near the buffer
" text).
" • `row` : Row position in units of "screen cell
" height", may be fractional.
" • `col` : Column position in units of "screen
" cell width", may be fractional.
" • `focusable` : Enable focus by user actions
" (wincmds, mouse events). Defaults to true.
" Non-focusable windows can be entered by
" |nvim_set_current_win()|.
" • `external` : GUI should display the window as
" an external top-level window. Currently
" accepts no other positioning configuration
" together with this.
" • `style`: Configure the appearance of the window.
" Currently only takes one non-empty value:
" • "minimal" Nvim will display the window with
" many UI options disabled. This is useful
" when displaying a temporary float where the
" text should not be edited. Disables
" 'number', 'relativenumber', 'cursorline',
" 'cursorcolumn', 'foldcolumn', 'spell' and
" 'list' options. 'signcolumn' is changed to
" `auto` and 'colorcolumn' is cleared. The
" end-of-buffer region is hidden by setting
" `eob` flag of 'fillchars' to a space char,
" and clearing the |EndOfBuffer| region in
" 'winhighlight'.
"
" Return: ~
" Window handle, or 0 on error
function! s:self.open_win(buffer, focuce, options) abort
  let col = get(a:options, 'col', 1)
  let row = get(a:options, 'row', 1)
  let width = get(a:options, 'width', 1)
  let height = get(a:options, 'height', 1) 
  let highlight = get(a:options, 'highlight', 'Normal') 
  let relative = get(a:options, 'relative', 'editor')
  if relative ==# 'win'
  elseif relative ==# 'cursor'
  elseif relative ==# 'editor'
    let opt = {
          \ 'line' : row + 1,
          \ 'col' : col,
          \ 'maxheight' : height,
          \ 'minheight' : height,
          \ 'maxwidth' : width,
          \ 'minwidth' : width,
          \ 'highlight' : highlight,
          \ 'scrollbar' : 0,
          \ }
  endif
  return popup_create(a:buffer, opt)
endfunction

function! s:self.win_config(winid, options) abort
  let col = get(a:options, 'col', 1)
  let row = get(a:options, 'row', 1)
  let width = get(a:options, 'width', 1)
  let height = get(a:options, 'height', 1) 
  let highlight = get(a:options, 'highlight', '') 
  let relative = get(a:options, 'relative', 'editor')
  if relative ==# 'win'
  elseif relative ==# 'cursor'
  elseif relative ==# 'editor'
    let opt = {
          \ 'line' : row + 1,
          \ 'col' : col,
          \ 'maxheight' : height,
          \ 'minheight' : height,
          \ 'maxwidth' : width,
          \ 'minwidth' : width,
          \ 'highlight' : highlight,
          \ 'scrollbar' : 0,
          \ }
  endif
  return popup_setoptions(a:winid, opt)
endfunction

function! s:self.exists() abort
  return exists('*popup_create')
endfunction

function! s:self.win_close(id, focuce) abort
  return popup_close(a:id)
endfunction

function! SpaceVim#api#vim#floating#get() abort
  return deepcopy(s:self)
endfunction



