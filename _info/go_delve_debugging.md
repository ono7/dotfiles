# notes

## debugging with --headless if input is required (stdin)

`dlv --headless debug yourprogram.go`

or

`dlv --headless debug .`

This will print something like this:

API server listening at: 127.0.0.1:XYZ
then in another terminal do:

`dlv connect localhost:XYZ`

on the first terminal we can input commands to stdin, on the second one we can debug!

## Debug when a function or method is called on a struct

// this is probably the most useful way to debug and set breakpoints
// this is case sensitive

// bash: dlv debug main.go
(dlv)>break main.MySlowReader.Read
(dlv)> c

## print code

// list code centered around line 20
list 20

// reference a file and line number if we know what file we want to break on
list main.go:10

## conditional break points

// Break only when specific conditions met
dlv debug
(dlv) break main.go:14
(dlv) condition 1 m.pos == 5
(dlv) continue

## watch

watch variable for changes

```bash
# Break when variable changes
(dlv) break main.MySlowReader.Read
(dlv) continue # this will pause at Read() call
(dlv) watch -w m.pos  # Not all platforms support this, this will pause when m.pos changes -r, -w -rw flags
# Alternative: manual checking
(dlv) break main.go:14
(dlv) condition 1 m.pos != m.pos@entry  # pseudocode
```

## keyboard shortcuts

- ctrl-r works to search for old commands
- install: `go install github.com/go-delve/delve/cmd/dlv@latest`

# video reference

`https://www.youtube.com/watch?v=qFf2PRSfBlQ&t`

# execute in debugger

`dlv exec ./main`

## set break point on function/method

Set breakpoints and execute expressions when we hit them

```go
break Rectangle.Area
// execute code when hitting breakpoints

on 1 print a // when breakpoint 1 hits, print the a variable
on 1 -edit // allows for easier editing using editor
```

source debugger instructions from source file

```go
// debug_config.txt
// break main.go:28
// on main.print a
// break main.go:37

source debug_config.txt

```

## clear breakpoints

- clear 1 - clears breakpoint 1
- clearall - clears all breakpoints

```go
// finds this method and sets a breakpoint
func (r *Rectangle) Area() {}

```
