; inherits: html_tags

(
  (style_element
    (start_tag
      (attribute
        (attribute_name) @_attr
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @scss)
  (#eq? @_attr "lang")
  (#any-of? @_lang "scss" "postcss" "less")
)

[
  (raw_text_expr)
  (raw_text_each)
] @javascript

(
  (script_element
    (start_tag
      (attribute
        (attribute_name) @_attr
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @typescript)
  (#eq? @_attr "lang") 
  (#any-of? @_lang "ts" "typescript")
)

(
  (element
    (start_tag
      (attribute
        (attribute_name) @_attr
        (quoted_attribute_value
          (attribute_value) @_lang)))
    (text) @pug)
  (#eq? @_attr "lang") 
  (#eq? @_lang "pug")
)
