(((comment) @_jsdoc_comment
  (#lua-match? @_jsdoc_comment "^/[*][*][^*].*[*]/$")) @jsdoc)

(comment) @comment

; html(`...`), html`...`, sql(...) etc
(call_expression
 function: ((identifier) @language)
 arguments: [
             (arguments
              (template_string) @content)
             (template_string) @content
            ]
     (#offset! @content 0 1 0 -1)
     (#not-eq? @content "svg"))

; svg`...` or svg(`...`), which uses the html parser, so is not included in the previous query
(call_expression
 function: ((identifier) @_name (#eq? @_name "svg"))
 arguments: [
             (arguments
              (template_string) @html)
             (template_string) @html
            ]
     (#offset! @html 0 1 0 -1))


(call_expression
 function: ((identifier) @_name
   (#eq? @_name "gql"))
 arguments: ((template_string) @graphql
   (#offset! @graphql 0 1 0 -1)))

(call_expression
 function: ((identifier) @_name
   (#eq? @_name "hbs"))
 arguments: ((template_string) @glimmer
   (#offset! @glimmer 0 1 0 -1)))

((glimmer_template) @glimmer)

; styled.div`<css>`
(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "styled"))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

; styled(Component)`<css>`
(call_expression
 function: (call_expression
   function: (identifier) @_name
     (#eq? @_name "styled"))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

; styled.div.attrs({ prop: "foo" })`<css>`
(call_expression
 function: (call_expression
   function: (member_expression
    object: (member_expression
      object: (identifier) @_name
        (#eq? @_name "styled"))))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))


; styled(Component).attrs({ prop: "foo" })`<css>`
(call_expression
 function: (call_expression
   function: (member_expression
    object: (call_expression
      function: (identifier) @_name
        (#eq? @_name "styled"))))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

(regex_pattern) @regex

; ((comment) @_gql_comment
;   (#eq? @_gql_comment "/* GraphQL */")
;   (template_string) @graphql)

((template_string) @graphql
  (#lua-match? @graphql "^`#graphql")
  (#offset! @graphql 0 1 0 -1))

; el.innerHTML = `<html>`
(assignment_expression
  left: (member_expression
          property: (property_identifier) @_prop
           (#any-of? @_prop "innerHTML" "outerHTML"))
  right: (template_string) @html
    (#offset! @html 0 1 0 -1))

; el.innerHTML = '<html>'
(assignment_expression
   left: (member_expression
           property: (property_identifier) @_prop
            (#any-of? @_prop "innerHTML" "outerHTML"))
   right: (string) @html
            (#offset! @html 0 1 0 -1))
