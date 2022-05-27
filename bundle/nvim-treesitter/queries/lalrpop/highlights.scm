[
 	"pub"
	"grammar"
	"match"
	"extern"
	"type"
	"enum"
] @keyword

[
 	"+"
	"*"
	"?"
] @operator

(grammar_type_params
	"<" @punctuation.bracket
	">" @punctuation.bracket)

(symbol
	"<" @punctuation.bracket
	">" @punctuation.bracket)

(binding_symbol
	"<" @punctuation.bracket
	">" @punctuation.bracket)

(binding_symbol
	name: (identifier) @parameter)

(bare_symbol
  (macro 
    ((macro_id) @function)))

(bare_symbol
  (identifier) @function)

(nonterminal_name
  (macro_id) @function)

(nonterminal_name
  (identifier) @function)

(nonterminal
  (type_ref) @type)

"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket

";" @punctuation.delimiter

(lifetime (identifier) @label)

(string_literal) @string
(regex_literal) @string
