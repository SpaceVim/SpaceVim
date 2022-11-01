function! s:__constructor(class, ...)
   let parameters = ""
   let body = ""
   let idx = 0
   if a:0 == 0 || a:1.default != 1
       for field in a:class.fields
           if idx != 0
               let parameters .= ", "
           endif
           let parameters .= field.type . " ". field.name
           let body .= "this.". field.name ." = ". field.name .";\n"
           let idx += 1
       endfor
   endif
   let result = "public ". a:class.name ."(". parameters. ") {\n"
   let result .= body
   return result . "}"
endfunction
