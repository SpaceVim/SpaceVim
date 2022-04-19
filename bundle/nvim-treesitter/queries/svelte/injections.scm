; inherits: html_tags

(
  (style_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @scss)
  (#any-of? @_lang "scss" "postcss" "less")
)

((attribute
   (attribute_name) @_attr
   (quoted_attribute_value (attribute_value) @css))
 (#eq? @_attr "style"))

[
  (raw_text_expr)
  (raw_text_each)
] @javascript

(
  (script_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @typescript)
  (#any-of? @_lang "ts" "typescript")
)

(comment) @comment
