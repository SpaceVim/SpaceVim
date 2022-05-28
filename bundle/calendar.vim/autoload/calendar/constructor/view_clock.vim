" =============================================================================
" Filename: autoload/calendar/constructor/view_clock.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:26:59.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#view_clock#new(instance) abort
  return extend({ 'instance': a:instance }, s:constructor)
endfunction

let s:constructor = {}

function! s:constructor.new(source) dict abort
  return extend(extend(s:super_constructor.new(a:source), s:instance), self.instance)
endfunction

let s:instance = {}
let s:instance.letters = []
let s:instance.prevscale = 0
let s:instance.syntax = []
let s:instance.diffs = []
let s:instance.smaller = 0
let s:instance.offsetx_start = 0
let s:instance.colnum = 1
let s:instance.winwidth = 0
let s:instance.winheight = 0
let s:instance.str = ''
let s:instance.len = 0
let s:instance._colnum = 0

function! s:instance.get_scale(...) dict abort
  let colnum = a:0 ? a:1 : self.colnum
  let [h, w] = [self.maxheight(), self.maxwidth()]
  if self.winwidth == w && self.winheight == h && self._colnum == colnum
    return self.scale
  endif
  let str = self.max_letter()[0]
  let len = calendar#pixel#len(str) + 2 * (len(str) - 1)
  let scale = 0
  while w >= len * (scale + 1) * (15 + scale) / 15 + 1 &&
      \ h >= 6 * (scale + 1) * self.y_height * colnum + 1
    let scale += 1
  endwhile
  if scale > 1 && self.smaller
    let scale -= 1
  endif
  let self.scale = scale
  let self.winwidth = w
  let self.winheight = h
  let self._colnum = colnum
  return scale
endfunction

function! s:instance.width() dict abort
  let str = self.get_letter()[0]
  if self.str !=# str
    let self.len = calendar#pixel#len(str) + 2 * (len(str) - 1)
  endif
  let [h, w] = [self.maxheight(), self.maxwidth()]
  if self.winwidth != w || self.winheight != h
    let scale = self.get_scale()
  endif
  let self.winwidth = w
  let self.winheight = h
  let self.str = str
  return self.scale ? self.len * self.scale : len(str)
endfunction

function! s:instance.height() dict abort
  if self.winwidth != self.maxwidth() || self.winheight != self.maxheight()
    let scale = self.get_scale()
  endif
  let self.one_height = self.scale ? 5 * self.scale : 1
  return self.scale ? self.one_height * self.y_height : 1
endfunction

function! s:instance.gen_syn(chr, offsetx, offsety, syn) dict abort
  if !len(a:chr)
    return [[], 0]
  endif
  if !self.scale
    return [[calendar#text#new(a:chr, a:offsetx, a:offsety, '')], 1]
  endif
  let pixel = calendar#pixel#get(a:chr)
  if type(pixel) != type([])
    return [[], 0]
  endif
  let syn = []
  let max = 0
  let j = 0
  let scale = self.scale
  let pp = ''
  let above_num = 0
  for p in pixel
    if pp ==# p && above_num && len(syn)
      let h = syn[-1].syn[0][4]
      for i in range(above_num)
        call syn[- 1 - i].height((h ? h : scale) + scale)
      endfor
    else
      let max = max([max, (len(p) + 2) * scale])
      let i = 0
      let num = 0
      while i < len(p)
        let i += len(matchstr(p, '^\.*', i))
        let matchlen = len(matchstr(p, '^[^.]*', i))
        if matchlen
          if num
            call add(syn[-1].syn, [a:syn, a:offsety + j * scale, a:offsetx + i * scale, a:offsetx + i * scale + matchlen * scale, scale])
          else
            call add(syn, calendar#text#new(matchlen * scale, a:offsetx + i * scale, a:offsety + j * scale, a:syn).height(scale))
            let num += 1
          endif
        endif
        let i += matchlen
      endwhile
      let pp = p
      let above_num = num
    endif
    let j += 1
  endfor
  return [syn, max]
endfunction

function! s:instance.set_contents() dict abort
  let cs = self.get_letter()
  let syntax = []
  let diffs = []
  let syn = 'NormalSpace'
  let offsetx_start = 0
  for j in range(len(cs))
    if j >= self.y_height
      break
    endif
    if self.prevscale == self.scale && len(self.letters) == len(cs) && self.letters[j] ==# cs[j]
      let syntax_oneline = self.syntax[j]
      let diffsj = self.diffs[j]
    else
      let syntax_oneline = []
      let diffsj = []
      let offsetx = len(cs[j]) ? - calendar#pixel#whitelen(cs[j][0]) * self.scale : 0
      let offsetx_start = offsetx
      let offsety = j * (5 + self.scale + 1)
      let css = split(cs[j], '\zs')
      for i in range(len(css))
        if self.prevscale == self.scale && len(self.letters) == len(cs) && len(self.letters[j]) == len(css) &&
              \ self.letters[j][i] ==# css[i] && diffsj == (i ? self.diffs[j][:i - 1] : []) && offsetx_start == self.offsetx_start
          call add(syntax_oneline, self.syntax[j][i])
          let diffx = self.diffs[j][i]
        else
          let [syns, diffx] = self.gen_syn(css[i], offsetx, offsety, syn)
          call add(syntax_oneline, syns)
        endif
        let offsetx += diffx
        call add(diffsj, diffx)
      endfor
    endif
    call add(syntax, syntax_oneline)
    call add(diffs, diffsj)
  endfor
  let self.letters = cs
  let self.syntax = syntax
  let self.prevscale = self.scale
  let self.diffs = diffs
  let self.offsetx_start = offsetx_start
  let self.syn = []
  let ydict = {}
  let j = 0
  for ss in syntax
    for sss in ss
      if self.scale
        for ssss in sss
          if has_key(ydict, ssss.y)
            call extend(self.syn[ydict[ssss.y]].syn, ssss.syn)
          else
            call add(self.syn, deepcopy(ssss))
            let ydict[ssss.y] = j
            let j += 1
          endif
        endfor
      else
        call extend(self.syn, sss)
      endif
    endfor
  endfor
endfunction

function! s:instance.on_resize() dict abort
  let self.letters = []
  let self.syntax = []
endfunction

function! s:instance.contents() dict abort
  if self.letters != self.get_letter()
    call self.set_contents()
  endif
  let syn = deepcopy(self.syn)
  if self.is_selected() && len(self.syntax) && len(self.syntax[-1]) && len(self.syntax[-1][-1])
    let cur = deepcopy(self.syntax[-1][-1][-1])
    if len(cur.syn) && len(cur.syn[0]) > 3
      let cur.syn[0][0] = 'Cursor'
      let cur.t = 1
      call cur.move(cur.syn[0][3] - cur.syn[0][2] - !!self.scale, cur.syn[0][4] ? cur.syn[0][4] - 1 : 0)
      call add(syn, cur)
    endif
  endif
  return syn
endfunction

function! s:instance.updated() dict abort
  return self.letters != self.get_letter()
endfunction

let s:super_constructor = calendar#constructor#view#new(s:instance)

let &cpo = s:save_cpo
unlet s:save_cpo
