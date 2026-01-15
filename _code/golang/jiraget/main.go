package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
)

// --- Models ---

type Config struct {
	JiraURL      string
	JiraEmail    string
	JiraAPIToken string
}

type SearchPayload struct {
	JQL    string   `json:"jql"`
	Fields []string `json:"fields"`
}

type SearchResponse struct {
	Issues []struct {
		Key    string `json:"key"`
		Fields struct {
			Summary string `json:"summary"`
		} `json:"fields"`
	} `json:"issues"`
}

type JiraSvc struct {
	config *Config
	client *http.Client
}

// --- Service ---

func New(config *Config) *JiraSvc {
	return &JiraSvc{
		config: config,
		client: &http.Client{},
	}
}

func (j *JiraSvc) GetMyOpenStories() error {
	// FIX: Use the specific /jql endpoint as mandated by the Jira error message
	url := fmt.Sprintf("%s/rest/api/3/search/jql", j.config.JiraURL)

	payload := SearchPayload{
		JQL:    "assignee = currentUser() AND issuetype = Story AND statusCategory != Done",
		Fields: []string{"summary"},
	}

	payloadBytes, _ := json.Marshal(payload)
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return err
	}

	// AUTHENTICATION: Matching your original working script
	auth := base64.StdEncoding.EncodeToString([]byte(j.config.JiraEmail + ":" + j.config.JiraAPIToken))
	req.Header.Set("Authorization", "Basic "+auth)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	resp, err := j.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("Jira API returned status: %d", resp.StatusCode)
	}

	var data SearchResponse
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return err
	}

	fmt.Printf("\n--- My Open Stories (%d found) ---\n", len(data.Issues))
	for _, issue := range data.Issues {
		browseURL := fmt.Sprintf("%s/browse/%s", j.config.JiraURL, issue.Key)
		// Clickable output format
		fmt.Printf("[%s] %s\n%s\n\n", issue.Key, issue.Fields.Summary, browseURL)
	}

	return nil
}

// --- Helpers ---

func LoadConfig() (*Config, error) {
	home, _ := os.UserHomeDir()
	if err := godotenv.Load(filepath.Join(home, ".env")); err != nil {
		return nil, err
	}
	return &Config{
		JiraURL:      os.Getenv("JIRA_URL"),
		JiraEmail:    os.Getenv("JIRA_EMAIL"),
		JiraAPIToken: os.Getenv("JIRA_API_TOKEN"),
	}, nil
}

func main() {
	cfg, err := LoadConfig()
	if err != nil {
		fmt.Println("Config error: Check ~/.env")
		os.Exit(1)
	}

	svc := New(cfg)
	if err := svc.GetMyOpenStories(); err != nil {
		fmt.Printf("FAILED: %v\n", err)
		os.Exit(1)
	}
}
