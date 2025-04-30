package main

import (
	"fmt"
	"strings"
)

func main() {
	fmt.Println("hello world")
	fmt.Println(FunctionPrinter("test"))
}

func FunctionPrinter(s string) string {
	return strings.ToUpper(s)
}
