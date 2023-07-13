(comment) @comment

(heredoc_template
  (template_literal) @content
  (heredoc_identifier) @language
  (#set! "language" @language)
  (#downcase! "language"))
