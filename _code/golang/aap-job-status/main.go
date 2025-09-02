package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/joho/godotenv"
)

// Job represents a job in AAP
type Job struct {
	ID              int            `json:"id"`
	Name            string         `json:"name"`
	Status          string         `json:"status"`
	JobTemplate     int            `json:"job_template"`
	JobTemplateName string         `json:"job_template_name,omitempty"`
	Created         time.Time      `json:"created"`
	Started         time.Time      `json:"started"`
	Finished        time.Time      `json:"finished"`
	Elapsed         float64        `json:"elapsed"`
	ResultStdout    string         `json:"result_stdout"`
	ResultStderr    string         `json:"result_stderr"`
	PlaybookName    string         `json:"playbook"`
	LaunchedBy      LaunchedByUser `json:"launched_by"`
}

// LaunchedByUser represents the user who launched the job
type LaunchedByUser struct {
	ID       int    `json:"id,omitempty"`
	Username string `json:"username,omitempty"`
	Name     string `json:"first_name,omitempty"`
}

// JobDetail represents detailed job information
type JobDetail struct {
	Job
	Description string                 `json:"description"`
	Artifacts   map[string]interface{} `json:"artifacts"`
}

type Template struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type JobsResponse struct {
	Count   int   `json:"count"`
	Results []Job `json:"results"`
}

type TemplatesResponse struct {
	Count   int        `json:"count"`
	Results []Template `json:"results"`
}

// authTransport handles Bearer token authentication
type authTransport struct {
	Transport http.RoundTripper
	AuthToken string
}

func (t *authTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Add("Authorization", "Bearer "+t.AuthToken)
	req.Header.Set("Content-Type", "application/json")
	return t.Transport.RoundTrip(req)
}

// Api client for AAP interactions
type Api struct {
	baseURL string
	client  *http.Client
}

func NewApi(token, baseURL string) *Api {
	client := &http.Client{
		Transport: &authTransport{
			Transport: http.DefaultTransport,
			AuthToken: token,
		},
	}
	return &Api{
		baseURL: "https://" + baseURL,
		client:  client,
	}
}

// fetchJobs retrieves jobs from AAP with optional filters
func (a *Api) fetchJobs(filter string) ([]Job, error) {
	url := fmt.Sprintf("%s/api/v2/jobs/", a.baseURL)
	if filter != "" {
		url += "?" + filter
	}

	resp, err := a.client.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("API request failed with status %d", resp.StatusCode)
	}

	var jobsResp JobsResponse
	if err := json.NewDecoder(resp.Body).Decode(&jobsResp); err != nil {
		return nil, err
	}

	return jobsResp.Results, nil
}

// getTemplateIDByName finds template ID by name
func (a *Api) getTemplateIDByName(templateName string) (int, error) {
	url := fmt.Sprintf("%s/api/v2/job_templates/?name=%s", a.baseURL, templateName)

	resp, err := a.client.Get(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return 0, fmt.Errorf("template search failed with status %d", resp.StatusCode)
	}

	var templatesResp TemplatesResponse
	if err := json.NewDecoder(resp.Body).Decode(&templatesResp); err != nil {
		return 0, err
	}

	if len(templatesResp.Results) == 0 {
		return 0, fmt.Errorf("template '%s' not found", templateName)
	}

	return templatesResp.Results[0].ID, nil
}

// ShowRunningJobs displays all currently running jobs
func (a *Api) ShowRunningJobs() {
	jobs, err := a.fetchJobs("status=running")
	if err != nil {
		log.Fatal("failed to fetch running jobs:", err)
	}
	a.displayJobs(jobs, "Currently Running Jobs")
}

// ShowJobsByTemplateID displays jobs for specific template ID
func (a *Api) ShowJobsByTemplateID(templateID int) {
	filter := fmt.Sprintf("job_template=%d", templateID)
	jobs, err := a.fetchJobs(filter)
	if err != nil {
		log.Fatal("failed to fetch jobs by template ID:", err)
	}

	title := fmt.Sprintf("Jobs for Template ID %d", templateID)
	a.displayJobs(jobs, title)
}

// ShowJobsByTemplateName displays jobs for specific template name
func (a *Api) ShowJobsByTemplateName(templateName string) {
	templateID, err := a.getTemplateIDByName(templateName)
	if err != nil {
		log.Fatal("failed to find template by name:", err)
	}
	a.ShowJobsByTemplateID(templateID)
}

// ShowJobDetails fetches and displays detailed information for a specific job
func (a *Api) ShowJobDetails(jobID int) {
	job, err := a.fetchJobDetails(jobID)
	if err != nil {
		log.Fatal("failed to fetch job details:", err)
	}
	a.displayJobDetails(job)
}

// fetchJobDetails retrieves detailed information for a specific job
func (a *Api) fetchJobDetails(jobID int) (*JobDetail, error) {
	url := fmt.Sprintf("%s/api/v2/jobs/%d/", a.baseURL, jobID)

	resp, err := a.client.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("job details request failed with status %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var job JobDetail
	if err := json.Unmarshal(body, &job); err != nil {
		return nil, err
	}

	return &job, nil
}

// displayJobDetails formats and prints detailed job information
func (a *Api) displayJobDetails(job *JobDetail) {
	sep := strings.Repeat("*", 50)
	fmt.Printf("%s Job Details %s\n", sep, sep)

	fmt.Printf("\nJob ID: %d\n", job.ID)
	fmt.Printf("Name: %s\n", job.Name)
	fmt.Printf("Status: %s\n", job.Status)
	fmt.Printf("Template ID: %d\n", job.JobTemplate)
	if job.JobTemplateName != "" {
		fmt.Printf("Template Name: %s\n", job.JobTemplateName)
	}
	if job.PlaybookName != "" {
		fmt.Printf("Playbook: %s\n", job.PlaybookName)
	}
	if job.LaunchedBy.Username != "" {
		launchedBy := job.LaunchedBy.Username
		if job.LaunchedBy.Name != "" {
			launchedBy = fmt.Sprintf("%s (%s)", job.LaunchedBy.Name, job.LaunchedBy.Username)
		}
		fmt.Printf("Launched By: %s\n", launchedBy)
	}

	// Timing information
	fmt.Printf("\nTiming:\n")
	fmt.Printf("  Created:  %s\n", job.Created.Format("2006-01-02 15:04:05"))
	if !job.Started.IsZero() {
		fmt.Printf("  Started:  %s\n", job.Started.Format("2006-01-02 15:04:05"))
	}
	if !job.Finished.IsZero() {
		fmt.Printf("  Finished: %s\n", job.Finished.Format("2006-01-02 15:04:05"))
	}
	fmt.Printf("  Duration: %s\n", formatDuration(job.Job))

	// Description if available
	if job.Description != "" {
		fmt.Printf("\nDescription:\n%s\n", job.Description)
	}

	// Artifacts if available
	if len(job.Artifacts) > 0 {
		fmt.Printf("\nArtifacts:\n")
		for key, value := range job.Artifacts {
			fmt.Printf("  %s: %v\n", key, value)
		}
	}

	// Get job output
	a.fetchAndDisplayJobOutput(job.ID)
}

// displayJobs formats and prints job information (for lists)
func (a *Api) displayJobs(jobs []Job, title string) {
	sep := strings.Repeat("*", 30)
	fmt.Printf("%s %s %s\n", sep, title, sep)

	if len(jobs) == 0 {
		log.Println("No jobs found")
		return
	}

	for _, job := range jobs {
		duration := formatDuration(job)
		fmt.Printf("\nJob ID: %d\n", job.ID)
		fmt.Printf("Name: %s\n", job.Name)

		// Get template name if we have it, otherwise just show ID
		templateInfo := fmt.Sprintf("ID: %d", job.JobTemplate)
		if job.JobTemplateName != "" {
			templateInfo = fmt.Sprintf("%s (ID: %d)", job.JobTemplateName, job.JobTemplate)
		}
		fmt.Printf("  Template: %s\n", templateInfo)
		fmt.Printf("  Status: %s\n", job.Status)

		// Show start time for running jobs
		if job.Status == "running" && !job.Started.IsZero() {
			fmt.Printf("  Started: %s\n", job.Started.Format("2006-01-02 15:04:05"))
		}

		// Show launched by info if available
		if job.LaunchedBy.Username != "" {
			fmt.Printf("  Launched By: %s\n", job.LaunchedBy.Username)
		}
		fmt.Printf("  Duration: %s\n", duration)
	}

	fmt.Printf("\nTotal: %d jobs\n", len(jobs))
}

// fetchAndDisplayJobOutput gets job output from stdout/stderr endpoints
func (a *Api) fetchAndDisplayJobOutput(jobID int) {
	// Try stdout first
	stdoutURL := fmt.Sprintf("%s/api/v2/jobs/%d/stdout/?format=txt", a.baseURL, jobID)

	resp, err := a.client.Get(stdoutURL)
	if err != nil {
		fmt.Printf("\nFailed to fetch job output: %v\n", err)
		return
	}
	defer resp.Body.Close()

	outputFound := false
	if resp.StatusCode == http.StatusOK {
		body, err := io.ReadAll(resp.Body)
		if err == nil && len(body) > 0 {
			fmt.Printf("\n%s STDOUT %s\n", strings.Repeat("=", 20), strings.Repeat("=", 20))
			fmt.Println(string(body))
			outputFound = true
		}
	}

	// Also try stderr endpoint for failed jobs
	stderrURL := fmt.Sprintf("%s/api/v2/jobs/%d/stderr/?format=txt", a.baseURL, jobID)

	stderrResp, err := a.client.Get(stderrURL)
	if err == nil {
		defer stderrResp.Body.Close()
		if stderrResp.StatusCode == http.StatusOK {
			stderrBody, err := io.ReadAll(stderrResp.Body)
			if err == nil && len(stderrBody) > 0 {
				fmt.Printf("\n%s STDERR %s\n", strings.Repeat("=", 20), strings.Repeat("=", 20))
				fmt.Println(string(stderrBody))
				outputFound = true
			}
		}
	}

	// If no output was found
	if !outputFound {
		if resp.StatusCode != http.StatusOK {
			fmt.Printf("\nJob output not available (status: %d)\n", resp.StatusCode)
		} else {
			fmt.Println("\nNo output available")
		}
	}
}

// formatDuration creates human-readable duration string
func formatDuration(job Job) string {
	var duration time.Duration

	if job.Status == "running" && !job.Started.IsZero() {
		duration = time.Since(job.Started)
	} else if job.Elapsed > 0 {
		duration = time.Duration(job.Elapsed * float64(time.Second))
	} else {
		return "N/A"
	}

	// Convert to human readable format
	hours := int(duration.Hours())
	minutes := int(duration.Minutes()) % 60
	seconds := int(duration.Seconds()) % 60

	var parts []string
	if hours > 0 {
		parts = append(parts, fmt.Sprintf("%dh", hours))
	}
	if minutes > 0 {
		parts = append(parts, fmt.Sprintf("%dm", minutes))
	}
	if seconds > 0 || len(parts) == 0 {
		parts = append(parts, fmt.Sprintf("%ds", seconds))
	}

	result := strings.Join(parts, " ")
	if job.Status == "running" {
		result += " (running)"
	}

	return result
}

// loadEnvConfig loads environment variables from .env files
func loadEnvConfig() error {
	cwd, err := os.Getwd()
	if err != nil {
		return err
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return err
	}

	// Try loading from current directory first, then home directory
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

func printUsage() {
	fmt.Println("AAP Jobs Manager")
	fmt.Println("Usage:")
	fmt.Println("  -j          Get all currently running jobs")
	fmt.Println("  -t <n>   Get jobs by template name or ID")
	fmt.Println("  -d <id>     Get detailed information for specific job ID")
	fmt.Println("  -h          Show this help")
	fmt.Println("\nExamples:")
	fmt.Println("  go run main.go -j                    # All running jobs")
	fmt.Println("  go run main.go -t \"Deploy Web App\"   # Jobs by template name")
	fmt.Println("  go run main.go -t 42                 # Jobs by template ID")
	fmt.Println("  go run main.go -d 1234               # Detailed job info")
}

func main() {
	getAllJobs := flag.Bool("j", false, "Get all currently running jobs")
	getJobsByTemplate := flag.String("t", "", "Get jobs by template name or ID")
	getJobDetails := flag.Int("d", 0, "Get detailed information for specific job ID")
	help := flag.Bool("h", false, "Show usage information")
	flag.Parse()

	if *help {
		printUsage()
		os.Exit(0)
	}

	// Load environment configuration
	if err := loadEnvConfig(); err != nil {
		log.Fatal("error loading .env file - add ~/.env with AAP_BASE_URL and AAP_TOKEN")
	}

	token := os.Getenv("AAP_TOKEN")
	if token == "" {
		log.Fatal("set ENV AAP_TOKEN")
	}

	aapUrl := os.Getenv("AAP_BASE_URL")
	if aapUrl == "" {
		log.Fatal("set ENV AAP_BASE_URL")
	}

	// Initialize API client
	aap := NewApi(token, aapUrl)

	// Route based on flags
	switch {
	case *getJobDetails != 0:
		aap.ShowJobDetails(*getJobDetails)
	case *getAllJobs:
		aap.ShowRunningJobs()
	case *getJobsByTemplate != "":
		// Handle both template name and ID
		if templateID, err := strconv.Atoi(*getJobsByTemplate); err == nil {
			aap.ShowJobsByTemplateID(templateID)
		} else {
			aap.ShowJobsByTemplateName(*getJobsByTemplate)
		}
	default:
		// Default behavior - show all running jobs
		aap.ShowRunningJobs()
	}
}
