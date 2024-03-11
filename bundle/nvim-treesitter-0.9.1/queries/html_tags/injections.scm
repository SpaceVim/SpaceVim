; <style>...</style>
; <style blocking> ...</style>
; Add "lang" to predicate check so that vue/svelte can inherit this
; without having this element being captured twice
(
  (style_element
    (start_tag) @_no_type_lang
      (#not-lua-match? @_no_type_lang "%slang%s*=")
      (#not-lua-match? @_no_type_lang "%stype%s*=")
    (raw_text) @css))

(
  (style_element
    (start_tag
      (attribute
        (attribute_name) @_type
        (quoted_attribute_value (attribute_value) @_css)))
    (raw_text) @css)
  (#eq? @_type "type")
  (#eq? @_css "text/css")
)

; <script>...</script>
; <script defer>...</script>
(
  (script_element
    (start_tag) @_no_type_lang
      (#not-lua-match? @_no_type_lang "%slang%s*=")
      (#not-lua-match? @_no_type_lang "%stype%s*=")
    (raw_text) @javascript))

; <script type="mimetype-or-well-known-script-type">
(script_element
   (start_tag
      ((attribute
           (attribute_name) @_attr (#eq? @_attr "type")
           (quoted_attribute_value (attribute_value) @_type))))
   (raw_text) @content (#set-lang-from-mimetype! @_type))

; <a style="/* css */">
((attribute
   (attribute_name) @_attr
   (quoted_attribute_value (attribute_value) @css))
 (#eq? @_attr "style"))

; lit-html style template interpolation
; <a @click=${e => console.log(e)}>
; <a @click="${e => console.log(e)}">
((attribute
  (quoted_attribute_value (attribute_value) @javascript))
  (#lua-match? @javascript "%${")
  (#offset! @javascript 0 2 0 -1))
((attribute
  (attribute_value) @javascript)
  (#lua-match? @javascript "%${")
  (#offset! @javascript 0 2 0 -2))

(comment) @comment

; <input pattern="[0-9]"> or <input pattern=[0-9]>
(element (_
  (tag_name) @_tagname (#eq? @_tagname "input")
  ((attribute
    (attribute_name) @_attr [
      (quoted_attribute_value (attribute_value) @regex)
      (attribute_value) @regex
    ] (#eq? @_attr "pattern")))
))

; <input type="checkbox" onchange="this.closest('form').elements.output.value = this.checked">
(attribute
  (attribute_name) @_name
  (#lua-match? @_name "^on[a-z]+$")
  (quoted_attribute_value (attribute_value) @javascript))
