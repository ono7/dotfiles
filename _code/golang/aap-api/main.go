package main

import (
	"log"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"

	"go-aap-projects/api"
)

func main() {
	// TODO: add some flags and default action
	cwd, err := os.Getwd()
	if err != nil {
		log.Fatal("os.Getwd() enable to resolve current working directory")
	}
	cwd = filepath.Join(cwd, ".env")

	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal("os.UserHomeDir() enable to resolve current working directory")
	}
	homeDir = filepath.Join(homeDir, ".env")

	if err := godotenv.Load(homeDir); err != nil {
		log.Fatal("error loading dotenv, try adding a ~/.env file with AAP_BASE_URL and AAP_TOKEN")
	}

	token := os.Getenv("AAP_TOKEN")
	if token == "" {
		log.Fatal("set ENV AAP_TOKEN")
	}

	aapUrl := os.Getenv("AAP_BASE_URL")
	if aapUrl == "" {
		log.Fatal("set ENV AAP_BASE_URL")
	}

	aap := api.NewApi(token, aapUrl)
	aap.GetAllProjects()
	aap.UpdateLocalRepo()
	return
}
