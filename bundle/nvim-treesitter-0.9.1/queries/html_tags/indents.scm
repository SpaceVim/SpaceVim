[
  (
    (element
      (start_tag 
        (tag_name) @_not_special)
    )
    (#not-any-of? @_not_special "meta" "link")
  )
  (element (self_closing_tag))
] @indent.begin

; These tags are usually written one-lined and doesn't use self-closing tags so special-cased them
; but add indent to the tag to make sure attributes inside them are still indented if written multi-lined
(
  (start_tag 
     (tag_name) @_special)
  (#any-of? @_special "meta" "link")
) @indent.begin


; These are the nodes that will be captured when we do `normal o`
; But last element has already been ended, so capturing this
; to mark end of last element
(element (end_tag [">"] @indent.end))
(element (self_closing_tag "/>" @indent.end))

; Script/style elements aren't indented, so only branch the end tag of other elements
(element (end_tag) @indent.branch)
[
  ">"
  "/>"
] @indent.branch

(comment) @indent.ignore
