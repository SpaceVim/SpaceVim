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
  let prefix = get(a:000, 0, '')
  if self._vim.is_string(a:tree)
    call add(tree, prefix. a:tree)
  elseif self._vim.is_list(a:tree)
    let i = 1
    for item in a:tree
      if i < len(a:tree)
        let extra = self.left_middle
      else
        let extra = self.bottom_left_corner
      endif
      let i += 1
      call extend(tree, self.drawing_tree(item, prefix . extra ))
    endfor
  elseif self._vim.is_dict(a:tree)
    let i = 1
    for key in keys(a:tree)
      if i < len(a:tree)
        let prefix .= self.left_middle
      else
        let prefix .= self.bottom_left_corner
      endif
      call add(tree, prefix . key)
      call extend(tree, self.drawing_tree(get(a:tree, key, []), prefix))
    endfor
  endif
  return tree
endfunction

function! s:self._draw_tree(tree, ident) abort

endfunction

function! SpaceVim#api#unicode#tree#get() abort

  return deepcopy(s:self)

endfunction

