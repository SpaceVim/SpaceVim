[
 "@media"
 "@import"
 "@charset"
 "@namespace"
 "@supports"
 "@keyframes"
 (at_keyword)
 (to)
 (from)
 (important)
 ] @keyword

(comment) @comment

[
 (tag_name)
 (nesting_selector)
 (universal_selector)
 ] @type

(function_name) @function

[
 "~"
 ">"
 "+"
 "-"
 "*"
 "/"
 "="
 "^="
 "|="
 "~="
 "$="
 "*="
 "and"
 "or"
 "not"
 "only"
 ] @operator


(attribute_selector (plain_value) @string)
(pseudo_element_selector (tag_name) @property)
(pseudo_class_selector (class_name) @property)

[
 (class_name)
 (id_name)
 (namespace_name)
 (property_name)
 (feature_name)
 (attribute_name)
 ] @property


((property_name) @type
                 (#match? @type "^--"))
((plain_value) @type
               (#match? @type "^--"))

[
 (string_value)
 (color_value)
 (unit)
 ] @string

[
 (integer_value)
 (float_value)
 ] @number

[
 "#"
 ","
 "."
 ":"
 "::"
 ";"
 ] @punctuation.delimiter

[
 "{"
 ")"
 "("
 "}"
 ] @punctuation.bracket

(ERROR) @error
