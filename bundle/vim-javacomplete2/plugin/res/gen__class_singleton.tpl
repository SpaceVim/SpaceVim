function! s:__class_singleton(class, options)
    let result = "package ". a:options.package .";\n\n"
    let result .= "public class ". a:options.name
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
    let name = a:options['name']
    let result .= "\nprivate ". name. "() {\n\n}\n"
    let result .= "\npublic static ". name. " getInstance() {\n"
    let result .= "return ". name. "Holder.INSTANCE;\n"
    let result .= "}\n"
    let result .= "\nprivate static class ". name. "Holder {\n"
    let result .= "private static final ". name. " INSTANCE = new ". name. "();\n"
    let result .= "}\n"
    return result . "\n}"
endfunction
