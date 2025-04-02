(module
  ;; get-stdout: func() -> output-stream;
  (import "wasi:cli/stdout@0.2.4" "get-stdout"
    (func $get-stdout (result i32)))

  ;; resource output-stream {
  ;;    blocking-write-and-flush: func(contents: list<u8>) -> result<_, stream-error>
  ;; }
  (import "wasi:io/streams@0.2.4" "[method]output-stream.blocking-write-and-flush"
    (func $blocking-write-and-flush
        (param $outputStream i32)
        (param $contentsPtr i32)
        (param $contentsLen i32)
        (param $retPtr i32)))

  (memory (export "memory") 1)

  ;; run: func() -> result<_, _>
  (func (export "wasi:cli/run@0.2.4#run") (result i32)

    ;; Write a list of bytes to stdout:
    (call $blocking-write-and-flush
        (call $get-stdout)
        (i32.const 100) ;; contents ptr
        (i32.const 15)  ;; contents len
        (i32.const 96)) ;; ret ptr
    ;; Return a pointer to location 0, which contains 0 for a result of ok
    (i32.const 0)
  )
  (data (i32.const 100) "Hello, world!\n")
)
