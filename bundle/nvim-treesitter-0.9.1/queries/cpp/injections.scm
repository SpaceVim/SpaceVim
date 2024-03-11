((preproc_def (preproc_arg) @cpp)
  (#lua-match? @cpp "\n"))
(preproc_function_def (preproc_arg) @cpp)
(preproc_call (preproc_arg) @cpp)

(comment) @comment

(raw_string_literal
  delimiter: (raw_string_delimiter) @language
  (raw_string_content) @content)
