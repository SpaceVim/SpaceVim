function! s:__toString_StringBuilder(class)
   let result = "@Override\n"
   let result .= "public String toString() {\n"
   let result .= "final StringBuilder sb = new StringBuilder(\"". a:class.name . "{\");\n"
   let i = 0
   for field in a:class.fields
       if i > 0
           let result .= "\nsb.append(\", "
       else
           let result .= "sb.append(\""
           let i += 1
       endif
       if has_key(field, "getter")
           let f = field.getter
       else
           let f = field.name
       endif
       let f = field.isArray ? "java.util.Arrays.toString(". f .")" : f
       let result .= field.name ." = \").append(". f. ");"
   endfor
   return result . "\nreturn sb.append(\"}\").toString();\n}"
endfunction'
