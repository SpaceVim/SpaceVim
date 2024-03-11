(fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content)
    @content
    (#set-lang-from-info-string! @_lang)
    (#exclude_children! @content))

((html_block) @html @combined)

((minus_metadata) @yaml (#offset! @yaml 1 0 -1 0))
((plus_metadata) @toml (#offset! @toml 1 0 -1 0))

([
  (inline)
  (pipe_table_cell)
 ] @markdown_inline (#exclude_children! @markdown_inline))
