scriptencoding utf-8
let s:self = {}
let s:self._json = SpaceVim#api#import('data#json')
let s:self._string = SpaceVim#api#import('data#string')
let s:self._vim = SpaceVim#api#import('vim')
let s:self.bottom_left_corner = '╰'
let s:self.side = '│'
let s:self.top_bottom_side = '─'
let s:self.left_middle = '├'

function! s:self.drawing_tree(tree, ...) abort
  let tree = []
  let indent = get(a:000, 0, 0)
  if self._vim.is_string(a:tree)
    call add(tree, repeat(' ', indent) . a:tree)
  elseif self._vim.is_list(a:tree)
    for item in a:tree
      call extend(tree, self.drawing_tree(item, indent + 1))
    endfor
  elseif self._vim.is_dict(a:tree)
    for key in keys(a:tree)
      call add(tree, repeat(' ', indent) . key)
      call extend(tree, self.drawing_tree(get(a:tree, key, []), indent + 1))
    endfor
  endif
  return tree
endfunction

function! s:self._draw_tree(tree, ident) abort

endfunction

function! SpaceVim#api#unicode#tree#get() abort

  return deepcopy(s:self)

endfunction

