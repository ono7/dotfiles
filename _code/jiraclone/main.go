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

// --- Models ---

type Config struct {
	JiraURL      string
	JiraEmail    string
	JiraAPIToken string
}

type IssueMetadata struct {
	Fields struct {
		IssueType struct {
			Name string `json:"name"`
		} `json:"issuetype"`
	} `json:"fields"`
}

type ClonePayload struct {
	Summary            string `json:"summary"`
	Description        string `json:"description"`
	Customfield_10031  string `json:"customfield_10031"`
	IncludeAttachments bool   `json:"includeAttachments"`
}

type CloneResponse struct {
	Key  string `json:"key"`
	Self string `json:"self"`
}

type CloneResult struct {
	Title   string
	Success bool
	Error   error
}

// --- Service ---

type JiraClone struct {
	config *Config
	client *http.Client
}

func New(config *Config) *JiraClone {
	return &JiraClone{
		config: config,
		client: &http.Client{},
	}
}

// ValidateIsStory performs the pre-flight check to ensure we aren't cloning an Epic.
func (j *JiraClone) ValidateIsStory(issueKey string) error {
	url := fmt.Sprintf("%s/rest/api/2/issue/%s?fields=issuetype", j.config.JiraURL, issueKey)
	req, _ := http.NewRequest("GET", url, nil)

	j.setAuthHeader(req)
	resp, err := j.client.Do(req)
	if err != nil {
		return fmt.Errorf("network error verifying issue type: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("source issue %s not found (status %d)", issueKey, resp.StatusCode)
	}

	var meta IssueMetadata
	if err := json.NewDecoder(resp.Body).Decode(&meta); err != nil {
		return fmt.Errorf("failed to parse jira response: %w", err)
	}

	// Logic: Abort if "Epic" is found (case-insensitive)
	fieldType := meta.Fields.IssueType.Name
	if !strings.EqualFold(fieldType, "Story") {
		return fmt.Errorf("ABORT: Issue %s is an %v. Only Stories/Tasks can be cloned", issueKey, fieldType)
	}

	return nil
}

func (j *JiraClone) CloneIssue(issueKey string, title string) (*CloneResult, error) {
	result := &CloneResult{Title: title, Success: false}

	payload := ClonePayload{
		Summary:            title,
		Description:        title,
		Customfield_10031:  "",
		IncludeAttachments: false,
	}

	payloadBytes, _ := json.Marshal(payload)
	url := fmt.Sprintf("%s/rest/internal/2/issue/%s/clone", j.config.JiraURL, issueKey)

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		result.Error = err
		return result, err
	}

	j.setAuthHeader(req)
	req.Header.Set("Content-Type", "application/json")

	resp, err := j.client.Do(req)
	if err != nil {
		result.Error = err
		return result, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		body, _ := io.ReadAll(resp.Body)
		result.Error = fmt.Errorf("status %d: %s", resp.StatusCode, string(body))
		return result, result.Error
	}

	result.Success = true
	return result, nil
}

func (j *JiraClone) setAuthHeader(req *http.Request) {
	auth := base64.StdEncoding.EncodeToString([]byte(j.config.JiraEmail + ":" + j.config.JiraAPIToken))
	req.Header.Set("Authorization", "Basic "+auth)
}

// --- Orchestration ---

func (j *JiraClone) ProcessTitlesConcurrently(issueKey string, titles []string, maxWorkers int) {
	titlesChan := make(chan string, len(titles))
	resultsChan := make(chan *CloneResult, len(titles))

	for _, t := range titles {
		titlesChan <- t
	}
	close(titlesChan)

	var wg sync.WaitGroup
	for i := 0; i < maxWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for title := range titlesChan {
				res, _ := j.CloneIssue(issueKey, title)
				resultsChan <- res
			}
		}()
	}

	go func() {
		wg.Wait()
		close(resultsChan)
	}()

	success, total := 0, len(titles)
	for res := range resultsChan {
		if res.Success {
			success++
			fmt.Printf("✅ %s\n", res.Title)
		} else {
			fmt.Printf("❌ %s: %v\n", res.Title, res.Error)
		}
	}

	fmt.Printf("\nDone: %d/%d successful.\n", success, total)
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

func ProcessIssueKey(key string) string {
	if regexp.MustCompile(`(?i)^ntwk-`).MatchString(key) {
		return strings.ToUpper(key)
	}
	if regexp.MustCompile(`^\d+$`).MatchString(key) {
		return "NTWK-" + key
	}
	return key
}

func ReadTitles(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var titles []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") || len(line) < 10 {
			continue
		}
		titles = append(titles, line)
	}
	return titles, nil
}

// --- CLI ---

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: jiraclone <ID> <file> [workers]")
		os.Exit(1)
	}

	cfg, err := LoadConfig()
	if err != nil {
		fmt.Println("Config error: Check ~/.env for JIRA_URL, JIRA_EMAIL, JIRA_API_TOKEN")
		os.Exit(1)
	}

	svc := New(cfg)
	issueKey := ProcessIssueKey(os.Args[1])

	// THEORY: Verify issue type before starting expensive worker pool.
	fmt.Printf("Verifying issue %s...\n", issueKey)
	if err := svc.ValidateIsStory(issueKey); err != nil {
		fmt.Printf("FAILED: %v\n", err)
		os.Exit(1)
	}

	titles, _ := ReadTitles(os.Args[2])
	workers := 5
	if len(os.Args) > 3 {
		fmt.Sscanf(os.Args[3], "%d", &workers)
	}

	svc.ProcessTitlesConcurrently(issueKey, titles, workers)
}
