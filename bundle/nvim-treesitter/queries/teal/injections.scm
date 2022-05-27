(
  (function_call
    (index
      (identifier) @_cdef_identifier)
    (arguments
      (string) @c)
  )

  (#eq? @_cdef_identifier "cdef")
  (#lua-match? @c "^[\"']")
  (#offset! @c 0 1 0 -1)
)

(
  (function_call
    (index
      (identifier) @_cdef_identifier)
    (arguments
      (string) @c)
  )

  (#eq? @_cdef_identifier "cdef")
  (#lua-match? @c "^%[%[")
  (#offset! @c 0 2 0 -2)
)

(comment) @comment
