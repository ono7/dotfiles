# http client connections

```go
// parse urls
package main

import (
  "net/url"
)

func getDomainNameFromURL(rawURL string) (string, error) {
  // url.Parse returns a struct that we can use to decompose the URL parts
  parsedURL, err := url.Parse(rawURL)
  if err != nil {
    return "", err
  }
  return parsedURL.Hostname(), nil
}
```

## simple

quick and dirty, only implements timeout

```go
  rawUrl := "http://google.com"
  client := &http.Client{
    Timeout: 15 * time.Second,
  }
  resp, err := client.Get(rawUrl)
  if err != nil {
    log.Fatal("Get response error:", err)
  }
  defer resp.Body.Close()
```

## more advanced

Uses http.NewRequests

```go

```
