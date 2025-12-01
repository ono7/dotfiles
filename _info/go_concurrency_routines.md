## go concurrency

`maps` maps are NOT thread safe and should be locked for access when using go routines

```go
type value struct {
  // assign the mutex to the data structure hosting the
  mu sync.Mutex
  value int
}
```
