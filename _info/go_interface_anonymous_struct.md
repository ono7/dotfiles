# anonymous structs can be used inline to decode data

this will keep the main code base clean if this is only used once to unmarshall api json response

```go
// this can be used to unmarshall data from JSON but does not provide type checking and can lead to errors
// best to use an anonymous struct when possible and only use empty interface when discovering a new API

map[string]interface{}
```

```go

// anonymous structs can be used for table driven tests to provide inputs for testing
var cars = []struct {
    make string
    model string
    topSpeed
}{
    {"toyota", "camry", 100},
    {"tesla", "model 3", 250},
    {"ford", "focus", 120},
}

```

```go

func createCarHandler(w http.ResponseWriter, req *http.Request) {
    defer req.Body.Close()

    // setup decoder
    decoder := json.NewDecoder(req.Body)
    newCar := struct {
        Make    string `json:"make"`
        Model   string `json:"model"`
        Mileage int    `json:"mileage"`
    }{}
    err := decoder.Decode(&newCar)
    if err != nil {
        log.Println(err)
        return
    }
    makeCar(newCar.Make, newCar.Model, newCar.Mileage)
    return
}

```
