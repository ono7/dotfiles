## dlv debugging

- use runtime.Breakpoint() in code to trigger a break with if statements or
other conditions

b main.go:30

- `display -a myVar` - displays the variable myVar everytime we step through the code, can add as many as needed
- `display` - shows all the display conditions by number

  ```
  (dlv) display
  0: p n = error 1:3: expected 'EOF', found n
  1: n = 1
  2: m.pos = error could not find symbol value for m
  ```

- `display -d 0` - removes the display condition `0: p n =`

## debugging in go

Use fmt.Printf("%#v\n", d) -> prints more detailed info about an object, with
structs shows key and values as well as types.

- output:
  `main.Words{Page:"words", Input:"", Words:[]string{"word1", "word2", "word2", "word2"}}`

```go
 // Struct
    p := Person{Name: "Alice", Age: 30}
    fmt.Printf("%#v\n", p)
    // Output: main.Person{Name:"Alice", Age:30}

    // Slice
    s := []int{1, 2, 3}
    fmt.Printf("%#v\n", s)
    // Output: []int{1, 2, 3}

    // Map
    m := map[string]int{"a": 1, "b": 2}
    fmt.Printf("%#v\n", m)
    // Output: map[string]int{"a":1, "b":2}

    // Pointer
    ptr := &p
    fmt.Printf("%#v\n", ptr)
    // Output: &main.Person{Name:"Alice", Age:30}
```
