(module
  ;; This module uses linear memory. We need to export the memory,
  ;; and initialize it at 1 page in size.
  (memory (export "memory") 1)

  ;; We initialize memory with:
  ;; At location 0, a pointer to a string at location 0xf0.
  ;; At location 0xf0, a string which is 7 bytes long.
  (data (i32.const 0) "\f0\00\00\00")
  (data (i32.const 0xf0) "Hello, ")


  ;; `wasm-tools component new` aka wit-component will look for a function
  ;; with the special name `cabi_realloc` by convention. It will use this
  ;; function in the component's Canonical ABI options as the realloc for each
  ;; import and export function.
  ;;
  ;; The component runtime will call this realloc with the align and size of
  ;; each value it needs to write to this module's linear memory, and then
  ;; write the value at the pointer returned.
  ;;
  ;; Effectively, while having the expressivity of realloc, the Canonical
  ;; ABI will only use this function as a malloc: the first two arguments
  ;; will always be zero. Use as realloc is reserved for future use.
  (func (export "cabi_realloc")
        (param $origPtr i32)
        (param $origSize i32)
        (param $align i32)
        (param $newSize i32)
        (result i32)
        (local $ptr i32)

    ;; We know this module will only ever allocate a single string for use in
    ;; the hello function. We want to write the string right after the
    ;; "Hello, " we used to initialize memory.
    (i32.const 0xf7)
  )

  ;; We export a function that is mapped to a component export:
  ;; * example is the namespace
  ;; * first is the package name
  ;; * say is the interface name
  ;; * hello is the function name
  (func (export "example:first/say#hello")
        ;; The canonical ABI passes in the string as a pointer and length.
        ;; We are going to cheat and ignore these, because we know
        ;; cabi_realloc allocated 0xf7.
        (param $strPtr i32)
        (param $strLen i32)
        ;; To return a string, the Canonicab ABI requires we return a pointer
        ;; to memory where there is a pointer to the string contents, then 
        ;; the string's length.
        (result i32)

    ;; Store the length of the concatenated string at location 4.
    (i32.store (i32.const 4) (i32.add (local.get $strLen) (i32.const 7)))
    ;; Location 0 already contains 0xf0, where the string contents live.
    (i32.const 0)
  )
)
