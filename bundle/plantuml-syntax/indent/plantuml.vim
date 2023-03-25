" Vim indent file
" Language:     PlantUML
" License:      VIM LICENSE

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetPlantUMLIndent()
setlocal indentkeys=o,O,<CR>,<:>,!^F,0end,0else,}

" only define the indent code once
if exists('*GetPlantUMLIndent')
  finish
endif

let s:decIndent = '^\s*\%(end\|else\|fork again\|}\)'

function! GetPlantUMLIndent(...) abort
  "for current line, use arg if given or v:lnum otherwise
  let clnum = a:0 ? a:1 : v:lnum

  if !s:insidePlantUMLTags(clnum)
    return indent(clnum)
  endif

  let pnum = prevnonblank(clnum-1)
  let pindent = indent(pnum)
  let pline = getline(pnum)
  let cline = getline(clnum)

  let s:incIndent = s:getIncIndent()

  if cline =~ s:decIndent
    if pline =~ s:incIndent
      return pindent
    else
      return pindent - shiftwidth()
    endif

  elseif pline =~ s:incIndent
    return pindent + shiftwidth()
  endif

  return pindent

endfunction

function! s:insidePlantUMLTags(lnum) abort
  call cursor(a:lnum, 1)
  return search('@startuml', 'Wbn') && search('@enduml', 'Wn')
endfunction

function! s:listSyntax(syntaxKeyword) abort
  " Get a list of words assigned to a syntax keyword
  " The 'syntax list <syntax keyword>' command returns
  " a string with the keyword itself, followed by xxx,
  " on which we can split to extract the keywords string.
  " This string must then be split on whitespace
  let syntaxWords = split(
        \ execute('syntax list ' . a:syntaxKeyword),
        \ a:syntaxKeyword . ' xxx ')[-1]
  return split(syntaxWords)
endfunction

function! s:typeKeywordIncPattern() abort
  " Extract keywords for plantumlTypeKeyword, returning the inc pattern
  let syntaxWords = join(s:listSyntax('plantumlTypeKeyword'), '\\\|')
  return '^\s*\%(' . syntaxWords . '\)\>.*{'
endfunction

function! s:getIncIndent() abort
  " Function to determine the s:incIndent pattern
  return
        \ '^\s*\%(artifact\|class\|cloud\|database\|entity\|enum\|file\|folder\|frame\|interface\|namespace\|node\|object\|package\|partition\|rectangle\|skinparam\|state\|storage\|together\)\>.*{\s*$\|' .
        \ '^\s*\%(loop\|alt\|opt\|group\|critical\|else\|legend\|box\|if\|while\|fork\|split\)\>\|' .
        \ '^\s*ref\>[^:]*$\|' .
        \ '^\s*[hr]\?note\>\%(\%("[^"]*" \<as\>\)\@![^:]\)*$\|' .
        \ '^\s*title\s*$\|' .
        \ '^\s*skinparam\>.*{\s*$\|' .
        \ s:typeKeywordIncPattern()
endfunction
