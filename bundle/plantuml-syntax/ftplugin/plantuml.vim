" Vim filetype plugin file
" Language:     PlantUML
" License:      VIM LICENSE

if exists('b:loaded_plantuml_plugin')
  finish
endif
let b:loaded_plantuml_plugin = 1
let s:cpo_save = &cpoptions
set cpoptions&vim

if !exists('g:plantuml_executable_script')
  let g:plantuml_executable_script='plantuml'
endif

if exists('loaded_matchit')
  let b:match_ignorecase = 0
  let b:match_words =
        \ '\(\<ref\>\|\<box\>\|\<opt\>\|\<alt\>\|\<group\>\|\<loop\>\|\<note\>\|\<legend\>\):\<else\>:\<end\>' .
        \ ',\<if\>:\<elseif\>:\<else\>:\<endif\>' .
        \ ',\<rnote\>:\<endrnote\>' .
        \ ',\<hnote\>:\<endhnote\>' .
        \ ',\<title\>:\<endtitle\>' .
        \ ',\<\while\>:\<endwhile\>' .
        \ ',@startuml:@enduml' .
        \ ',@startwbs:@endwbs' .
        \ ',@startmindmap:@endmindmap'
endif

if get(g:, 'plantuml_set_makeprg', 1)
  let &l:makeprg=g:plantuml_executable_script . ' %'
endif

setlocal comments=s1:/',mb:',ex:'/,:' commentstring=/'%s'/ formatoptions-=t formatoptions+=croql

let b:endwise_addition = '\=index(["dot","mindmap","uml","salt","wbs"], submatch(0))!=-1 ? "@end" . submatch(0) : index(["note","legend"], submatch(0))!=-1 ? "end " . submatch(0) : "end"'
let b:endwise_words = 'loop,group,alt,note,legend,startdot,startmindmap,startuml,startsalt,startwbs'
let b:endwise_pattern = '^\s*\zs\(loop\|group\|alt\|note\ze[^:]*$\|legend\|@start\zs\(dot\|mindmap\|uml\|salt\|wbs\)\)\>.*$'
let b:endwise_syngroups = 'plantumlKeyword,plantumlPreProc'

let &cpoptions = s:cpo_save
unlet s:cpo_save
