((style_element
  (raw_text) @css))

((attribute
   (attribute_name) @_attr
   (quoted_attribute_value (attribute_value) @css))
 (#eq? @_attr "style"))

((script_element
  (raw_text) @javascript))

(comment) @comment
