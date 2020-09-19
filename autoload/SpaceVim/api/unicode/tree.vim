scriptencoding utf-8
let s:self = {}
let s:self._json = SpaceVim#api#import('data#json')
let s:self._string = SpaceVim#api#import('data#string')
let s:self._vim = SpaceVim#api#import('vim')
let s:self.bottom_left_corner = '╰'
let s:self.side = '│'
let s:self.top_bottom_side = '─'
let s:self.left_middle = '├'


" ╰test
"   ├hello
"   │ ├one
"   │ ╰two
"   ╰world
"
" echo line should be prefix . extra . value

function! s:self.drawing_tree(tree, ...) abort
  let tree = []
  let prefix = get(a:000, 0, '')
  let extra = get(a:000, 1, '')
  if self._vim.is_string(a:tree)
    call add(tree, prefix . extra . a:tree)
  elseif self._vim.is_list(a:tree)
    let i = 1
    for item in a:tree
      if i < len(a:tree)
        let sidebar = self.side
        let extra = self.left_middle
      else
        let extra = self.bottom_left_corner
        if i ==# 1
          let sidebar = self.side
        else
          let sidebar = ' '
        endif
      endif
      call extend(tree, self.drawing_tree(item, prefix . extra, ' '))
      let i += 1
    endfor
  elseif self._vim.is_dict(a:tree)
    let i = 1
    for key in keys(a:tree)
      if i < len(a:tree)
        let sidebar = self.side
        let extra = self.left_middle
      else
        let extra = self.bottom_left_corner
        if i ==# 1
          let sidebar = self.side
        else
          let sidebar = ' '
        endif
      endif
      call add(tree, prefix . extra . key)
      call extend(tree, self.drawing_tree(get(a:tree, key, []), prefix  .  sidebar , ' '))
      let i += 1
    endfor
  endif
  return tree
endfunction

function! SpaceVim#api#unicode#tree#get() abort

  return deepcopy(s:self)

endfunction

