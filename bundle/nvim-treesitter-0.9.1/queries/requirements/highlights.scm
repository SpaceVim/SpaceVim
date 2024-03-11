;; packages

(package) @variable

(extras (package) @parameter)

(path) @text.underline @string.special

(url) @text.uri

;; versions

(version_cmp) @operator

(version) @number

;; markers

(marker_var) @attribute

(marker_op) @keyword.operator

;; options

(option) @function

"=" @operator

;; punctuation

[ "[" "]" "(" ")" ] @punctuation.bracket

[ "," ";" "@" ] @punctuation.delimiter

[ "${" "}" ] @punctuation.special

;; misc

(env_var) @constant

(quoted_string) @string

(linebreak) @character.special

(ERROR) @error

(comment) @comment @spell
