(module

  (memory (export "memory") 1)

  (func (export "example:hello/say#hello") (param i32 i32) (result i32)
    ;; String pointer is stored at 0
    i32.const 0
  )

  (func (export "cabi_realloc")
        (param $origPtr i32)
        (param $origSize i32)
        (param $align i32)
        (param $newSize i32)
        (result i32)
        (local $ptr i32)

    ;; store the new strlen at 4
    i32.const 4
    local.get $newSize
    i32.const 7
    i32.add
    i32.store

    ;; Return pointer to write the string at
    i32.const 0xf7
  )

  (data (i32.const 0) "\f0\00\00\00")
  (data (i32.const 0xf0) "Hello, ")
)
