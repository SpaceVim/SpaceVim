;; reference https://github.com/vlang/vls
;; rev: c3e9874fa6c3b38beaa50d53aff4967403e251a4

;; Identifiers -------------------
(import_path) @namespace
(module_identifier) @variable.builtin
(identifier) @variable
(interpreted_string_literal) @string
(string_interpolation) @none

; TODO: Have differnt highlight to make then standout + highlight }{$ as special
; ((string_interpolation
;   (identifier) @constant
;   "$" @punctuation.special
;   "${" @punctuation.special
;   "}" @punctuation.special))

[(type_identifier) (array_type) (pointer_type)] @type

(field_identifier) @property

(builtin_type) @type.builtin

(parameter_declaration
  name: (identifier) @parameter)

(const_spec
  name: (identifier) @constant)

((((selector_expression field: (identifier) @property)) @_parent
  (#not-has-parent? @_parent call_expression special_call_expression)))

((identifier) @variable.builtin
 (#match? @variable.builtin "^(err|macos|linux|windows)$"))

(attribute_declaration) @attribute
;; C: TODO: fixme make `C`.exten highlighted as variable.builtin
; ((binded_identifier) @content
;  (#offset! @content 0 3 0 -1)
;  (#match? @content "^C$"))

;; Function calls ----------------
(call_expression
  function: (identifier) @function.call)

(((_
   function: (selector_expression field: (identifier) @function.call)
   arguments: (_) @_args)
  (#not-has-type? @_args arguments_list)))

((call_expression
  function: (binded_identifier name: (identifier) @function)
  @function.call))


;; Function definitions ---------
(function_declaration
  name: (identifier) @function)

(function_declaration
  receiver: (parameter_list)
  name: (identifier) @method)

((function_declaration
  (binded_identifier name: (identifier) @function)
  @function))

;; Keywords

[
  "import"
  "module"
] @include

[
  "match"
  "if"
  "$if"
  "else"
  "$else"
] @conditional

[
  "for" @repeat
  "$for"
] @repeat

[
 "as"
 "in"
 "!in"
 "or"
 "is"
 "!is"
] @keyword.operator

[
 "asm"
 "assert"
 "const"
 "defer"
 "enum"
 "go"
 "goto"
 "interface"
 "lock"
 "mut"
 "pub"
 "rlock"
 "struct"
 "type"
 "unsafe"
]
 ;; Either not supported or will be dropped
 ;"atomic"
 ;"break"
 ; "continue"
 ;"shared"
 ;"static"
 ;"union"
@keyword

"fn" @keyword.function
"return" @keyword.return

; "import" @include ;; note: comment out b/c of import_path @namespace

[ (true) (false) ] @boolean



;; Conditionals ----------------
[ "else" "if"] @conditional

;; Operators ----------------
[ "." "," ":" ";"] @punctuation.delimiter

[ "(" ")" "{" "}" "[" "]"] @punctuation.bracket

(array) @punctuation.bracket

[
 "++"
 "--"

 "+"
 "-"
 "*"
 "/"
 "%"

 "~"
 "&"
 "|"
 "^"

 "!"
 "&&"
 "||"
 "!="

 "<<"
 ">>"

 "<"
 ">"
 "<="
 ">="

 "+="
 "-="
 "*="
 "/="
 "&="
 "|="
 "^="
 "<<="
 ">>="

 "="
 ":="
 "=="

 "?"
 "<-"
 "$"
 ".."
 "..."]
@operator

;; Builtin Functions, maybe redundant with (builtin_type)
((identifier) @function.builtin
 (#any-of? @function.builtin
    "eprint"
    "eprintln"
    "error"
    "exit"
    "panic"
    "print"
    "println"
    "after"
    "after_char"
    "all"
    "all_after"
    "all_after_last"
    "all_before"
    "all_before_last"
    "any"
    "ascii_str"
    "before"
    "bool"
    "byte"
    "byterune"
    "bytes"
    "bytestr"
    "c_error_number_str"
    "capitalize"
    "clear"
    "clone"
    "clone_to_depth"
    "close"
    "code"
    "compare"
    "compare_strings"
    "contains"
    "contains_any"
    "contains_any_substr"
    "copy"
    "count"
    "cstring_to_vstring"
    "delete"
    "delete_last"
    "delete_many"
    "ends_with"
    "eprint"
    "eprintln"
    "eq_epsilon"
    "error"
    "error_with_code"
    "exit"
    "f32"
    "f32_abs"
    "f32_max"
    "f32_min"
    "f64"
    "f64_max"
    "fields"
    "filter"
    "find_between"
    "first"
    "flush_stderr"
    "flush_stdout"
    "free"
    "gc_check_leaks"
    "get_str_intp_u32_format"
    "get_str_intp_u64_format"
    "grow_cap"
    "grow_len"
    "hash"
    "hex"
    "hex2"
    "hex_full"
    "i16"
    "i64"
    "i8"
    "index"
    "index_after"
    "index_any"
    "index_byte"
    "insert"
    "int"
    "is_alnum"
    "is_bin_digit"
    "is_capital"
    "is_digit"
    "is_hex_digit"
    "is_letter"
    "is_lower"
    "is_oct_digit"
    "is_space"
    "is_title"
    "is_upper"
    "isnil"
    "join"
    "join_lines"
    "keys"
    "last"
    "last_index"
    "last_index_byte"
    "length_in_bytes"
    "limit"
    "malloc"
    "malloc_noscan"
    "map"
    "match_glob"
    "memdup"
    "memdup_noscan"
    "move"
    "msg"
    "panic"
    "panic_error_number"
    "panic_lasterr"
    "panic_optional_not_set"
    "parse_int"
    "parse_uint"
    "pointers"
    "pop"
    "prepend"
    "print"
    "print_backtrace"
    "println"
    "proc_pidpath"
    "ptr_str"
    "push_many"
    "realloc_data"
    "reduce"
    "repeat"
    "repeat_to_depth"
    "replace"
    "replace_each"
    "replace_once"
    "reverse"
    "reverse_in_place"
    "runes"
    "sort"
    "sort_by_len"
    "sort_ignore_case"
    "sort_with_compare"
    "split"
    "split_any"
    "split_into_lines"
    "split_nth"
    "starts_with"
    "starts_with_capital"
    "str"
    "str_escaped"
    "str_intp"
    "str_intp_g32"
    "str_intp_g64"
    "str_intp_rune"
    "str_intp_sq"
    "str_intp_sub"
    "strg"
    "string_from_wide"
    "string_from_wide2"
    "strip_margin"
    "strip_margin_custom"
    "strlong"
    "strsci"
    "substr"
    "substr_ni"
    "substr_with_check"
    "title"
    "to_lower"
    "to_upper"
    "to_wide"
    "tos"
    "tos2"
    "tos3"
    "tos4"
    "tos5"
    "tos_clone"
    "trim"
    "trim_left"
    "trim_pr"
    "try_pop"
    "try_push"
    "utf32_decode_to_buffer"
    "utf32_to_str"
    "utf32_to_str_no_malloc"
    "utf8_char_len"
    "utf8_getchar"
    "utf8_str_len"
    "utf8_str_visible_length"
    "utf8_to_utf32"
    "v_realloc"
    "vbytes"
    "vcalloc"
    "vcalloc_noscan"
    "vmemcmp"
    "vmemcpy"
    "vmemmove"
    "vmemset"
    "vstring"
    "vstring_literal"
    "vstring_literal_with_len"
    "vstring_with_len"
    "vstrlen"
    "vstrlen_char"
    "winapi_lasterr_str"))


;; Literals

(int_literal) @number

(rune_literal) @string

(escape_sequence) @string.escape

(float_literal) @float

[(true) (false)] @boolean

(ERROR) @error

(comment) @comment

