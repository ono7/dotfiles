# reader/writer inteface examples/notes for go

## implements io.Writer interface

`strings.Builder`

## implements io.Reader interface

## file read

```go
// io.ReadAll()
func ReadAll(r io.Reader) ([]byte, error) {
    b := make([]byte, 0, 1024) // Create a buffer with 0 length and 1024 capacity
    for {
        if len(b) == cap(b) {
            // Buffer is full, expand it
            b = append(b, 0)[:len(b)]
        }
        n, err := r.Read(b[len(b):cap(b)])
        b = b[:len(b)+n] // Extend slice to include new data
        if err != nil {
            if err == io.EOF {
                err = nil
            }
            return b, err
        }
    }
}
```

```go
file, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)
}
defer file.Close()

buf := make([]byte, 1024)
for {
    n, err := file.Read(buf)
    if err == io.EOF {
        break
    }
    if err != nil {
        log.Fatal(err)
    }
    fmt.Print(string(buf[:n]))
}
```

```go
// example 2

package main

import (
    "fmt"
    "os"
)

func main() {
    // Replace 'yourfile.txt' with your file's name
    content, err := os.ReadFile("yourfile.txt")
    if err != nil {
        // Handle the error
        fmt.Println("Error reading file:", err)
        return
    }

    // Print the contents of the file
    fmt.Print(string(content))
}
```

```go
// example 3
import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    // Replace 'yourfile.txt' with your file's name
    file, err := os.Open("yourfile.txt")
    if err != nil {
        // Handle the error
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close() // Ensure the file is closed after function returns

    // Read the file
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        fmt.Println(scanner.Text()) // Print each line
    }

    // Check for errors during reading
    if err := scanner.Err(); err != nil {
        fmt.Println("Error reading file:", err)
    }
}

```

## file write

```go

```

## network read

```go
conn, err := net.Dial("tcp", "golang.org:80")
if err != nil {
    log.Fatal(err)
}
defer conn.Close()

_, err = conn.Write([]byte("GET / HTTP/1.0\r\n\r\n"))
if err != nil {
    log.Fatal(err)
}

buf := make([]byte, 1024)
for {
    n, err := conn.Read(buf)
    if err == io.EOF {
        break
    }
    if err != nil {
        log.Fatal(err)
    }
    fmt.Print(string(buf[:n]))
}
```
