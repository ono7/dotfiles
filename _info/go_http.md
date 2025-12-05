# http type and request

simple `http.Get` if you dont need any thing like timeouts or cookie injection

If you need to customize things like headers, cookies, or timeouts, you'll want to create a custom http.Client, and http.NewRequest, then use the client's Do method to execute it.

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
