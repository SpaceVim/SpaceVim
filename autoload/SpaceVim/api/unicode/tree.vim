let s:self = {}
let s:self._json = SpaceVim#api#import('data#json')
let s:self._string = SpaceVim#api#import('data#string')

function! s:self.drawing_tree(tree) abort

endfunction

function! SpaceVim#api#unicode#tree#get() abort

  return deepcopy(s:self)

endfunction

