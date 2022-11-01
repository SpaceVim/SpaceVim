function! s:__class_enum(class, options)
    let result = "package ". a:options.package .";\n\n"
    let result .= "public enum ". a:options.name
    let result .= " {\n"
    for fieldKey in keys(get(a:options, 'fields', {}))
        let field = a:options['fields'][fieldKey]
        let result .= field['mod']. " ". field['type']. " ". field['name']. ";\n"
    endfor
    return result . "\n}"
endfunction
