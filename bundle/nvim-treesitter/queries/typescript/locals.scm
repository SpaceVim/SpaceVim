; inherits: ecma
(required_parameter (identifier) @definition)
(optional_parameter (identifier) @definition)

; x => x
(arrow_function
  parameter: (identifier) @definition.parameter)

;; ({ a }) => null
(required_parameter
  (object_pattern
    (shorthand_property_identifier_pattern) @definition.parameter))

;; ({ a: b }) => null
(required_parameter
  (object_pattern
    (pair_pattern
      value: (identifier) @definition.parameter)))

;; ([ a ]) => null
(required_parameter
  (array_pattern
    (identifier) @definition.parameter))

(required_parameter
  (rest_pattern
    (identifier) @definition.parameter))
