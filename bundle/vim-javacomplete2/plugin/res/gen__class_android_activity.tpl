function! s:__class_android_activity(class, options)
    let result = "package ". a:options.package .";\n\n"
    let result .= "public class ". a:options.name
    if has_key(a:options, 'extends')
        let result .= " extends ". a:options['extends']
    else
        let result .= " extends Activity"
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
    let result .= "public void onCreate(Bundle savedInstanceState) {\n"
    let result .= "super.onCreate(savedInstanceBundle);\n}\n"
    return result . "\n}"
endfunction
