# working with json data

decoder.Decode is more memory efficient, use for large amounts of data
use json.Unmarshal for small data in memory

```go

type Issue struct {
    Id       string `json:"id"`
    Title    string `json:"title"`
    Estimate int    `json:"estimate"`
}

func decodeJSONResponse(res *http.Response) ([]Issue, error) {
    var issues []Issue
    decoder := json.NewDecoder(res.Body)
    if err := decoder.Decode(&issues); err != nil {
        return nil, err
    }
    return issues, nil
}

```

```go
// res is an http.Response
defer res.Body.Close()

data, err := io.ReadAll(res.Body)
if err != nil {
  return nil, err
}

var issues []Issue
if err := json.Unmarshal(data, &issues); err != nil {
    return nil, err
}

```

`json.Decoder is more memory efficient then json.Unmarshall`

The Decode method of json.Decoder streams data from an io.Reader into a Go struct, while json.Unmarshal works with
data that's already in []byte format. Using a json.Decoder can be more memory-efficient because it doesn't load all
the data into memory at once. json.Unmarshal is ideal for small JSON data you already have in memory. When dealing
with HTTP requests and responses, you will likely use json.Decoder since it works directly with an io.Reader.

## tagging structs

```go
type User struct {
    ID string `json:"id,omitempty"` // skips this if empty
    FirstName string `json:"firstName"`
    LastName string `json:"lastName"`
  }
```

## parsing unknown data

```go
// user interface{} as the value since we dont know what is comming in
// key will always be string
// var testdata map[string]interface{}

// way to parse unknown data and find types
import (
  "encoding/json"
  "fmt"
)

func main() {
  // The JSON data we want to unmarshal.
  var rawJson map[string]interface{}

  jsonData := []byte(`{
        "name": "John Doe",
        "age": 30,
        "unknown": {
            "foo": "bar",
            "baz": 123
        }
    }`)

  err := json.Unmarshal(jsonData, &rawJson)
  if err != nil {
    panic(err)
  }

  for k, v := range rawJson {
    fmt.Printf("%v: %v, value type: %T\n", k, v, v)
  }

}

```

## parsing from web

data usually comes in as `[]bytes`

```go
func DecodeJSON() {
    jsonDataFromWeb := []byte(`
    {
      "test": 1,
      "test2": [
        1,
        2,
        3
      ]
    }
    `)
  }
```
