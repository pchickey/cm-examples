wit_bindgen::generate!({ path: "../wit" });

export!(S);

struct S;

impl exports::example::hello::say::Guest for S {
    fn hello(name: String) -> String {
        format!("Hello, {name}")
    }
}

fn main() {}
