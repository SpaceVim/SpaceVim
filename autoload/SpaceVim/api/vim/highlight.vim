"=============================================================================
" highlight.vim --- SpaceVim highlight API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}


" the key of a highlight should be:
" name: the name of the highlight group
" ctermbg: background color in cterm
" ctermfg: fround color in cterm
" bold: if bold?
" italic: if italic?
" underline: if underline
" guibg: gui background color
" guifg: found color in gui
" reverse: if reverse

function! s:self.group2dict(name) abort
    let id = hlID(a:name)
    if id == 0
        return {
                    \ 'name' : '',
                    \ 'ctermbg' : '',
                    \ 'ctermfg' : '',
                    \ 'bold' : '',
                    \ 'italic' : '',
                    \ 'reverse' : '',
                    \ 'underline' : '',
                    \ 'guibg' : '',
                    \ 'guifg' : '',
                    \ }
    endif
    let rst = {
                \ 'name' : synIDattr(id, 'name'),
                \ 'ctermbg' : synIDattr(id, 'bg', 'cterm'),
                \ 'ctermfg' : synIDattr(id, 'fg', 'cterm'),
                \ 'bold' : synIDattr(id, 'bold'),
                \ 'italic' : synIDattr(id, 'italic'),
                \ 'reverse' : synIDattr(id, 'reverse'),
                \ 'underline' : synIDattr(id, 'underline'),
                \ 'guibg' : synIDattr(id, 'bg#'),
                \ 'guifg' : synIDattr(id, 'fg#'),
                \ }
    return rst
endfunction

function! s:self.unite(base, target, part) abort
    let base = self.group2dict(a:base)
    let target = self.group2dict(a:target)
    if empty(base) || empty(target)
        return
    elseif get(base,a:part, '') ==# get(target, a:part, '')
        return
    else
        let target[a:part] = base[a:part]
        call self.hi(target)
    endif
endfunction

function! s:self.hi(info) abort
    if empty(a:info) || get(a:info, 'name', '') ==# ''
        return
    endif
    exe 'hi clear ' . a:info.name
    let cmd = 'hi! ' .  a:info.name
    if !empty(a:info.ctermbg)
        let cmd .= ' ctermbg=' . a:info.ctermbg
    endif
    if !empty(a:info.ctermfg)
        let cmd .= ' ctermfg=' . a:info.ctermfg
    endif
    if !empty(a:info.guibg)
        let cmd .= ' guibg=' . a:info.guibg
    endif
    if !empty(a:info.guifg)
        let cmd .= ' guifg=' . a:info.guifg
    endif
    let style = []
    for sty in ['bold', 'italic', 'underline', 'reverse']
        if get(a:info, sty, '') ==# '1'
            call add(style, sty)
        endif
    endfor
    if !empty(style)
        let cmd .= ' gui=' . join(style, ',') . ' cterm=' . join(style, ',')
    endif
    try
        silent! exe cmd
    catch
    endtry
endfunction

function! s:self.hide_in_normal(name) abort
    let group = self.group2dict(a:name)
    if empty(group)
        return
    endif
    if (exists('+termguicolors') && &termguicolors ) || has('gui_running')
        let bg = self.group2dict('Normal').guibg
        if empty(bg)
            return
        endif
        let group.guifg = bg
        let group.guibg = bg
    else
        let bg = self.group2dict('Normal').ctermbg
        if empty(bg)
            return
        endif
        let group.ctermfg = bg
        let group.ctermbg = bg
    endif
    call self.hi(group)
endfunction


function! s:self.hi_separator(a, b) abort
    let hi_a = self.group2dict(a:a)
    let hi_b = self.group2dict(a:b)
    let hi_a_b = {
                \ 'name' : a:a . '_' . a:b,
                \ 'guibg' : hi_b.guibg,
                \ 'guifg' : hi_a.guibg,
                \ 'ctermbg' : hi_b.ctermbg,
                \ 'ctermfg' : hi_a.ctermbg,
                \ }
    let hi_b_a = {
                \ 'name' : a:b . '_' . a:a,
                \ 'guibg' : hi_a.guibg,
                \ 'guifg' : hi_b.guibg,
                \ 'ctermbg' : hi_a.ctermbg,
                \ 'ctermfg' : hi_b.ctermbg,
                \ }
    call self.hi(hi_a_b)
    call self.hi(hi_b_a)
endfunction

function! s:self.syntax_at(...) abort
  syntax sync fromstart
  if a:0 < 2
    let l:pos = getpos('.')
    let l:cur_lnum = pos[1]
    let l:cur_col = pos[2]
    if a:0 == 0
      let l:lnum = l:cur_lnum
      let l:col = l:cur_col
    else
      let l:lnum = l:cur_lnum
      let l:col = a:1
    endif
  else
    let l:lnum = a:1
    let l:col = a:2
  endif
  call map(synstack(l:lnum, l:col), 'synIDattr(v:val, "name")')
  return synIDattr(synID(l:lnum, l:col, 1), 'name')
endfunction

function! s:self.syntax_of(pattern, ...) abort
  if a:0 < 1
    let l:nth = 1
  else
    let l:nth = a:1
  endif

  let l:pos_init = getpos('.')
  call cursor(1, 1)
  let found = search(a:pattern, 'cW')
  while found != 0 && nth > 1
    let found = search(a:pattern, 'W')
    let nth -= 1
  endwhile

  if found
    let l:pos = getpos('.')
    let l:output = self.syntax_at(l:pos[1], l:pos[2])
  else
    let l:output = ''
  endif
  call setpos('.', l:pos_init)
  return l:output
endfunction

function! SpaceVim#api#vim#highlight#get() abort
    return deepcopy(s:self)
endfunction
