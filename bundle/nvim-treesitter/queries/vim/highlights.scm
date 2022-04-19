(identifier) @variable
((identifier) @constant
 (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

;; Keywords

[
  "if"
  "else"
  "elseif"
  "endif"
] @conditional

[
  "try"
  "catch"
  "finally"
  "endtry"
  "throw"
] @exception

[
  "for"
  "endfor"
  "in"
  "while"
  "endwhile"
] @repeat

[
  "function"
  "endfunction"
] @keyword.function

;; Function related
(function_declaration name: (_) @function)
(call_expression function: (identifier) @function)
(parameters (identifier) @parameter)
(default_parameter (identifier) @parameter)

[ (bang) (spread) (at) ] @punctuation.special

[ (no_option) (inv_option) (default_option) (option_name) ] @variable.builtin
[
  (scope)
  "a:"
  "$"
] @namespace

;; Commands and user defined commands

[
  "let"
  "unlet"
  "call"
  "execute"
  "normal"
  "set"
  "setlocal"
  "silent"
  "echo"
  "echomsg"
  "autocmd"
  "augroup"
  "return"
  "syntax"
  "lua"
  "ruby"
  "perl"
  "python"
  "highlight"
  "delcommand"
  "comclear"
  "colorscheme"
  "startinsert"
  "stopinsert"
  "global"
  "runtime"
  "wincmd"
] @keyword
(map_statement cmd: _ @keyword)
(command_name) @function.macro

;; Syntax command

(syntax_statement (keyword) @string)
(syntax_statement [
  "enable"
  "on"
  "off"
  "reset"
  "case"
  "spell"
  "foldlevel"
  "iskeyword"
  "keyword"
  "match"
  "cluster"
  "region"
] @keyword)

(syntax_argument name: _ @keyword)

[
  "<buffer>"
  "<nowait>"
  "<silent>"
  "<script>"
  "<expr>"
  "<unique>"
] @constant.builtin

(hl_attribute
  key: _ @property
  val: _ @constant)

(hl_group) @variable
(augroup_name) @namespace

(au_event) @constant
(normal_statement (commands) @constant)

;; Highlight command

(highlight_statement [
  "default"
  "link"
  "clear"
] @keyword)

;; Runtime command

(runtime_statement (where) @keyword.operator)

;; Colorscheme command

(colorscheme_statement (name) @string)

;; Literals

(string_literal) @string
(integer_literal) @number
(float_literal) @float
(comment) @comment
(pattern) @string.special
(pattern_multi) @string.regex
(filename) @string
((scoped_identifier
  (scope) @_scope . (identifier) @boolean)
 (#eq? @_scope "v:")
 (#any-of? @boolean "true" "false"))

;; Operators

[
  "||"
  "&&"
  "&"
  "+"
  "-"
  "*"
  "/"
  "%"
  ".."
  "is"
  "isnot"
  "=="
  "!="
  ">"
  ">="
  "<"
  "<="
  "=~"
  "!~"
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  ".="
] @operator

; Some characters have different meanings based on the context
(unary_operation "!" @operator)
(binary_operation "." @operator)

;; Punctuation

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

(field_expression "." @punctuation.delimiter)

[
  ","
  ":"
] @punctuation.delimiter

(ternary_expression ["?" ":"] @conditional)

; Options
((set_value) @number
 (#match? @number "^[0-9]+(\.[0-9]+)?$"))

((set_item
   option: (option_name) @_option
   value: (set_value) @function)
  (#any-of? @_option
    "tagfunc" "tfu"
    "completefunc" "cfu"
    "omnifunc" "ofu"
    "operatorfunc" "opfunc"))
