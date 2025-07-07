package main

import (
	"bufio"
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"sync"

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
	Customfield_10031  string `json:"customfield_10031"` // Acceptance Criteria field
	IncludeAttachments bool   `json:"includeAttachments"`
}

// CloneResult represents the result of a clone operation
type CloneResult struct {
	Title   string
	Success bool
	Error   error
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
func (j *JiraClone) CloneIssue(issueKey string, title string) (*CloneResult, error) {
	result := &CloneResult{
		Title:   title,
		Success: false,
	}

	if !j.Setup() {
		result.Error = fmt.Errorf("setup failed")
		return result, result.Error
	}

	if len(title) < 10 {
		result.Error = fmt.Errorf("title must be at least 10 chars long")
		return result, result.Error
	}

	// Encode credentials for basic auth
	credentials := j.config.JiraEmail + ":" + j.config.JiraAPIToken
	auth := base64.StdEncoding.EncodeToString([]byte(credentials))

	clonePayload := ClonePayload{
		Summary:            title,
		Description:        title, // Set description to the same value as title
		Customfield_10031:  "",    // Set acceptance criteria to empty string
		IncludeAttachments: false,
	}

	// Convert payload to JSON
	payloadBytes, err := json.Marshal(clonePayload)
	if err != nil {
		result.Error = fmt.Errorf("failed to marshal clone payload: %w", err)
		return result, result.Error
	}

	// Create the request URL (for cloud-based JIRA deployments)
	url := fmt.Sprintf("%s/rest/internal/2/issue/%s/clone", j.config.JiraURL, issueKey)

	// Create HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		result.Error = fmt.Errorf("failed to create request: %w", err)
		return result, result.Error
	}

	// Set headers
	req.Header.Set("Authorization", "Basic "+auth)
	req.Header.Set("Content-Type", "application/json")

	// Execute the request
	resp, err := j.client.Do(req)
	if err != nil {
		result.Error = fmt.Errorf("failed to execute request: %w", err)
		return result, result.Error
	}
	defer resp.Body.Close()

	// Check response status
	if resp.StatusCode != 200 {
		body, _ := io.ReadAll(resp.Body)
		result.Error = fmt.Errorf("clone request failed with status %d: %s", resp.StatusCode, string(body))
		return result, result.Error
	}

	// Parse the response to get the new issue key
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		result.Error = fmt.Errorf("failed to read response body: %w", err)
		return result, result.Error
	}

	var cloneResponse CloneResponse
	if err := json.Unmarshal(body, &cloneResponse); err != nil {
		result.Error = fmt.Errorf("failed to parse clone response: %w", err)
		return result, result.Error
	}

	result.Success = true
	return result, nil
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

// ReadTitlesFromFile reads valid titles from a file
func ReadTitlesFromFile(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open file %s: %w", filename, err)
	}
	defer file.Close()

	var titles []string
	scanner := bufio.NewScanner(file)

	// Pattern to validate titles (must start with a letter)
	pattern := regexp.MustCompile(`^[A-Za-z]`)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines and lines starting with #
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		// Validate title pattern
		if !pattern.MatchString(line) {
			fmt.Printf("Skipping invalid title: '%s'\n", line)
			continue
		}

		// Check minimum length
		if len(line) < 10 {
			fmt.Printf("Skipping title too short: '%s'\n", line)
			continue
		}

		titles = append(titles, line)
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}

	return titles, nil
}

// ProcessTitlesConcurrently processes titles concurrently using goroutines
func (j *JiraClone) ProcessTitlesConcurrently(issueKey string, titles []string, maxWorkers int) {
	// Create channels
	titlesChan := make(chan string, len(titles))
	resultsChan := make(chan *CloneResult, len(titles))

	// Send titles to channel
	for _, title := range titles {
		titlesChan <- title
	}
	close(titlesChan)

	// Start worker goroutines
	var wg sync.WaitGroup
	for i := 0; i < maxWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for title := range titlesChan {
				result, _ := j.CloneIssue(issueKey, title)
				resultsChan <- result
			}
		}()
	}

	// Close results channel when all workers are done
	go func() {
		wg.Wait()
		close(resultsChan)
	}()

	// Collect and display results
	successCount := 0
	errorCount := 0

	fmt.Printf("Processing %d titles with %d workers...\n\n", len(titles), maxWorkers)

	for result := range resultsChan {
		if result.Success {
			successCount++
			fmt.Printf("✅ SUCCESS: '%s'\n", result.Title)
		} else {
			errorCount++
			fmt.Printf("❌ ERROR: '%s' -> %v\n", result.Title, result.Error)
		}
	}

	fmt.Printf("\n=== SUMMARY ===\n")
	fmt.Printf("Total processed: %d\n", len(titles))
	fmt.Printf("Successful: %d\n", successCount)
	fmt.Printf("Failed: %d\n", errorCount)
}

// Main function for the CLI tool
func main() {
	helptext := `
Usage:

    jiraclone <issue-key-number> <file-path> [max-workers]

Examples:
    jiraclone 1234 titles.txt
    jiraclone 1234 titles.txt 5

The file should contain one title per line.
Lines starting with # or empty lines will be ignored.
Titles must start with a letter and be at least 10 characters long.
`

	if len(os.Args) < 3 {
		fmt.Print(helptext)
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

	// Parse command line arguments
	issueKeyArg := os.Args[1]
	filename := os.Args[2]

	// Default number of workers
	maxWorkers := 10
	if len(os.Args) > 3 {
		fmt.Sscanf(os.Args[3], "%d", &maxWorkers)
		if maxWorkers < 1 {
			maxWorkers = 1
		}
		if maxWorkers > 10 {
			maxWorkers = 10 // Reasonable limit to avoid overwhelming JIRA
		}
	}

	// Process the issue key
	issueKey := ProcessIssueKey(issueKeyArg)
	fmt.Printf("Using issue key: %s\n", issueKey)

	// Read titles from file
	titles, err := ReadTitlesFromFile(filename)
	if err != nil {
		fmt.Printf("Error reading titles from file: %v\n", err)
		os.Exit(1)
	}

	if len(titles) == 0 {
		fmt.Println("No valid titles found in file")
		os.Exit(1)
	}

	fmt.Printf("Found %d valid titles\n", len(titles))

	// Process titles concurrently
	jiraClone.ProcessTitlesConcurrently(issueKey, titles, maxWorkers)
}
