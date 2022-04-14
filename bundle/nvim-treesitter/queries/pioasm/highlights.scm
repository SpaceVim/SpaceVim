[ (line_comment) (block_comment) ] @comment

(label_decl) @label

(string) @string

(instruction
  opcode: _ @keyword)

[ "pins" "x" "y" "null" "isr" "osr" "status" "pc" "exec" ] @variable.builtin

(out_target "pindirs" @variable.builtin)
(directive "pindirs" @keyword)

(condition [ "--" "!=" ] @operator)
(expression [ "+" "-" "*" "/" "|" "&" "^" "::" ] @operator)
(not) @operator

[ "optional" "opt" "side" "sideset" "side_set" "pin" "gpio" "osre" ] @keyword
[ "block" "noblock" "iffull" "ifempty" "rel" ] @keyword
(irq_modifiers) @keyword

(integer) @number

(directive (identifier) @variable)
(directive (symbol_def (identifier) @variable))
(value (identifier) @variable)

(directive
  directive: _ @keyword)
