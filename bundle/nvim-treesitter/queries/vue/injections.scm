; inherits: html_tags

(
  (style_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @scss)
  (#any-of? @_lang "scss" "postcss" "less")
)

(
  (script_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (raw_text) @typescript)
  (#any-of? @_lang "ts" "typescript")
)

((interpolation
  (raw_text) @javascript))

((directive_attribute
    (quoted_attribute_value
      (attribute_value) @javascript)))

(
  (template_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (text) @pug)
  (#eq? @_lang "pug")
)

(comment) @comment
