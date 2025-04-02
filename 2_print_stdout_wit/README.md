
# Example 2: use WASI

WASI provides an operating system for the Component Model.

## Hand-written module

wasm-tools component embed wit module.wat | wasm-tools component new > component.wasm

wasmtime run --invoke "run()" component.wasm
wasmtime run component.wasm
