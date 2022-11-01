function! s:__class_annotation(class, options)
    let result = "package ". a:options.package .";\n\n"
    let result .= "public @interface ". a:options.name
    if has_key(a:options, 'extends')
        let result .= " extends ". a:options['extends']
    endif
    if has_key(a:options, 'implements')
        let result .= " implements ". a:options['implements']
    endif
    let result .= " {\n"
    for fieldKey in keys(get(a:options, 'fields', {}))
        let field = a:options['fields'][fieldKey]
        let result .= field['mod']. " ". field['type']. " ". field['name']. ";\n"
    endfor
    return result . "\n}"
endfunction
