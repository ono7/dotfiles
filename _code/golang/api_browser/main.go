/*
j is alias for jq
- get the keys
./snitch -a ~/aap.yml -e job_templates | jq 'keys'

- what type of object is it?
./snitch -a ~/aap.yml -e job_templates | jq 'type'

- Check keys of the first item in the results list
./snitch -a aap.yaml -e job_templates | jq '.results[0] | keys'

- If the root itself is an array:
./snitch -a aap.yaml -e users | jq '.[0] | keys'

- check item 0 in results array and get its keys, chain commands with |
./snitch -a ~/aap.yml -e job_templates | j '.results[0] | keys'
*/
package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"

	"snitch/api"
)

func loadEnvConfig() {
	cwd, _ := os.Getwd()
	homeDir, _ := os.UserHomeDir()

	envPaths := []string{
		filepath.Join(cwd, ".env"),
		filepath.Join(homeDir, ".env"),
	}

	for _, path := range envPaths {
		if err := godotenv.Load(path); err == nil {
			break
		}
	}
}

func main() {
	authProfile := flag.String("a", "profile.yaml", "Path to the YAML profile configuration file")
	endpoint := flag.String("e", "", "Endpoint to query")
	method := flag.String("X", "GET", "HTTP method")
	debug := flag.Bool("v", false, "Enable verbose timing/debugging logs to stderr")
	help := flag.Bool("h", false, "Show help")

	flag.Parse()

	if *help {
		flag.Usage()
		os.Exit(0)
	}

	loadEnvConfig()

	cfg, err := api.LoadProfile(*authProfile)
	if err != nil {
		log.Fatalf("Profile load error: %v", err)
	}

	client := api.NewClientFromConfig(cfg, *debug)

	data, err := client.Request(*method, *endpoint)
	if err != nil {
		log.Fatalf("Request error: %v", err)
	}

	// Unformatted raw bytes or indent go strictly to stdout
	var prettyJSON bytes.Buffer
	if err := json.Indent(&prettyJSON, data, "", "  "); err == nil {
		fmt.Println(prettyJSON.String())
	} else {
		fmt.Println(string(data))
	}
}
