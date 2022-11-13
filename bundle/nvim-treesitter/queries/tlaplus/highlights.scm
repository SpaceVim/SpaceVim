; ; Intended for consumption by nvim-treesitter 
; ; Default capture names for nvim-treesitter found here:
; ; https://github.com/nvim-treesitter/nvim-treesitter/blob/e473630fe0872cb0ed97cd7085e724aa58bc1c84/lua/nvim-treesitter/highlight.lua#L14-L104

; Keywords
[
  "ACTION"
  "ASSUME"
  "ASSUMPTION"
  "AXIOM"
  "BY"
  "CASE"
  "CHOOSE"
  "CONSTANT"
  "CONSTANTS"
  "COROLLARY"
  "DEF"
  "DEFINE"
  "DEFS"
  "DOMAIN"
  "ELSE"
  "ENABLED"
  "EXCEPT"
  "EXTENDS"
  "HAVE"
  "HIDE"
  "IF"
  "IN"
  "INSTANCE"
  "LAMBDA"
  "LEMMA"
  "LET"
  "LOCAL"
  "MODULE"
  "NEW"
  "OBVIOUS"
  "OMITTED"
  "ONLY"
  "OTHER"
  "PICK"
  "PROOF"
  "PROPOSITION"
  "PROVE"
  "QED"
  "RECURSIVE"
  "SF_"
  "STATE"
  "SUBSET"
  "SUFFICES"
  "TAKE"
  "TEMPORAL"
  "THEN"
  "THEOREM"
  "UNCHANGED"
  "UNION"
  "USE"
  "VARIABLE"
  "VARIABLES"
  "WF_"
  "WITH"
  "WITNESS"
  (address)
  (all_map_to)
  (assign)
  (case_arrow)
  (case_box)
  (def_eq)
  (exists)
  (forall)
  (gets)
  (label_as)
  (maps_to)
  (set_in)
  (temporal_exists)
  (temporal_forall)
] @keyword
;  Pluscal keywords
[
  (pcal_algorithm_start)
  "algorithm"
  "assert"
  "await"
  "begin"
  "call"
  "define"
  "end"
  "fair"
  "goto"
  "macro"
  "or"
  "procedure"
  "process"
  "skip"
  "variable"
  "variables"
  "when"
  "with"
] @keyword
(pcal_with ("=") @keyword)
(pcal_process ("=") @keyword)
[ 
  "if" 
  "then" 
  "else" 
  "elsif"
  (pcal_end_if)
  "either"
  (pcal_end_either)
] @conditional
[ 
  "while" 
  "do" 
  (pcal_end_while) 
  "with" 
  (pcal_end_with)
] @repeat
("return") @keyword.return
("print") @function.macro


; Literals
(binary_number (format) @keyword)
(binary_number (value) @number)
(boolean) @boolean
(boolean_set) @type
(hex_number (format) @keyword)
(hex_number (value) @number)
(int_number_set) @type
(nat_number) @number
(nat_number_set) @type
(octal_number (format) @keyword)
(octal_number (value) @number)
(real_number) @number
(real_number_set) @type
(string) @string
(escape_char) @string.escape
(string_set) @type

; Namespaces and includes
(extends (identifier_ref) @include)
(module name: (_) @namespace)
(pcal_algorithm name: (identifier) @namespace)

; Operators and functions
(bound_infix_op symbol: (_) @function.builtin)
(bound_nonfix_op (infix_op_symbol) @operator)
(bound_nonfix_op (postfix_op_symbol) @operator)
(bound_nonfix_op (prefix_op_symbol) @operator)
(bound_postfix_op symbol: (_) @function.builtin)
(bound_prefix_op symbol: (_) @function.builtin)
(function_definition name: (identifier) @function)
(module_definition name: (identifier) @function)
(operator_definition name: (_) @operator)
(pcal_macro_decl name: (identifier) @function.macro)
(pcal_macro_call name: (identifier) @function.macro)
(pcal_proc_decl name: (identifier) @function.macro)
(pcal_process name: (identifier) @function)
(recursive_declaration (identifier) @operator)
(recursive_declaration (operator_declaration name: (_) @operator))

; Constants and variables
(constant_declaration (identifier) @constant.builtin)
(constant_declaration (operator_declaration name: (_) @constant.builtin))
(pcal_var_decl (identifier) @variable.builtin)
(pcal_with (identifier) @parameter)
((".") . (identifier) @attribute)
(record_literal (identifier) @attribute)
(set_of_records (identifier) @attribute)
(variable_declaration (identifier) @variable.builtin)

; Parameters
(quantifier_bound (identifier) @parameter)
(quantifier_bound (tuple_of_identifiers (identifier) @parameter))
(lambda (identifier) @parameter)
(module_definition (operator_declaration name: (_) @parameter))
(module_definition parameter: (identifier) @parameter)
(operator_definition (operator_declaration name: (_) @parameter))
(operator_definition parameter: (identifier) @parameter)
(pcal_macro_decl parameter: (identifier) @parameter)
(pcal_proc_var_decl (identifier) @parameter)

; Delimiters
[
  (langle_bracket)
  (rangle_bracket)
  (rangle_bracket_sub)
  "{"
  "}"
  "["
  "]"
  "]_"
  "("
  ")"
] @punctuation.bracket
[
  ","
  ":"
  "."
  "!"
  ";"
  (bullet_conj)
  (bullet_disj)
  (prev_func_val)
  (placeholder)
] @punctuation.delimiter

; Proofs
(proof_step_id "<" @punctuation.bracket)
(proof_step_id (level) @label)
(proof_step_id (name) @label)
(proof_step_id ">" @punctuation.bracket)
(proof_step_ref "<" @punctuation.bracket)
(proof_step_ref (level) @label)
(proof_step_ref (name) @label)
(proof_step_ref ">" @punctuation.bracket)

; Comments and tags
(block_comment "(*" @comment)
(block_comment "*)" @comment)
(block_comment_text) @comment
(comment) @comment
(single_line) @comment
(_ label: (identifier) @label)
(label name: (_) @label)
(pcal_goto statement: (identifier) @label)

; Reference highlighting with the same color as declarations.
; `constant`, `operator`, and others are custom captures defined in locals.scm
((identifier_ref) @constant.builtin (#is? @constant.builtin constant))
((identifier_ref) @operator (#is? @operator function))
((identifier_ref) @parameter (#is? @parameter parameter))
((identifier_ref) @variable.builtin (#is? @variable.builtin var))
