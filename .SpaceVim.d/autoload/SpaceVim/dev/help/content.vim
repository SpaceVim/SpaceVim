

function! SpaceVim#dev#help#content#parser(profile, dir) abort
  let head = [
        \ '*' . a:profile.name . '*',
        \ ] + split(a:profile.description, "\n")
        \ +
        \ [
        \ a:profile.author . repeat(' ', 72 - strdisplaywidth(a:profile.author . a:profile.name )) . '*' . a:profile.name  . '*'
        \ ]
  return {
        \ 'en' : head + s:parser(a:dir),
        \ 'cn' : head,
        \ }
endfunction


function! s:parser(dir) abort
  return []
endfunction

let s:help = {
      \ 'content' : [],
      \ }
function! Parser(dir) abort
  let files = SpaceVim#util#globpath(a:dir, '**/*.vim')
  for file in files
    call s:parser_file(file)
  endfor
  return s:help
endfunction

function! s:parser_file(file) abort
  let inblock = 0
  let block = ''
  for line in readfile(a:file)
    if line == '""'
      let inblock = 1
    else
      if inblock
        if line =~ '^"'
          let block .= "\n" . line[1:]
        else
          let inblock = 0
          if line =~ '^let'
            call s:parser_let(block)
          elseif line =~ '^fu'
            call s:parser_fu(block)
          elseif line =~ '^\s*$'
            call s:parser_core(block)
          endif
        endif
      endif
    endif
  endfor
endfunction

function! s:parser_let(block) abort

endfunction

function! s:parser_fu(block) abort

endfunction

function! s:parser_core(block) abort
  let section = {'name' : ''}
  for line in split(a:block, "\n")
    if line =~ '^@section\s'
      let sec = split(split(line, '@section ')[0], ', ')
      let section.name = sec[0]
      let section.shortname = sec[1]
    elseif !empty(section.name)
      let section.body .= "\n" . line
    endif
  endfor
  if !empty(section.name)
    call add(s:help.content, section)
  endif
endfunction
