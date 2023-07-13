(comment) @comment

; test(val)
(query
  ((funcname) @_function
   (#any-of? @_function
             "test"
             "match"
             "capture"
             "scan"
             "split"
             "splits"
             "sub"
             "gsub"))
  (args . (query (string) @regex)))


; test(regex; flags)
(query
  ((funcname) @_function
   (#any-of? @_function
             "test"
             "match"
             "capture"
             "scan"
             "split"
             "splits"
             "sub"
             "gsub"))
  (args . (args
    (query (string) @regex))))
