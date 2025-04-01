// Bindings generator creates a mod `exports` for the default world.
wit_bindgen::generate!({ path: "../wit" });

// Define some library code
struct S;
// And connect that library code to the single set of exports from this bin
export!(S);

// Implement the requirements for the exports
impl exports::example::hello::say::Guest for S {
    fn hello(name: String) -> String {
        format!("Hello, {name}")
    }
}

// Ignore this, its so that `cargo build --target wasm32-wasip2` works without any messing around.
// This will hopefully one day not be needed.
fn main() {}
