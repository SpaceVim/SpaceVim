; inherits html_tags

; <script lang="css">
((style_element
    (start_tag
      (attribute
        (attribute_name) @_lang
        (quoted_attribute_value (attribute_value) @_css)))
    (#eq? @_lang "lang")
    (#eq? @_css "css")
    (raw_text) @css))

; TODO: When nvim-treesitter have postcss and less parser, use @language and @content instead
; <script lang="scss">
((style_element
    (start_tag
      (attribute
        (attribute_name) @_lang
        (quoted_attribute_value (attribute_value) @_scss)))
    (#eq? @_lang "lang")
    (#any-of? @_scss "scss" "less" "postcss")
    (raw_text) @scss))
; <script lang="js">
((script_element
    (start_tag
      (attribute
        (attribute_name) @_lang
        (quoted_attribute_value (attribute_value) @_js)))
    (#eq? @_lang "lang")
    (#eq? @_js "js")
    (raw_text) @javascript))

; <script lang="ts">
((script_element
    (start_tag
      (attribute
        (attribute_name) @_lang
        (quoted_attribute_value (attribute_value) @_ts)))
    (#eq? @_lang "lang")
    (#eq? @_ts "ts")
    (raw_text) @typescript))

; <script lang="tsx">
; <script lang="jsx">
((script_element
    (start_tag
      (attribute
        (attribute_name) @_attr
        (quoted_attribute_value (attribute_value) @language)))
    (#eq? @_attr "lang")
    (#any-of? @language "tsx" "jsx")
    (raw_text) @content))

((interpolation
  (raw_text) @javascript))

((directive_attribute
    (quoted_attribute_value
      (attribute_value) @javascript)))

((template_element
    (start_tag
      (attribute
        (quoted_attribute_value (attribute_value) @_lang)))
    (#eq? @_lang "pug")
    (text) @pug))
