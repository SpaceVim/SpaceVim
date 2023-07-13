;; -----------------------------------------------------------------------------
;; General language injection

(quasiquote
 ((quoter) @language)
 ((quasiquote_body) @content)
)

(comment) @comment

;; -----------------------------------------------------------------------------
;; shakespeare library
;; NOTE: doesn't support templating

; TODO: add once CoffeeScript parser is added
; ; CoffeeScript: Text.Coffee
; (quasiquote
;  (quoter) @_name
;  (#eq? @_name "coffee")
;  ((quasiquote_body) @coffeescript)

; CSS: Text.Cassius, Text.Lucius
(quasiquote
 (quoter) @_name
 (#any-of? @_name "cassius" "lucius")
 ((quasiquote_body) @css)
)

; HTML: Text.Hamlet
(quasiquote
 (quoter) @_name
 (#any-of? @_name "shamlet" "xshamlet" "hamlet" "xhamlet" "ihamlet")
 ((quasiquote_body) @html)
)

; JS: Text.Julius
(quasiquote
 (quoter) @_name
 (#any-of? @_name "js" "julius")
 ((quasiquote_body) @javascript)
)

; TS: Text.TypeScript
(quasiquote
 (quoter) @_name
 (#any-of? @_name "tsc" "tscJSX")
 ((quasiquote_body) @typescript)
)


;; -----------------------------------------------------------------------------
;; HSX

(quasiquote
 (quoter) @_name
 (#eq? @_name "hsx")
 ((quasiquote_body) @html)
)

;; -----------------------------------------------------------------------------
;; Inline JSON from aeson

(quasiquote
  (quoter) @_name
  (#eq? @_name "aesonQQ")
  ((quasiquote_body) @json)
)


;; -----------------------------------------------------------------------------
;; SQL

; postgresql-simple
(quasiquote
  (quoter) @_name 
  (#eq? @_name "sql")
  ((quasiquote_body) @sql)
)
