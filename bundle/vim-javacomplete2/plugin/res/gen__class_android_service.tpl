function! s:__class_android_service(class, options)
    let result = "package ". a:options.package .";\n\n"
    let result .= "public class ". a:options.name
    if has_key(a:options, 'extends')
        let result .= " extends ". a:options['extends']
    else
        let result .= " extends Service"
    endif
    if has_key(a:options, 'implements')
        let result .= " implements ". a:options['implements']
    endif
    let result .= " {\n"
    for fieldKey in keys(get(a:options, 'fields', {}))
        let field = a:options['fields'][fieldKey]
        let result .= field['mod']. " ". field['type']. " ". field['name']. ";\n"
    endfor
    let result .= "\n@Override\n"
    let result .= "public IBinder onBind(Intent intent) {\n"
    let result .= "return null;\n}\n"
    return result . "\n}"
endfunction
