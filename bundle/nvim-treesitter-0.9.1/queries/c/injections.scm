((preproc_def (preproc_arg) @c)
  (#lua-match? @c "\n"))
(preproc_function_def (preproc_arg) @c)
(preproc_call (preproc_arg) @c)

(comment) @comment

; TODO: add when asm is added
; (gnu_asm_expression assembly_code: (string_literal) @asm)
; (gnu_asm_expression assembly_code: (concatenated_string (string_literal) @asm))
