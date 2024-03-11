((preproc_def (preproc_arg) @hlsl)
  (#lua-match? @hlsl "\n"))
(preproc_function_def (preproc_arg) @hlsl)
(preproc_call (preproc_arg) @hlsl)

(comment) @comment
