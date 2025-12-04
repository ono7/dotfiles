# go json marshal

examples of converting json to go structs

```go

package main

import (
  "encoding/json"
)

func marshalAll[T any](items []T) ([][]byte, error) {
  var dataSlice [][]byte
  for _, item := range items {
    if m, err := json.Marshal(item); err != nil {
      return [][]byte{}, err
    } else {
      dataSlice = append(dataSlice, m)
    }
  }
  return dataSlice, nil
}

```
