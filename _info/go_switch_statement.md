```go
switch [value] {
  case [match]:
     [statement]
  case [match],[match]:
      [statement]
  default:
     [statement]
}

switch x {
  case 5:
    fmt.Prinln("x is 5")
  case 6, 7:
    fmt.Prinln("x is 6 or 7n")
  default:
    fmt.Println("other number")
}
```
