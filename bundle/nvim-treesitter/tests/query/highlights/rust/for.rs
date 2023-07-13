struct Foo;

// Issue https://github.com/nvim-treesitter/nvim-treesitter/issues/3641
// Distinguish between for in loop or impl_item
impl Drop for Foo {
    //     ^ @keyword
   fn drop(&mut self) {}
}

fn main() {
    for i in 0..128 {
    // <- @repeat
        println!("{i}");
    }
}
