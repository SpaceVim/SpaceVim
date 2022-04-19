;; Fusion base
(block) @scope

(namespace_declaration
  (alias_namespace) @definition.namespace)

(property
  (path (path_part) @definition.field))

(type
  namespace: (package_name)? @definition.namespace
  name: (type_name) @definition.type
)

;; Eel Expressions
(eel_arrow_function) @scope
(eel_object) @scope

(eel_parameter) @definition.parameter
(eel_object_pair
  key: (eel_property_name) @definition.field)
