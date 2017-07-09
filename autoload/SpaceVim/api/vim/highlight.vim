let s:self = {}

function! s:self.group2dict(name) abort
    let id = index(map(range(1999), "synIDattr(v:val, 'name')"), a:name)
    if id == -1
        return {}
    endif
    let rst = {
                \ 'name' : synIDattr(id, 'name'),
                \ 'ctermbg' : synIDattr(id, 'bg', 'cterm'),
                \ 'ctermfg' : synIDattr(id, 'fg', 'cterm'),
                \ 'bold' : synIDattr(id, 'bold'),
                \ 'italic' : synIDattr(id, 'italic'),
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
    if empty(a:info)
        return
    endif
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
   for sty in ['hold', 'italic', 'underline']
       if get(a:info, sty, '') ==# '1'
           call add(style, sty)
       endif
   endfor
   if !empty(style)
       let cmd .= ' gui=' . join(style, ',') . ' cterm=' . join(style, ',')
   endif
   try
       exe cmd
   catch
   endtry
endfunction

function! s:self.hide_in_normal(name) abort
    let group = self.group2dict(a:name)
    if empty(group)
        return
    endif
    if &termguicolors || has('gui_running')
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

function! SpaceVim#api#vim#highlight#get() abort
    return deepcopy(s:self)
endfunction
