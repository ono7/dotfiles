# interfaces vs typed functions

1. use interfaces to store state
2. typed functions are best for stateless implementations

```go
type foo interace{}

type fooImplementation struct {
    state string
}
```

## type assertions

`https://www.youtube.com/watch?v=pCA7oTBH4Zk`

```go

package main

import "fmt"

func main() {
	var a interface{} = 3
	// var a any = "Hello"  (we can use any here too)

	// b := a.(string) // cast value to a string

	if b, ok := a.(string); ok {
		fmt.Println(b)
	} else {
		fmt.Println("not ok", ok)
	}
}

```

### structs embedding

```go
package main

import (
	"fmt"
	"strings"
)

type Position struct {
	x, y int
}

type Entity struct {
	Position
	FirstName string
	LastName  string
	ID        int
}

func (e Entity) ToUpper() string {
	return strings.ToUpper(e.FirstName)
}

func main() {
	x := Entity{}
	x.FirstName = "jose"
	x.LastName = "jose"
	x.x = 20
	x.y = 30
	fmt.Printf("%+v\n", x)
	fmt.Printf("%+v\n", x.ToUpper())
}
```

### interfaces

```go

// decoupling dependencies using interfaces
package main

import (
	"fmt"
	"strings"
)

type stringFunc func(s string) string

func transFormString(s string, fn stringFunc) string {
	return fn(s)
}

func PrePostString(prefix string) stringFunc {
	return func(s string) string {
		return prefix + s
	}
}

func main() {
	fmt.Println(transFormString("hello there", strings.ToUpper))
	fmt.Println(transFormString("hello there", PrePostString("TEST_")))
}
```
