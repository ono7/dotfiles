# debugging with LLDB in macos

- set breakpoints on a file on a line
  `(lldb) breakpoint set -f pointers.c --line 7`
- set break point to a function
  b main

## inspect variables

- `frame variable (list of variables space separated)`

```sh

Target 0: (pointers) stopped.
(lldb) frame variable contestants *choice
(int[3]) contestants = ([0] = 2, [1] = 3, [2] = 3)
(int) *choice = 2
(lldb)

```

## view source code

- print current line
  `frame select`

- Print the current file name, line number, and active call stack without listing code.
  `(lldb) frame info`

- print the source code for the main function

```

(lldb) frame info
frame #0: 0x00000001000004f8 pointers`main at pointers.c:7:20

# NOTE(jlima): Print source lines centered around the current execution pointer (->).
(lldb) source list
(lldb) l

# NOTE(jlima): List a specific line range in the current file (e.g., lines 1 through 15).
(lldb) source list --line 1 --count 15
(lldb) l 1

# NOTE(jlima): List the source for a specific function by name.
(lldb) source list --name main
(lldb) l main

# NOTE(jlima): Print the current file name, line number, and active call stack without listing code.
(lldb) frame info
```
