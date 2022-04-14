(headline) @text.title
(column_heading) @text.title
(tag
   "*" @conceal (#set! conceal "")
   name: (_) @label)
(option
   "'" @conceal (#set! conceal "")
   name: (_) @text.literal)
(hotlink
   "|" @conceal (#set! conceal "")
   destination: (_) @text.uri)
(backtick
   "`" @conceal (#set! conceal "")
   content: (_) @string)
