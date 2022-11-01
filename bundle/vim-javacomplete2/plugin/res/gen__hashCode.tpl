function! s:__hashCode(class)
   let result = "@Override\n"
   let result .= "public int hashCode() {\n"
   let result .= "int result = 17;\n"
   for field in a:class.fields
       if index(g:J_PRIMITIVE_TYPES, field.type) > -1
           if field.type == "boolean"
               let result .= "result = 31 * result + (". field.name . " ? 0 : 1);\n"
           elseif field.type == "long"
               let result .= "result = 31 * result + (int)(". field.name . " ^ (". field.name . " >>> 32));\n"
           elseif field.type == "float"
               let result .= "result = 31 * result + Float.floatToIntBits(". field.name . ");\n"
           elseif field.type == "double"
               let result .= "long ". field.name . "Long = Double.doubleToLongBits(". field.name .");\n"
               let result .= "result = 31 * result + (int)(". field.name . "Long ^ (". field.name . "Long >>> 32));\n"
           else
               let result .= "result = 31 * result + (int)". field.name . ";\n"
           endif
       elseif field.isArray
           let result .= "result = 31 * result + java.util.Arrays.hashCode(". field.name . ");\n"
       else
           let result .= "result = 31 * result + (". field.name . " != null ? ". field.name .".hashCode() : 0);\n"
       endif
   endfor
   return result. "return result;\n}"
endfunction'
