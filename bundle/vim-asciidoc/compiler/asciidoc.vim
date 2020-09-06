" Asciidoc compiler settings for Vim

if exists("b:current_compiler")
  finish
endif
let b:current_compiler = "asciidoc"

if exists(":CompilerSet") != 2
  command! -nargs=* CompilerSet setlocal <args>
endif

" errorformat stolen from syntastic

let &l:errorformat = ''
      \. '%Easciidoc: %tRROR: %f: line %l: %m,'
      \. '%Easciidoc: %tRROR: %f: %m,'
      \. '%Easciidoc: FAILED: %f: line %l: %m,'
      \. '%Easciidoc: FAILED: %f: %m,'
      \. '%Wasciidoc: %tARNING: %f: line %l: %m,'
      \. '%Wasciidoc: %tARNING: %f: %m,'
      \. '%Wasciidoc: DEPRECATED: %f: line %l: %m,'
      \. '%Wasciidoc: DEPRECATED: %f: %m'

function! s:set_makeprg()
  let &l:makeprg = ''
        \. 'asciidoc'
        \. ' -a urldata'
        \. ' -a icons'
        \. ' ' . get(b:, 'asciidoc_theme', '')
        \. ' ' . get(b:, 'asciidoc_icons_dir', '-a iconsdir=./images/icons/')
        \. ' ' . get(b:, 'asciidoc_backend', '')
        \. ' %'
endfunction


let s:asciidoc_default_themes = ['default', 'flask', 'volnitsky']

if ! exists('g:asciidoc_themes')
  let g:asciidoc_themes = s:asciidoc_default_themes
endif

if ! exists('g:asciidoc_theme')
  let g:asciidoc_theme = 'default'
endif

function! s:available_themes_completer(ArgLead, CmdLine, CursorPos)
  return filter(copy(g:asciidoc_themes), 'v:val =~ a:ArgLead')
endfunction

function! s:update_theme(theme)
  if a:theme == 'default'
    let b:asciidoc_theme = ''
  else
    let b:asciidoc_theme = '-a theme=' . a:theme
  endif
  call s:set_makeprg()
endfunction

command! -nargs=1 -complete=customlist,s:available_themes_completer Theme call <SID>update_theme(<q-args>)

call s:set_makeprg()
call s:update_theme(g:asciidoc_theme)
