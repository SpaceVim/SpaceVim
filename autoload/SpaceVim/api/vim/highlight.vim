let s:self = {}

function! s:self.group2dict(name) abort
    let id = index(map(range(999), 'synIDattr(v:val, "name")'), a:name)
    if id == -1
        return {}
    endif
    let rst = {
                \ 'name' : synIDattr(id, 'name'),
                \ 'ctermbg' : synIDattr(id, 'bg'),
                \ 'ctermfg' : synIDattr(id, 'fg'),
                \ 'bold' : synIDattr(id, 'bold'),
                \ 'italic' : synIDattr(id, 'italic'),
                \ 'underline' : synIDattr(id, 'underline'),
                \ 'guibg' :synIDattr(id, 'bg#'),
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
        let g:wsd = self.group2dict('Normal')
        let bg = self.group2dict('Normal').guibg
        let group.guifg = bg
        let group.guibg = bg
    else
        let bg = self.group2dict('Normal').ctermbg
        let group.ctermfg = bg
        let group.ctermbg = bg
    endif
    call self.hi(group)
endfunction

function! SpaceVim#api#vim#highlight#get() abort
    return deepcopy(s:self)
endfunction
