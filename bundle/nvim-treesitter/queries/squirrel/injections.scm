(comment) @comment

((verbatim_string) @html
  (#lua-match? @html "^@\"<html")
  (#offset! @html 0 2 0 -1))

((verbatim_string) @html
  (#lua-match? @html "@\"<!DOCTYPE html>")
  (#offset! @html 0 2 0 -1))
