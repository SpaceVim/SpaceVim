struct Vertex {
  @location(0) position: vec3<f32>,
  @location(1) color: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
  var out: VertexOutput;
  out.a = 1;
  if (1) {
    out.a = 3;
  }
  if (2) {
    dsa;
  }

  loop {
    if (i >= 4) { break; }
  }
  out.b = 2;
  return out;
}

@vertex
fn vertex(vertex: Vertex,
  foo: dso,
  foo: dsa
) -> VertexOutput {
  var out: VertexOutput;
  out.a = 1;
  out.b = 2;
  return out;
}

@vertex
fn vertex(vertex: Vertex,
  foo: dso,
  foo: dsa) -> VertexOutput {
  var out: VertexOutput;
  out.a = 1;
  out.b = 2;
  return out;
}
