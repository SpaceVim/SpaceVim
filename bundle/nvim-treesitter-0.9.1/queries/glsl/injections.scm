((preproc_def (preproc_arg) @glsl)
  (#lua-match? @glsl "\n"))
(preproc_function_def (preproc_arg) @glsl)
(preproc_call (preproc_arg) @glsl)

(comment) @comment
