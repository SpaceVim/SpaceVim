;; Pass code blocks to Cpp highlighter
(code (code_body) @cpp)

;; Pass identifiers to Go highlighter (Cheating I know)
;;((identifier) @lua)

;; Highlight regex syntax inside literal strings
((string_literal) @regex)

;; Highlight PyFoam syntax as Python statements
(pyfoam_variable code_body: (_) @python)
(pyfoam_expression code_body: (_) @python)
