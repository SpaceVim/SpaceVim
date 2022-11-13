(lua_statement . (_) @lua)
(ruby_statement . (_) @ruby)
(python_statement . (_) @python)
;; If we support perl at some point...
;; (perl_statement . (_) @perl)

(autocmd_statement (pattern) @regex)

((set_item
   option: (option_name) @_option
   value: (set_value) @vim)
  (#any-of? @_option
    "includeexpr" "inex"
    "printexpr" "pexpr"
    "formatexpr" "fex"
    "indentexpr" "inde"
    "foldtext" "fdt"
    "foldexpr" "fde"
    "diffexpr" "dex"
    "patchexpr" "pex"
    "charconvert" "ccv"))

(comment) @comment
