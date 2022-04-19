; Scopes
[
(function_call)
(code_block)
(function_block)
(control_structure)
] @scope

; Definitions
(argument 
	name: (identifier) @definition.parameter
	(#set! "definition.var.scope" "local")
) 

(variable_definition 
	name: (variable (local_var (identifier) @definition.var
	)))

(variable_definition 
	name: (variable (environment_var (identifier) @definition.var))
	(#set! "definition.var.scope" "global"))

(function_definition name: (variable) @definition.var
	 (#set! "definition.var.scope" "parent")
)

(identifier) @reference
