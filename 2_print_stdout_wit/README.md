
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

## Hand-written module


wasm-tools component embed wit module.wat | wasm-tools component new > component.wasm

wasmtime run --invoke "run()" component.wasm
wasmtime run component.wasm
