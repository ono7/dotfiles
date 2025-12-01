safer pattern to implement enums in go

```go
type Perm string

const (
  Read  Perm = "read"
  Write Perm = "write"
  Exec  Perm = "execute"
)
// tecnically Perm("fakestuff") would allow this to still be true, the compiler would accept this as valid.

func (p Perm) IsValid() bool {
  switch p {
  case Read, Write, Exec:
    return true
  default:
    return false
  }
}

func checkPermission(p Perm) error {
  if !p.IsValid() {
    return fmt.Errorf("invalid permission: %q", p)
  }
  // safe to use p here
  return nil
}

```

## kind of a enum, but not really, just a sequence of numbers

```go
type emailStatus int

const (
  emailBounced emailStatus = iota
  emailInvalid
  emailDelivered
  emailOpened
)

```
