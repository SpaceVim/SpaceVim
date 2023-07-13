(source_file) @scope
(source_file (array) @scope)
(source_file (map) @scope)
(source_file (struct) @scope)
(source_file (tuple) @scope)

(identifier) @reference

(struct_entry (identifier) @definition.field)
(struct_entry (identifier) @definition.enum (enum_variant))

(struct (struct_name) @definition.type)
