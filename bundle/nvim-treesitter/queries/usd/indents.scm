[
  (block)  ; The {}s in `def "foo" { ... Attributes / Prims here ... }`
  (dictionary)  ; The {}s in `dictionary foo = { string "foo" = "bar" }`
  (list)
  (list_proxy)  ; [@foo.usda@, @bar.usda@]
  (metadata)  ; ( anything = "goes-here" )
  (prim_paths)  ; [</foo>, <../bar>]
  (timeSamples)  ; The {}s in `int value.timeSamples = { 0: 1, -10: 10, ... }`
  (tuple)
  (variant_set_definition)  ; The {}s in `variantSet "foo" = { "vr1" { ... } "vr2" { ... } }`
] @indent.begin

(block "}" @indent.end)
(dictionary "}" @indent.end)
(list "]" @indent.end)
(list_proxy "]" @indent.end)
(metadata ")" @indent.end)
(timeSamples "}" @indent.end)
(tuple ")" @indent.end)
(variant_set_definition "}" @indent.end)

[
  ")"
  "]"
  "}"
] @indent.branch
