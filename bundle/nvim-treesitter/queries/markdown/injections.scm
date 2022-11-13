(fenced_code_block
  (info_string
    (language) @language)
  (#not-match? @language "elm")
  (code_fence_content) @content (#exclude_children! @content))

((html_block) @html)

((minus_metadata) @yaml (#offset! @yaml 1 0 -1 0))
((plus_metadata) @toml (#offset! @toml 1 0 -1 0))

([
  (inline)
  (pipe_table_cell)
 ] @markdown_inline (#exclude_children! @markdown_inline))
