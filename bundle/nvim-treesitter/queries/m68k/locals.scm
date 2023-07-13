(macro_definition
  name: (symbol) @definition.macro)

(symbol_assignment
  name: (symbol) @definition.var)

(label
  name: (symbol) @definition.constant)
(symbol_definition
  name: (symbol) @definition.constant)
(offset_definition
  name: (symbol) @definition.constant)
(register_definition
  name: (symbol) @definition.constant)
(register_list_definition
  name: (symbol) @definition.constant)

(external_reference
  symbols: (symbol_list
    (symbol) @definition.import))

(symbol) @reference
