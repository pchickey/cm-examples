(module
  (import "wasi:cli/stdout@0.2.4" "get-stdout"
    (func $get-stdout (result i32)))
  (import "wasi:io/streams@0.2.4" "[method]output-stream.blocking-write-and-flush"
    (func $blocking-write-and-flush (param i32 i32 i32 i32)))
  (memory (export "memory") 1)
  (func (export "wasi:cli/run@0.2.4#run") (result i32)
    call $get-stdout
    i32.const 100
    i32.const 15
    i32.const 96
    call $blocking-write-and-flush
    i32.const 0
  )
  (data (i32.const 100) "Hello, world!\n")
)
