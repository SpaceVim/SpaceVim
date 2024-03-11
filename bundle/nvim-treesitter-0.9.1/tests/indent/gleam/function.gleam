import gleam/io

pub fn main() {
  io.println("Hello from main!")
}

fn hidden() {
  io.println("Hello from hidden!")
}

pub external fn inspect(a) -> a = 
  "Elixir.IO" "inspect"

external fn inspect(a) -> a = 
  "Elixir.IO" "inspect"
