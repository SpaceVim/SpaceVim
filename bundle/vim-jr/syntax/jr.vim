" Vim syntax file
" Language:     JR
" Maintainer:   Francois Kilchoer <francois.kilchoer@gmail.com>
" URL:		
" Last Change:  2006 Mar 30

" Relies heavily on the java syntax file...
if version < 600
   syntax clear
elseif exists("b:current_sytax")
   finish
endif

if version < 600
   syntax clear
else
   runtime! syntax/java.vim
   unlet b:current_syntax
endif

:syntax keyword JRinvocation call co send forward
:syntax keyword JRstatement as by elseafter inni receive reply send st view
:syntax keyword JRdeclaration cap op process remote sem vm
:syntax keyword JRprimitive P V
:syntax keyword JRexceptionHand handler
:syntax keyword JRconst noop

if version >= 508 || !exists("did_jr_syn_inits")
   if version < 508
      let did_jr_syn_init = 1
      command -nargs=+ HILink hi link <args>
   else
      command -nargs=+ HiLink hi def link <args>
   endif

   HiLink JRinvocation JRstatement
   HiLink JRstatement Statement
   HiLink JRdeclaration StorageClass
   HiLink JRprimitive Operator
   HiLink JRexceptionHand Exception
   HiLink Jrconst Statement
   delcommand HiLink
endif

let b:current_syntax = "JR"
