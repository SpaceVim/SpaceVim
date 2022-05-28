" =============================================================================
" Filename: autoload/calendar/text.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:32:06.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Text object, string with a position to display, and syntaxes.
"   s: The string (if it is a string) or the length of spaces (if it is a number)
"   x: Position x
"   y: Position y
"   syn: The syntax string (For example, Sunday, Saturday and Cursor)
fu! calendar#text#new(s, x, y, syn) abort
  retu extend(copy(s:self),{'s':a:s,'x':a:x,'y':a:y,'t':!type(a:s),'syn':[[a:syn,a:y,a:x,a:x+(type(a:s)?len(a:s):a:s),0]]})
endfu

let s:self = {}

" Move all the things.
fu! s:self.move(x, y) dict abort
  let self.x += a:x
  let self.y += a:y
  cal map(self.syn, '[v:val[0],v:val[1]+a:y,v:val[2]+a:x,v:val[3]+a:x,v:val[4]]')
  retu self
endfu

" Extend the syntaxes.
fu! s:self.height(h) dict abort
  for s in self.syn
    if a:h
      let s[4] = a:h
    en
  endfo
  retu self
endfu

" Split all the extend the syntaxes.
fu! s:self.split() dict abort
  let syn = []
  for s in self.syn
    if s[4]
      let t = s
      let l = s[4]
      let s[4] = 0
      wh l > 1
        let t = copy(t)
        let t[1] += 1
        cal add(syn, t)
        let l -= 1
      endw
    en
  endfo
  retu map(syn, 'calendar#text#new(v:val[3] - v:val[2], v:val[2], v:val[1], v:val[0])')
endfu

" :h version7 | /7.2.061
silent! call calendar#string#strdisplaywidth('')

let s:W = function((exists('*strdisplaywidth') ? '' : 'calendar#string#') . 'strdisplaywidth')
let s:T = function('calendar#string#truncate')
let s:R = function('calendar#string#truncate_reverse')

fu! s:self.concat(t) dict abort
  let s = self.syn
  let t = a:t.syn
  let q = range(len(s))
  let l = s:T(self.s, a:t.x)
  let r = s:R(self.s, s:W(self.s) - s:W(a:t.s) - a:t.x)
  let x = len(l) - a:t.x
  let e = len(l) + len(a:t.s)
  let f = len(self.s) - len(r)
  let y = min([e, f])
  let m = e - f
  if !a:t.t
    let self.s = l . a:t.s . r
  en
  if x
    cal s:shift(t, x)
  en
  for i in q
    if s[i][2] >= y | let s[i][2] += m | en
    if s[i][3] >= y | let s[i][3] += m | en
  endfo
  retu x
endfu

fu! s:shift(t, x) abort
  let p = range(len(a:t))
  for i in p
    let a:t[i][2] += a:x
    let a:t[i][3] += a:x
  endfo
endfu

fu! s:over(j, v, u) abort
  let [s, d] = [[], []]
  let v = a:v
  let u = a:u
  if u[2] < v[2]
    if u[3] <= v[3]
      let u[3] = v[2]
    el
      let syn = copy(u)
      let u[3] = v[2]
      let syn[2] = v[3]
      cal add(s, syn)
    en
  el
    if u[3] <= v[3]
      cal add(d, a:j)
    el
      let u[2] = v[3]
    en
  en
  retu [s, d]
endfu

" Text piling, the most important method of text object.
fu! s:self.over(t) dict abort
  let s = self.syn
  let t = a:t.syn
  let x = a:t.t ? 0 : self.concat(a:t)
  if len(s) == 1 && s[0][0] == ''
    let self.syn = t
    retu x
  en
  let p = range(len(t))
  for i in p
    let d = []
    for j in range(len(s))
      if s[j][3] <= t[i][2]
        con
      elsei s[j][2] >= t[i][3]
        con
      elsei t[i][0] != 'Cursor' && s[j][0] != 'Cursor'
        let [b, c] = s:over(j, t[i], s[j])
        cal extend(s, b)
        cal extend(d, c)
      en
    endfo
    if len(d)
      for n in reverse(d)
        cal remove(s, n)
      endfo
    en
  endfo
  cal extend(s, t)
  retu x
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
