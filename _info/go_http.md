# http type and request

simple `http.Get` if you dont need any thing like timeouts or cookie injection

If you need to customize things like headers, cookies, or timeouts, you'll want to create a custom http.Client, and http.NewRequest, then use the client's Do method to execute it.

Full example of using http.NewRequest to POST api data, adds headers and api metadata

## example POST request with headers and json data

```go
package main

import (
  "bytes"
  "encoding/json"
  // "fmt"
  "net/http"
)

func createUser(url, apiKey string, data User) (User, error) {
  user, err := json.Marshal(data)
  if err != nil {
    return User{}, err
  }

  req, err := http.NewRequest("POST", url, bytes.NewBuffer(user))
  if err != nil {
    return User{}, err
  }

  req.Header.Set("Content-Type", "application/json")
  req.Header.Set("X-API-KEY", apiKey)

  newReq := &http.Client{}
  res, err := newReq.Do(req)
  if err != nil {
    return User{}, err
  }

  defer res.Body.Close()

  var userResp User

  decoder := json.NewDecoder(res.Body)
  err = decoder.Decode(userResp)
  if err != nil {
    return User{}, nil
  }

  return userResp, nil
}

```

## example POST request with data and custom headers

```go
type Comment struct {
  Id      string `json:"id"`
  UserId  string `json:"user_id"`
  Comment string `json:"comment"`
}

func createComment(url, apiKey string, commentStruct Comment) (Comment, error) {
    // encode our comment as json
  jsonData, err := json.Marshal(commentStruct)
  if err != nil {
    return Comment{}, err
  }

    // create a new request
  req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
  if err != nil {
    return Comment{}, err
  }

    // set request headers
  req.Header.Set("Content-Type", "application/json")
    req.Header.Set("X-API-Key", apiKey)

    // create a new client and make the request
  client := &http.Client{}
  res, err := client.Do(req)
  if err != nil {
    return Comment{}, err
  }
  defer res.Body.Close()

    // decode the json data from the response
  // into a new Comment struct
  var comment Comment
  decoder := json.NewDecoder(res.Body)
  err = decoder.Decode(&comment)
  if err != nil {
    return Comment{}, err
  }

  return comment, nil
}

```

## example simple Get request no data

```go
client := &http.Client{
  Timeout: time.Second * 10,
}

req, err := http.NewRequest("GET", "https://jsonplaceholder.typicode.com/users", nil)
if err != nil {
  log.Fatal(err)
}

resp, err := client.Do(req)

```
