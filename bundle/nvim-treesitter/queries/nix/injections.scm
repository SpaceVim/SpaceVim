(comment) @comment

(apply_expression
  function: (_) @_func
  argument: [
    (string_expression (string_fragment) @regex)
    (indented_string_expression (string_fragment) @regex)
  ]
  (#match? @_func "(^|\\.)match$"))
  @combined

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @bash)
    (indented_string_expression (string_fragment) @bash)
  ]
  (#match? @_path "(^\\w+(Phase|Hook)|(pre|post)[A-Z]\\w+|script)$"))

(apply_expression
  function: (_) @_func
  argument: (_ (_)* (_ (_)* (binding
    attrpath: (attrpath (identifier) @_path)
    expression: [
      (string_expression (string_fragment) @bash)
      (indented_string_expression (string_fragment) @bash)
    ])))
  (#match? @_func "(^|\\.)writeShellApplication$")
  (#match? @_path "^text$"))
  @combined

(apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @bash)
    (indented_string_expression (string_fragment) @bash)
  ]
  (#match? @_func "(^|\\.)runCommand((No)?CC)?(Local)?$"))
  @combined

((apply_expression
  function: (apply_expression function: (_) @_func)
  argument: [
    (string_expression (string_fragment) @bash)
    (indented_string_expression (string_fragment) @bash)
  ])
  (#match? @_func "(^|\\.)write(Bash|Dash|ShellScript)(Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression function: (_) @_func)
  argument: [
    (string_expression (string_fragment) @fish)
    (indented_string_expression (string_fragment) @fish)
  ])
  (#match? @_func "(^|\\.)writeFish(Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @haskell)
    (indented_string_expression (string_fragment) @haskell)
  ])
  (#match? @_func "(^|\\.)writeHaskell(Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @javascript)
    (indented_string_expression (string_fragment) @javascript)
  ])
  (#match? @_func "(^|\\.)writeJS(Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @perl)
    (indented_string_expression (string_fragment) @perl)
  ])
  (#match? @_func "(^|\\.)writePerl(Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @python)
    (indented_string_expression (string_fragment) @python)
  ])
  (#match? @_func "(^|\\.)write(PyPy|Python)[23](Bin)?$"))
  @combined

((apply_expression
  function: (apply_expression
    function: (apply_expression function: (_) @_func))
  argument: [
    (string_expression (string_fragment) @rust)
    (indented_string_expression (string_fragment) @rust)
  ])
  (#match? @_func "(^|\\.)writeRust(Bin)?$"))
  @combined
