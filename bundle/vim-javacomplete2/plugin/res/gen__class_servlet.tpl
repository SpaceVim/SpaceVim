function! s:__class_servlet(class, options)
    let name = a:options.name
    let url = tolower(substitute(name, '\C\([A-Z]\)', '/\1', 'g'))
    let result = "package ". a:options.package .";\n\n"
    let result .= "@WebServlet(name = \"". name. "\", urlPatterns = {\"". url. "\"})\n"
    let result .= "public class ". name
    if has_key(a:options, 'extends')
        let result .= " extends ". a:options['extends']
    else
        let result .= " extends HttpServlet"
    endif
    if has_key(a:options, 'implements')
        let result .= " implements ". a:options['implements']
    endif
    let result .= " {\n"
    for fieldKey in keys(get(a:options, 'fields', {}))
        let field = a:options['fields'][fieldKey]
        let result .= field['mod']. " ". field['type']. " ". field['name']. ";\n"
    endfor
    let result .= "\nprotected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {\n"
    let result .= "response.setContentType(\"text/html;charset=UTF-8\");\n"
    let result .= "try (PrintWriter out = response.getWriter()) {\n"
    let result .= "try (PrintWriter out = response.getWriter()) {\n"
    let result .= "out.println(\"<!DOCTYPE HTML\");\n"
    let result .= "out.println(\"<html>\");\n"
    let result .= "out.println(\"<head>\");\n"
    let result .= "out.println(\"<title>Servlet ". name. "</title>\");  \n"
    let result .= "out.println(\"</head>\");\n"
    let result .= "out.println(\"<body>\");\n"
    let result .= "out.println(\"<h1>Servlet ". name. " at ". url. "</h1>\");\n"
    let result .= "out.println(\"</body>\");\n"
    let result .= "out.println(\"</html>\");\n"
    let result .= "} finally {\n"
    let result .= "out.close();\n"
    let result .= "}\n"
    let result .= "}\n"
    let result .= "}\n"
    let result .= "\nprotected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {\n"
    let result .= "processRequest(request, response);\n"
    let result .= "}\n"
    let result .= "\nprotected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {\n"
    let result .= "processRequest(request, response);\n"
    let result .= "}\n"
    return result . "\n}"
endfunction
