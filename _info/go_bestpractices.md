## early returns

```go
func (w *binWrtire) Write(v interface{}) {
  if w.err != nil {
    return // early return
  }
  // .... do something
}
```

## Switch

```go
func (w *binWrtire) Write(v interface{}) {
  if w.err != nil {
    return // early return
  }
  switch v.(type) { // do something based on the type of data
    case string:
      s := v.(string)
      w.Write(int32(len(s)))
      w.Write([]byte(s))
    case int:
      i := v.(int)
      w.Write(int64(i))
    default:
  }
}
```
