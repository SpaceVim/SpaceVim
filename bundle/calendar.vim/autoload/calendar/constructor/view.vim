" =============================================================================
" Filename: autoload/calendar/constructor/view.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:26:52.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#view#new(instance) abort
  return extend({ 'instance': a:instance }, s:constructor)
endfunction

let s:constructor = {}

function! s:constructor.new(source) dict abort
  let instance = extend(deepcopy(s:instance), deepcopy(self.instance))
  let instance.size = { 'x': 0, 'y': 0 }
  let instance._size = instance.size
  let instance.source = a:source
  let instance._selected = 0
  return instance
endfunction

let s:instance = {}

function! s:instance.set_visible(value) dict abort
  let self._visible = a:value
endfunction

function! s:instance.is_visible() dict abort
  sandbox return has_key(self, '_visible') ? self._visible : has_key(self.source, 'visible') ? eval(self.source.visible) : 1
endfunction

function! s:instance.on_top() dict abort
  sandbox return has_key(self.source, 'on_top') ? eval(self.source.on_top) : 0
endfunction

function! s:instance.width() dict abort
  return self.maxwidth()
endfunction

function! s:instance.height() dict abort
  return self.maxheight()
endfunction

function! s:instance.sizex() dict abort
  return self.size.x
endfunction

function! s:instance.sizey() dict abort
  return self.size.y
endfunction

function! s:instance.set_size() dict abort
  let self._size = copy(self.size)
  let self.size.x = self.width()
  let self.size.y = self.height()
  if self._size != self.size && has_key(self, 'on_resize')
    call self.on_resize()
  endif
  return self
endfunction

function! s:instance.left() dict abort
  sandbox return has_key(self.source, 'left') ? eval(self.source.left) : 0
endfunction

function! s:instance.top() dict abort
  sandbox return has_key(self.source, 'top') ? eval(self.source.top) : 0
endfunction

function! s:instance.maxwidth() dict abort
  sandbox return has_key(self.source, 'maxwidth') ? eval(self.source.maxwidth) : calendar#util#winwidth() - 1
endfunction

function! s:instance.maxheight() dict abort
  sandbox return has_key(self.source, 'maxheight') ? eval(self.source.maxheight) : calendar#util#winheight()
endfunction

function! s:instance.is_center() dict abort
  return get(self.source, 'align', '') ==# 'center'
endfunction

function! s:instance.is_vcenter() dict abort
  return get(self.source, 'valign', '') ==# 'center'
endfunction

function! s:instance.is_right() dict abort
  return get(self.source, 'align', '') ==# 'right'
endfunction

function! s:instance.is_bottom() dict abort
  return get(self.source, 'valign', '') ==# 'bottom'
endfunction

function! s:instance.is_absolute() dict abort
  return get(self.source, 'position', '') ==# 'absolute'
endfunction

function! s:instance.get_top() dict abort
  return max([self.top() + (self.is_vcenter() ? (self.maxheight() - self.size.y) / 2 : self.is_bottom() ? (self.maxheight() - self.size.y) : 0), 0])
endfunction

function! s:instance.get_left() dict abort
  return max([self.left() + (self.is_center() ? (self.maxwidth() - self.size.x + 1) / 2 : self.is_right() ? (self.maxwidth() - self.size.x) : 0), 0])
endfunction

function! s:instance.display_point() dict abort
  return 1
endfunction

function! s:instance.gather(...) dict abort
  let c = self.contents()
  let l = self.get_left()
  let p = self.get_top() + (a:0 ? a:1 : 0)
  return map(c, 'v:val.move(l, p)')
endfunction

function! s:instance.set_selected(selected) dict abort
  let self._selected = a:selected
  return self
endfunction

function! s:instance.is_selected() dict abort
  return self._selected
endfunction

function! s:instance.set_index(index) dict abort
  let self._index = a:index
endfunction

function! s:instance.get_index() dict abort
  return self._index
endfunction

function! s:instance.updated() dict abort
  return 1
endfunction

function! s:instance.timerange() dict abort
  return ''
endfunction

function! s:instance.action(action) dict abort
  return 0
endfunction

function! s:instance.oneday(day, events) dict abort
  let width = self.view.inner_width
  let right = has_key(a:events, 'daynum') ? a:events.daynum : ''
  if has_key(a:events, 'weeknum') && width > len(right) + 6
    let right = a:events.weeknum . (len(right) ? ' ' : '') . right
  endif
  if has_key(a:events, 'moon') && width > len(right) + 5
    let right = a:events.moon . right
  endif
  if width > len(right) + 3 && len(right)
    let le = calendar#string#strdisplaywidth(right) + 1
    let right = ' ' . right
  else
    let le = 0
    let right = ''
  endif
  let day = (a:day < 10 ? ' ' : '') . a:day
  let holiday = get(a:events, 'holiday', '')
  return calendar#string#truncate(day . ' ' . holiday, width - le) . right
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
