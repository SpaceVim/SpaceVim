; Scopes

[
  (source_file)
  (field)
  (for_clause)
] @scope

; References

(identifier) @reference

; Definitions

(import_spec
  path: (string) @definition.import)

(field
  (label
  (identifier) @definition.field))

(package_identifier) @definition.namespace

(for_clause
  (identifier) @definition.variable
  (expression))

(for_clause
  (identifier)
  (identifier) @definition.variable
  (expression))

(let_clause
  (identifier) @definition.variable)
