(tag_name) @tag
(erroneous_end_tag_name) @error
(comment) @comment
(attribute_name) @tag.attribute
(attribute
  (quoted_attribute_value) @string)
(text) @text @spell

((element (start_tag (tag_name) @_tag) (text) @text.title)
 (#match? @_tag "^(h[0-9]|title)$"))

((element (start_tag (tag_name) @_tag) (text) @text.strong)
 (#any-of? @_tag "strong" "b"))

((element (start_tag (tag_name) @_tag) (text) @text.emphasis)
 (#any-of? @_tag "em" "i"))

((element (start_tag (tag_name) @_tag) (text) @text.strike)
 (#any-of? @_tag "s" "del"))

((element (start_tag (tag_name) @_tag) (text) @text.underline)
 (#eq? @_tag "u"))

((element (start_tag (tag_name) @_tag) (text) @text.literal)
 (#any-of? @_tag "code" "kbd"))

((element (start_tag (tag_name) @_tag) (text) @text.uri)
 (#eq? @_tag "a"))

((attribute
   (attribute_name) @_attr
   (quoted_attribute_value (attribute_value) @text.uri))
 (#any-of? @_attr "href" "src"))

[
 "<"
 ">"
 "</"
 "/>"
] @tag.delimiter

"=" @operator
