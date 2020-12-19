
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" " Vim indent file
"
" Language: typescriptreact (TypeScript)
" from:
" https://github.com/peitalin/vim-jsx-typescript/issues/4#issuecomment-564519091
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime! indent/typescript.vim

let b:did_indent = 1

if !exists('*GetTypescriptIndent') | finish | endif

setlocal indentexpr=GetTsxIndent()
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e,*<Return>,<>>,<<>,/

if exists('*shiftwidth')
  function! s:sw()
    return shiftwidth()
  endfunction
else
  function! s:sw()
    return &sw
  endfunction
endif

let s:real_endtag = '\s*<\/\+[A-Za-z]*>'
let s:return_block = '\s*return\s\+('
function! s:SynSOL(lnum)
  return map(synstack(a:lnum, 1), 'synIDattr(v:val, "name")')
endfunction

function! s:SynEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynAttrJSX(synattr)
  return a:synattr =~ "^tsx"
endfunction

function! s:SynXMLish(syns)
  return s:SynAttrJSX(get(a:syns, -1))
endfunction

function! s:SynJSXDepth(syns)
  return len(filter(copy(a:syns), 'v:val ==# "tsxRegion"'))
endfunction

function! s:SynJSXCloseTag(syns)
  return len(filter(copy(a:syns), 'v:val ==# "tsxCloseTag"'))
endfunction

function! s:SynJsxEscapeJs(syns)
  return len(filter(copy(a:syns), 'v:val ==# "tsxJsBlock"'))
endfunction

function! s:SynJSXContinues(cursyn, prevsyn)
  let curdepth = s:SynJSXDepth(a:cursyn)
  let prevdepth = s:SynJSXDepth(a:prevsyn)

  return prevdepth == curdepth ||
      \ (prevdepth == curdepth + 1 && get(a:cursyn, -1) ==# 'tsxRegion')
endfunction

function! GetTsxIndent()
  let cursyn  = s:SynSOL(v:lnum)
  let prevsyn = s:SynEOL(v:lnum - 1)
  let nextsyn = s:SynEOL(v:lnum + 1)
  let currline = getline(v:lnum)

  if ((s:SynXMLish(prevsyn) && s:SynJSXContinues(cursyn, prevsyn)) || currline =~# '\v^\s*\<')
    let preline = getline(v:lnum - 1)

    if currline =~# '\v^\s*\/?\>' " /> >
      return preline =~# '\v^\s*\<' ? indent(v:lnum - 1) : indent(v:lnum - 1) - s:sw()
    endif

    if preline =~# '\v\{\s*$' && preline !~# '\v^\s*\<'
      return currline =~# '\v^\s*\}' ? indent(v:lnum - 1) : indent(v:lnum - 1) + s:sw()
    endif

    " return (      | return (     | return (
    "   <div></div> |   <div       |   <div
    "     {}        |     style={  |     style={
    "   <div></div> |     }        |     }
    " )             |     foo="bar"|   ></div>
    if preline =~# '\v\}\s*$'
      if currline =~# '\v^\s*\<\/'
        return indent(v:lnum - 1) - s:sw()
      endif
      let ind = indent(v:lnum - 1)
      if preline =~# '\v^\s*\<'
        let ind = ind + s:sw()
      endif
      if currline =~# '\v^\s*\/?\>'
        let ind = ind - s:sw()
      endif
      return ind
    endif

    " return ( | return (
    "   <div>  |   <div>
    "   </div> |   </div>
    " ##);     | );
    if preline =~# '\v(\s?|\k?)\($' || preline =~# '\v^\s*\<\>'
      return indent(v:lnum - 1) + s:sw()
    endif

    let ind = s:XmlIndentGet(v:lnum)

    " <div           | <div
    "   hoge={       |   hoge={
    "   <div></div>  |   ##<div></div>
    if s:SynJsxEscapeJs(prevsyn) && preline =~# '\v\{\s*$'
      let ind = ind + s:sw()
    endif

    " />
    if preline =~# '\v^\s*\/?\>$' || currline =~# '\v^\s*\<\/\>'
      "let ind = currline =~# '\v^\s*\<\/' ? ind : ind + s:sw()
      let ind = ind + s:sw()
    " }> or }}\> or }}>
    elseif preline =~# '\v^\s*\}?\}\s*\/?\>$'
      let ind = ind + s:sw()
    " ></a
    elseif preline =~# '\v^\s*\>\<\/\a'
      let ind = ind + s:sw()
    elseif preline =~# '\v^\s*}}.+\<\/\k+\>$'
      let ind = ind + s:sw()
    endif

    " <div            | <div
    "   hoge={        |   hoge={
    "     <div></div> |     <div></div>
    "     }           |   }##
    if currline =~# '}$' && !(currline =~# '\v\{')
      let ind = ind - s:sw()
    endif

    if currline =~# '^\s*)' && s:SynJSXCloseTag(prevsyn)
      let ind = ind - s:sw()
    endif
  else
    let ind = GetTypescriptIndent()
  endif
  return ind
endfunction

let b:xml_indent_open = '.\{-}<\a'
let b:xml_indent_close = '.\{-}</'

function! s:XmlIndentWithPattern(line, pat)
  let s = substitute('x'.a:line, a:pat, "\1", 'g')
  return strlen(substitute(s, "[^\1].*$", '', ''))
endfunction

" [-- return the sum of indents of a:lnum --]
function! s:XmlIndentSum(lnum, style, add)
  let line = getline(a:lnum)
  if a:style == match(line, '^\s*</')
    return (&sw *
          \  (s:XmlIndentWithPattern(line, b:xml_indent_open)
          \ - s:XmlIndentWithPattern(line, b:xml_indent_close)
          \ - s:XmlIndentWithPattern(line, '.\{-}/>'))) + a:add
  else
    return a:add
  endif
endfunction

function! s:XmlIndentGet(lnum)
  " Find a non-empty line above the current line.
  let lnum = prevnonblank(a:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0 | return 0 | endif

  let ind = s:XmlIndentSum(lnum, -1, indent(lnum))
  let ind = s:XmlIndentSum(a:lnum, 0, ind)
  return ind
endfunction
