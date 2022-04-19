; inherits: json

; Display errors
(ERROR) @error

; Comments
(comment) @comment

(request
  method: (method) @keyword
  url: (url) @text.uri)

(header
  name: (name) @constant
  value: (value))

; rest.nvim Neovim plugin specific features
(external_body
  json_file: (json_file) @text.uri) @keyword
