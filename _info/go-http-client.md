# http client connections

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
