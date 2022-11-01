function! s:__toString_concat(class)
   let result = "@Override\n"
   let result .= "public String toString() {\n"
   let result .= "return \"". a:class.name ."{\" +\n"
   let i = 0
   for field in a:class.fields
       if i > 0
           let result .= "\n\", "
       else
           let result .= "\""
           let i += 1
       endif
       if has_key(field, "getter")
           let f = field.getter
       else
           let f = field.name
       endif
       let f = field.isArray ? "java.util.Arrays.toString(". f .")" : f
       let result .= field.name ." = \" + ". f. " +"
   endfor
   return result . "\n\"}\";\n}"
endfunction'
