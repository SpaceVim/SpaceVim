; inherits: html

((frontmatter
    (raw_text) @typescript))

((interpolation
    (raw_text) @tsx))

((script_element
    (raw_text) @typescript))

((style_element
   (start_tag
     (attribute
       (attribute_name) @_lang_attr
       (quoted_attribute_value (attribute_value) @_lang_value)))
   (raw_text) @scss)
 (#eq? @_lang_attr "lang")
 (#eq? @_lang_value "scss"))
