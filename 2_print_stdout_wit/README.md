wasm-tools component embed wit module.wat | wasm-tools component new > component.wasm

wasmtime run --invoke "run()" component.wasm
wasmtime run component.wasm
