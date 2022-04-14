; References
(identifier) @reference
(alias) @reference

; Module Definitions
(call
  target: ((identifier) @_identifier (#eq? @_identifier "defmodule"))
  (arguments (alias) @definition.type))

; Pattern Match Definitions
(binary_operator left: [
  (identifier) @definition.var
  (_ (identifier) @definition.var)
  (_ (_ (identifier) @definition.var))
  (_ (_ (_ (identifier) @definition.var)))
  (_ (_ (_ (_ (identifier) @definition.var))))
  (_ (_ (_ (_ (_ (identifier) @definition.var)))))
  (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))
  (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))))
  (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))))
] operator: "=")

; Stab Clause Definitions
(stab_clause
  left: [
    (arguments [
      (identifier) @definition.var
      (_ (identifier) @definition.var)
      (_ (_ (identifier) @definition.var))
      (_ (_ (_ (identifier) @definition.var)))
      (_ (_ (_ (_ (identifier) @definition.var))))
      (_ (_ (_ (_ (_ (identifier) @definition.var)))))
      (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))
      (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))))
    ])
    (binary_operator
      left: (arguments [
        (identifier) @definition.var
        (_ (identifier) @definition.var)
        (_ (_ (identifier) @definition.var))
        (_ (_ (_ (identifier) @definition.var)))
        (_ (_ (_ (_ (identifier) @definition.var))))
        (_ (_ (_ (_ (_ (identifier) @definition.var)))))
        (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))
        (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var)))))))))))))))))))
        (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.var))))))))))))))))))))
  ]) operator: "when")
])

; Aliases
(call
  target: ((identifier) @_identifier (#any-of? @_identifier "require" "alias" "use" "import"))
  (arguments [
    (alias) @definition.import
    (_ (alias) @definition.import)
    (_ (_ (alias) @definition.import))
    (_ (_ (_ (alias) @definition.import)))
    (_ (_ (_ (_ (alias) @definition.import))))
  ]
))

; Local Function Definitions & Scopes
(call
  target: ((identifier) @_identifier (#any-of? @_identifier "def" "defp" "defmacro" "defmacrop" "defguard" "defguardp" "defn" "defnp" "for"))
  (arguments [
    (identifier) @definition.function
    (binary_operator left: (identifier) @definition.function operator: "when")
    (binary_operator (identifier) @definition.parameter)
    (call target: (identifier) @definition.function (arguments [
      (identifier) @definition.parameter
      (_ (identifier) @definition.parameter)
      (_ (_ (identifier) @definition.parameter))
      (_ (_ (_ (identifier) @definition.parameter)))
      (_ (_ (_ (_ (identifier) @definition.parameter))))
      (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))
      (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))
      (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))))))
    ]))
  ]?) (#set! definition.function.scope parent)
  (do_block)?
) @scope

; ExUnit Test Definitions & Scopes
(call
  target: ((identifier) @_identifier (#eq? @_identifier "test"))
  (arguments [
    (string)
    ((string) . "," . [
      (identifier) @definition.parameter
      (_ (identifier) @definition.parameter)
      (_ (_ (identifier) @definition.parameter))
      (_ (_ (_ (identifier) @definition.parameter)))
      (_ (_ (_ (_ (identifier) @definition.parameter))))
      (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))
      (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))
      (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter)))))))))))))))))))
      (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (_ (identifier) @definition.parameter))))))))))))))))))))
  ])
]) (do_block)?) @scope

; Stab Clause Scopes
(stab_clause) @scope
