# in go error is an interface that defines the error() method

```go
type error interface {
    Error() string
}

// can be satisfied by any struct

struct networkProblem struct {
       message string
       code int
}

func (n networkProplem) Error() string {
    return fmt.Sprintf("Network error! message: %v, code: %v", n.message, n.code)
}

// now this can be used anywhere


func handleErr(err error) {
  fmt.Println(err.Error())
}

np := networkProblem{
  message: "we received a problem",
  code:    404,
}

handleErr(np)

// prints "network error! message: we received a problem, code: 404"

```
