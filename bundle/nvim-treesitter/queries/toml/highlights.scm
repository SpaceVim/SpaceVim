; Properties
;-----------

(bare_key) @property
(quoted_key) @string

; Literals
;---------

(boolean) @boolean
(comment) @comment
(string) @string
(integer) @number
(float) @float
(offset_date_time) @string.special
(local_date_time) @string.special
(local_date) @string.special
(local_time) @string.special

; Punctuation
;------------

"." @punctuation.delimiter
"," @punctuation.delimiter

"=" @operator

"[" @punctuation.bracket
"]" @punctuation.bracket
"[[" @punctuation.bracket
"]]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

(ERROR) @error
