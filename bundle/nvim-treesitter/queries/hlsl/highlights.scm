; inherits: cpp

[
  "in"
  "out"
  "inout"
  "uniform"
  "shared"
  "groupshared"
  "discard"
  "cbuffer"
  "row_major"
  "column_major"
  "globallycoherent"
  "centroid"
  "noperspective"
  "nointerpolation"
  "sample"
  "linear"
  "snorm"
  "unorm"
  "point"
  "line"
  "triangleadj"
  "lineadj"
  "triangle"
] @keyword

(
  (identifier) @variable.builtin
  (#lua-match? @variable.builtin "^SV_")
)

(hlsl_attribute) @attribute
(hlsl_attribute ["[" "]"] @attribute)
