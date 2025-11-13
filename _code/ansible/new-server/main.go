package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	side := "a"
	dir := filepath.Join(os.TempDir(), "go", side)
	fmt.Println(dir)
	command := fmt.Sprintf("env | grep %s", "USER")
	cmd := exec.Command("sh", "-c", command)
	cmd.Stdout = os.Stdout
	if err := cmd.Run(); err != nil {
		log.Fatalf("error %v", err)
	}
}
