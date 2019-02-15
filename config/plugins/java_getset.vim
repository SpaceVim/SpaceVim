let g:java_getset_disable_map = get(g:, 'java_getset_disable_map', 1)
let g:javagetset_setterTemplate = get(g:, 'javagetset_setterTemplate',
      \ "/**\n" .
      \ " * Set %varname%.\n" .
      \ " *\n" .
      \ " * @param %varname% the value to set.\n" .
      \ " */\n" .
      \ "%modifiers% void %funcname%(%type% %varname%){\n" .
      \ "    this.%varname% = %varname%;\n" .
      \ '}')
let g:javagetset_getterTemplate = get(g:, 'javagetset_getterTemplate',
      \ "/**\n" .
      \ " * Get %varname%.\n" .
      \ " *\n" .
      \ " * @return %varname% as %type%.\n" .
      \ " */\n" .
      \ "%modifiers% %type% %funcname%(){\n" .
      \ "    return %varname%;\n" .
      \ '}')

" vim:set et sw=2:
