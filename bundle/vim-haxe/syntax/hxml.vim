" Vim syntax file
" Author    : Justin Donaldson (jdonaldson@gmail.com)
"  Based extensively on a version by Ganesh Gunasegaran(me at itsgg.com)
" Language  : hxml

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax='hxml'
endif

" Simple TODO/comment handling
syntax keyword hxmlTodo contained TODO FIXME XXX NOTE
syntax match hxmlComment "#.*$" contains=hxmlTodo

" basic flags
syntax match hxmlType "-v"
syntax match hxmlType "-x"
syntax match hxmlType "-D"

"target/config flags
syntax match hxmlType "--\?as3"
syntax match hxmlType "--\?cmd"
syntax match hxmlType "--\?cp"
syntax match hxmlType "--\?cpp"
syntax match hxmlType "--\?cppia"
syntax match hxmlType "--\?java"
syntax match hxmlType "--\?cs"
syntax match hxmlType "--\?debug"
syntax match hxmlType "--\?help"
syntax match hxmlType "--\?js"
syntax match hxmlType "--\?lib"
syntax match hxmlType "--\?lua"
syntax match hxmlType "--\?main"
syntax match hxmlType "--\?neko"
syntax match hxmlType "--\?php"
syntax match hxmlType "--\?python"
syntax match hxmlType "--\?prompt"
syntax match hxmlType "--\?resource"
syntax match hxmlType "--\?swf"
syntax match hxmlType "--\?swf-header"
syntax match hxmlType "--\?swf-lib"
syntax match hxmlType "--\?swf-version"
syntax match hxmlType "--\?swf9"
syntax match hxmlType "--\?xml"

" haxe 3.0 flags
syntax match hxmlType "--/?dce"
syntax match hxmlType "--/?swf-lib-extern"
syntax match hxmlType "--/?version"
syntax match hxmlType "--/?help-metas"
syntax match hxmlType "--/?help-defines"

" advanced flags
syntax match hxmlStatement "--connect"
syntax match hxmlStatement "--cwd"
syntax match hxmlStatement "--dead-code-elimination"
syntax match hxmlStatement "--display"
syntax match hxmlStatement "--flash-strict"
syntax match hxmlStatement "--flash-use-stage"
syntax match hxmlStatement "--gen-hx-classes"
syntax match hxmlStatement "--help"
syntax match hxmlStatement "--interp"
syntax match hxmlStatement "--js-modern"
syntax match hxmlStatement "--macro"
syntax match hxmlStatement "--next"
syntax match hxmlStatement "--no-inline"
syntax match hxmlStatement "--no-opt"
syntax match hxmlStatement "--no-output"
syntax match hxmlStatement "--no-traces"
syntax match hxmlStatement "--php-front"
syntax match hxmlStatement "--php-lib"
syntax match hxmlStatement "--php-prefix"
syntax match hxmlStatement "--remap"
syntax match hxmlStatement "--times"
syntax match hxmlStatement "--wait"


" Highlight them
highlight link hxmlType Type
highlight link hxmlStatement Statement
highlight link hxmlComment Comment
highlight link hxmlTodo Todo
