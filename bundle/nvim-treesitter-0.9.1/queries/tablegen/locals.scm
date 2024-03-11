; Scopes

[
  (class)
  (multiclass)
  (def)
  (defm)
  (defset)
  (defvar)
  (foreach)
  (if)
  (let)
] @scope

; References

[
  (var)
  (identifier)
] @reference

; Definitions

(instruction
  (identifier) @definition.field)

(let_instruction
  (identifier) @definition.field)

(include_directive
  (string) @definition.import)

(template_arg (identifier) @definition.parameter)

(class
  name: (identifier) @definition.type)

(multiclass
  name: (identifier) @definition.type)

(def
  name: (value (_) @definition.type))

(defm
  name: (value (_) @definition.type))

(defset
  name: (identifier) @definition.type)

(def_var
  name: (identifier) @definition.var)
