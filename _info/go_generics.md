```go
// T is the functions generic variable, in this case
// it is only used to specify the input type and return types
// for the slices
func splitAnySlice[T any](s []T) ([]T, []T) {
    mid := len(s)/2
    return s[:mid], s[mid:]
}

// Generic type with constraints
type stringer interface {
    String() string
}

func concat[T stringer](vals []T) string {
    result := ""
    for _, val := range vals {
        // this is where the .String() method
        // is used. That's why we need a more specific
        // constraint instead of the any constraint
        result += val.String()
    }
    return result
}
```

```go
// interface definitions can also accept type constraints

// The store interface represents a store that sells products.
// It takes a type parameter P that represents the type of products the store sells.
type store[P product] interface {
  Sell(P)
}

type product interface {
  Price() float64
  Name() string
}

type book struct {
  title  string
  author string
  price  float64
}

func (b book) Price() float64 {
  return b.price
}

func (b book) Name() string {
  return fmt.Sprintf("%s by %s", b.title, b.author)
}

type toy struct {
  name  string
  price float64
}

func (t toy) Price() float64 {
  return t.price
}

func (t toy) Name() string {
  return t.name
}

// The bookStore struct represents a store that sells books.
type bookStore struct {
  booksSold []book
}

// Sell adds a book to the bookStore's inventory.
func (bs *bookStore) Sell(b book) {
  bs.booksSold = append(bs.booksSold, b)
}

// The toyStore struct represents a store that sells toys.
type toyStore struct {
  toysSold []toy
}

// Sell adds a toy to the toyStore's inventory.
func (ts *toyStore) Sell(t toy) {
  ts.toysSold = append(ts.toysSold, t)
}

// sellProducts takes a store and a slice of products and sells
// each product one by one.
func sellProducts[P product](s store[P], products []P) {
  for _, p := range products {
    s.Sell(p)
  }
}

func main() {
  bs := bookStore{
    booksSold: []book{},
  }

    // By passing in "book" as a type parameter, we can use the sellProducts function to sell books in a bookStore
  sellProducts[book](&bs, []book{
    {
      title:  "The Hobbit",
      author: "J.R.R. Tolkien",
      price:  10.0,
    },
    {
      title:  "The Lord of the Rings",
      author: "J.R.R. Tolkien",
      price:  20.0,
    },
  })
  fmt.Println(bs.booksSold)

    // We can then do the same for toys
  ts := toyStore{
    toysSold: []toy{},
  }
  sellProducts[toy](&ts, []toy{
    {
      name:  "Lego",
      price: 10.0,
    },
    {
      name:  "Barbie",
      price: 20.0,
    },
  })
  fmt.Println(ts.toysSold)
}

```
