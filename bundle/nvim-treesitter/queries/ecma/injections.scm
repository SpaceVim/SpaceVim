(((comment) @_jsdoc_comment
  (#match? @_jsdoc_comment "^/\\*\\*[^\\*].*\\*/")) @jsdoc)

(comment) @comment

(call_expression
 function: ((identifier) @language)
 arguments: ((template_string) @content
   (#offset! @content 0 1 0 -1)))

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

((comment) @_gql_comment
  (#eq? @_gql_comment "/* GraphQL */")
  (template_string) @graphql)

(((template_string) @_template_string
 (#match? @_template_string "^`#graphql")) @graphql)
