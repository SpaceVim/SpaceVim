function! s:__equals(class)
   let result = "@Override\n"
   let result .= "public boolean equals(Object o) {\n"
   let result .= "if (this == o) return true;\n"
   let result .= "if (o == null || getClass() != o.getClass()) return false;\n\n"
   let result .= a:class.name ." object = (". a:class.name .") o;\n\n"
   let idx = 0
   for field in a:class.fields
       if idx != len(a:class.fields) - 1
           let result .= "if "
       else
           let result .= "return !"
       endif
       if index(g:J_PRIMITIVE_TYPES, field.type) > -1
           if field.type == "double"
               let result .= "(Double.compare(". field.name .", object.". field.name .") != 0)"
           elseif field.type == "float"
               let result .= "(Float.compare(". field.name .", object.". field.name .") != 0)"
           else
               let result .= "(". field.name ." != object.". field.name .")"
           endif
       elseif field.isArray
           let result .= "(!java.util.Arrays.equals(". field.name .", object.". field.name ."))"
       else
           let result .= "(". field.name ." != null ? !". field.name .".equals(object.". field.name .") : object.". field.name ." != null)"
       endif
       if idx != len(a:class.fields) - 1
           let result .= " return false;\n"
       else
           let result .= ";\n"
       endif
       let idx += 1
   endfor
   return result. "}"
endfunction'
