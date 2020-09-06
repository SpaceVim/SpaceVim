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
        \. 'asciidoctor'
        \. ' -a urldata'
        \. ' -a icons'
        \. ' ' . get(b:, 'asciidoctor_theme', '')
        \. ' ' . get(b:, 'asciidoctor_icons_dir', '-a iconsdir=./images/icons/')
        \. ' ' . get(b:, 'asciidoctor_backend', '')
        \. ' %'
endfunction

if ! exists('g:asciidoctor_themes_dir')
  echohl Warning
  echom 'Set g:asciidoctor_themes_dir for theme support.'
  echohl None
endif

if ! exists('g:asciidoctor_theme')
  let g:asciidoctor_theme = 'default'
endif

function! s:asciidoctor_themes()
  if ! exists('g:asciidoctor_themes_dir')
    echohl Warning
    echom 'Set g:asciidoctor_themes_dir for theme support.'
    echohl None
    return ['default']
  endif
  return map(glob(g:asciidoctor_themes_dir . '/*.css', 0, 1)
        \, 'fnamemodify(v:val, ":p:t")')
endfunction

function! s:available_themes_completer(ArgLead, CmdLine, CursorPos)
  return filter(s:asciidoctor_themes(), 'v:val =~ a:ArgLead')
endfunction

function! s:update_theme(theme)
  if a:theme == 'default'
    let b:asciidoctor_theme = ''
  else
    let b:asciidoctor_theme = '-a stylesheet=' . a:theme . ' -a stylesdir=' . g:asciidoctor_themes_dir
  endif
  call s:set_makeprg()
endfunction

command! -nargs=1 -complete=customlist,s:available_themes_completer Theme call <SID>update_theme(<q-args>)

call s:set_makeprg()
call s:update_theme(g:asciidoctor_theme)
