wasm-tools component embed wit hello-module.wat | wasm-tools component new > hello-component.wasm

wasmtime run hello-component.wasm

wasmtime run --invoke "run()" hello-component.wasm
