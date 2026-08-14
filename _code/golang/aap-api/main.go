package main

import (
	"flag"
	"log"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"

	"go-aap-projects/api"
)

// loadEnvConfig gracefully loads environment variables from .env files
func loadEnvConfig() error {
	cwd, err := os.Getwd()
	if err != nil {
		return err
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return err
	}

	envPaths := []string{
		filepath.Join(cwd, ".env"),
		filepath.Join(homeDir, ".env"),
	}

	var lastErr error
	for _, path := range envPaths {
		if err := godotenv.Load(path); err == nil {
			return nil
		} else {
			lastErr = err
		}
	}

	return lastErr
}

func main() {
	getAll := flag.Bool("g", false, "Get and print all repos configured as projects in AAP")
	help := flag.Bool("h", false, "this :)")
	updateThisRepo := flag.Bool("u", false, "Attempt to resolve the git remote URL and find the repos matching this one in AAP")
	updateByID := flag.Int("id", 0, "Update a single repo in AAP by its numerical ID")
	flag.Parse()

	if *help {
		flag.Usage()
		os.Exit(0)
	}

	if err := loadEnvConfig(); err != nil {
		log.Println("Note: No .env file loaded, relying on system environment variables")
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

	if *updateThisRepo {
		aap.UpdateLocalRepo()
		return
	}

	if *getAll {
		aap.ShowRepos()
		return
	}

	if *updateByID != 0 {
		status := aap.UpdateProjectID(*updateByID)
		if status == 202 {
			log.Printf("AAP ➜ Project Sync Request Accepted - ID: %v", *updateByID)
		} else {
			log.Fatalf("AAP ➜ Project Sync Request failed - ID: %v, status: %v", *updateByID, status)
		}
		return
	}

	// Default behavior if no flags are passed
	aap.UpdateLocalRepo()
}
