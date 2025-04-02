
# Example 2: use WASI

WASI provides an operating system for the Component Model.

If we want to write "Hello, world" to the screen as a WASI program, we need
these imports:

* wasi-io provides the streams interface. output-stream is the resource for
  writing output. output-stream has set of methods for complex uses of streams with
  non-blocking writes and backpressure, as well as a method
  `blocking-write-and-flush: func(contents: list<u8>) -> result<_, stream-error>`,
  which simplifies use.

* wasi-cli provides facilities like stdout. We can get a fresh output-stream
  for the component's stdout by calling get-stdout().

We need to provide a single export:

* wasi-cli defines the command interface, which has a single function
  `run: func() -> result<_, _>`


## WASI's wits

I put wasi's wit files into `wit/`. The wasi-cli package is at the root. The
other wasi packages it depends on are in `wit/deps/`.

## Hand-written module

I wrote a `module.wat` that uses the above imports and exports.

As before, turn it into a component with:

```sh
wasm-tools component embed wit module.wat --world command | wasm-tools component new > component.wasm
```

The `--world command` argument is required because wasi-cli provides two
worlds: `command` and `imports`


## Running 

As before we can invoke the run function with wasmtime:
```sh
wasmtime run --invoke "run()" component.wasm
```

When you're providing a wasi-cli command, `wasmtime run` will execute it
without needing invoke. The only difference is it will treat the `result<_,_>`
as the CLI's return code (0 or 1) instead of printing it.
```sh
wasmtime run component.wasm
```

## Using Rust to target WASI

Rust supports compiling components directly for WASI 0.2.

In the subdir `rust`, we have a trivial Rust project: it was created with
`cargo init --bin .`.

Build it with `cargo build --target wasm32-wasip2`. This will produce a
component at `target/wasm32-wasip2/debug/rust.wasm`. You can `wasmtime run`
it.

We can even make `cargo run` and `cargo test` automatically run the executable
and tests under wasmtime. Create a `.cargo` directory and create the file
`.cargo/config.toml` containing:

```toml
[build]
target = "wasm32-wasip2"
[target.wasm32-wasip2]
runner = "wasmtime run"
```

Now cargo will automatically build for WASIp2, and run with wasmtime:

```sh
% cargo run
   Compiling rust v0.1.0 (/Users/p.hickey/src/component-examples/2_print_stdout_wit/rust)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.47s
     Running `wasmtime run target/wasm32-wasip2/debug/rust.wasm`
Hello, world!
```

