```go

package main

import (
  "bufio"
  "fmt"
  "os"
  "strings"
)

func main() {
  fmt.Println("Emma, you must prove your hacking skills")
  scanner := bufio.NewScanner(os.Stdin)
  fmt.Println("Enter a password to unlock the next clue and press Enter: ")
  for {
    scanner.Scan()
    if strings.TrimSpace(scanner.Text()) == "0000" || strings.TrimSpace(scanner.Text()) == "test" {
      break
    }
    fmt.Println("Invalid password.. (hint: use a password you already know)")
  }
  fmt.Println("System HACKED")
  fmt.Println("Your clue is: ")
  fmt.Println("ABCDE COPY AND SEND THIS TO BUBBA OVER EMAIL, HE MUST NOW PROVE HIS DECODING SKILLS")
  fmt.Println("OR USE THE INTERNET")
}

```
