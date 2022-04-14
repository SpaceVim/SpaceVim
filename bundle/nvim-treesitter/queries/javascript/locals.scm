; inherits: ecma,jsx

(formal_parameters
  (identifier) @definition.parameter)

; function(arg = []) {
(formal_parameters
  (assignment_pattern
    left: (identifier) @definition.parameter))

; x => x
(arrow_function
  parameter: (identifier) @definition.parameter)

;; ({ a }) => null
(formal_parameters
  (object_pattern
    (shorthand_property_identifier_pattern) @definition.parameter))

;; ({ a: b }) => null
(formal_parameters
  (object_pattern
    (pair_pattern
      value: (identifier) @definition.parameter)))

;; ([ a ]) => null
(formal_parameters
  (array_pattern
    (identifier) @definition.parameter))

(formal_parameters
  (rest_pattern
    (identifier) @definition.parameter))
