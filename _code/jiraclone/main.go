package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"

	"github.com/joho/godotenv"
)

// Config holds the JIRA configuration
type Config struct {
	JiraURL      string
	JiraEmail    string
	JiraAPIToken string
}

// JiraClone represents the main service
type JiraClone struct {
	config *Config
	client *http.Client
}

// CloneResponse represents the response from JIRA clone API
type CloneResponse struct {
	Key  string `json:"key"`
	Self string `json:"self"`
}

type ClonePayload struct {
	Summary            string `json:"summary"`
	Description        string `json:"description"`
	IncludeAttachments bool   `json:"includeAttachments"`
}

// New creates a new JiraClone instance
func New(config *Config) *JiraClone {
	return &JiraClone{
		config: config,
		client: &http.Client{},
	}
}

// Setup validates the configuration
func (j *JiraClone) Setup() bool {
	if j.config == nil {
		fmt.Println("Error: Configuration is nil")
		return false
	}
	if j.config.JiraURL == "" || j.config.JiraEmail == "" || j.config.JiraAPIToken == "" {
		fmt.Println("Error: Missing required configuration (JiraURL, JiraEmail, or JiraAPIToken)")
		return false
	}
	return true
}

// CloneIssue clones a JIRA issue with a custom title
func (j *JiraClone) CloneIssue(issueKey string, title string) error {
	if !j.Setup() {
		return fmt.Errorf("setup failed")
	}

	if len(title) < 10 {
		return fmt.Errorf("Title must be at least 10 chars long..")
	}

	// Encode credentials for basic auth
	credentials := j.config.JiraEmail + ":" + j.config.JiraAPIToken
	auth := base64.StdEncoding.EncodeToString([]byte(credentials))

	clonePayload := ClonePayload{
		Summary:            title,
		Description:        title, // Set description to the same value as title
		IncludeAttachments: false,
	}

	// Convert payload to JSON
	payloadBytes, err := json.Marshal(clonePayload)
	if err != nil {
		return fmt.Errorf("failed to marshal clone payload: %w", err)
	}

	// Create the request URL (for cloud-based JIRA deployments)
	url := fmt.Sprintf("%s/rest/internal/2/issue/%s/clone", j.config.JiraURL, issueKey)

	// Create HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	// Set headers
	req.Header.Set("Authorization", "Basic "+auth)
	req.Header.Set("Content-Type", "application/json")

	// Execute the request
	resp, err := j.client.Do(req)
	if err != nil {
		return fmt.Errorf("failed to execute request: %w", err)
	}
	defer resp.Body.Close()

	// Check response status
	if resp.StatusCode != 200 {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("clone request failed with status %d: %s", resp.StatusCode, string(body))
	}

	// Parse the response to get the new issue key
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("failed to read response body: %w", err)
	}

	var cloneResponse CloneResponse
	if err := json.Unmarshal(body, &cloneResponse); err != nil {
		return fmt.Errorf("failed to parse clone response: %w", err)
	}

	fmt.Printf("Successfully cloned %s with title: %s\n", issueKey, title)
	return nil
}

// LoadConfigFromEnvFile loads JIRA configuration from ~/.env file using godotenv
func LoadConfigFromEnvFile() (*Config, error) {
	// Get home directory
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	envFilePath := filepath.Join(homeDir, ".env")

	// Load .env file
	err = godotenv.Load(envFilePath)
	if err != nil {
		return nil, fmt.Errorf("failed to load .env file from %s: %w", envFilePath, err)
	}

	config := &Config{
		JiraURL:      os.Getenv("JIRA_URL"),
		JiraEmail:    os.Getenv("JIRA_EMAIL"),
		JiraAPIToken: os.Getenv("JIRA_API_TOKEN"),
	}

	// Validate required fields
	if config.JiraURL == "" {
		return nil, fmt.Errorf("JIRA_URL not found in ~/.env file")
	}
	if config.JiraEmail == "" {
		return nil, fmt.Errorf("JIRA_EMAIL not found in ~/.env file")
	}
	if config.JiraAPIToken == "" {
		return nil, fmt.Errorf("JIRA_API_TOKEN not found in ~/.env file")
	}

	return config, nil
}

func ProcessIssueKey(preissue string) string {
	// Check if it already has the NTWK- prefix (case insensitive)
	ntwkPattern := regexp.MustCompile(`^[Nn][Tt][Ww][Kk]-`)
	if ntwkPattern.MatchString(preissue) {
		return preissue
	}

	// Check if it's just a number
	numberPattern := regexp.MustCompile(`^\d+`)
	if numberPattern.MatchString(preissue) {
		return fmt.Sprintf("NTWK-%s", preissue)
	}

	// Return as-is if it doesn't match expected patterns
	return preissue
}

// JiraCloneCommand handles the command-line interface logic
func (j *JiraClone) JiraCloneCommand(args []string) error {
	if len(args) != 2 {
		return fmt.Errorf("usage: JiraClone <issue-key> <title>")
	}

	// Process the issue key
	issueKey := ProcessIssueKey(args[0])

	// Get the title for the clone
	title := args[1]

	return j.CloneIssue(issueKey, title)
}

// Main function for the CLI tool
func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: jiraclone <issue-key-number> <title>")
		fmt.Printf("\nor\n\n")
		fmt.Println("while read line; do ./jiraclone <issue-key-number> \"${line}\"; done < file.txt")
        fmt.Println()
		fmt.Println("A file.txt may contain lines that will be used as the new issue title and description")
		fmt.Println("lines that start with # or empty lines will be ignored")
		os.Exit(1)
	}

	// Load configuration from ~/.env file
	config, err := LoadConfigFromEnvFile()
	if err != nil {
		fmt.Printf("Error loading config: %v\n", err)
		fmt.Println("Make sure you have a ~/.env file with JIRA_URL, JIRA_EMAIL, and JIRA_API_TOKEN")
		os.Exit(1)
	}

	jiraClone := New(config)
	args := os.Args[1:]

	title := args[1]

	if title == "" || title == " " {
		os.Exit(0)
	}

	pattern := regexp.MustCompile(`^[A-Za-z]`)
	if !pattern.MatchString(title) {
		fmt.Printf("'%s' skipping invalid title\n", title)
		os.Exit(0)
	}

	if err := jiraClone.JiraCloneCommand(args); err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}
