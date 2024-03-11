(comment) @comment

(heredoc_body
 (heredoc_content) @content
 (heredoc_end) @language
 (#set! "language" @language)
 (#downcase! "language"))

(regex (string_content) @regex)
