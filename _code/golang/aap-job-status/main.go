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

// Job represents any job execution in AAP (Standard, Workflow, Project Update, etc.)
type Job struct {
	ID                 int            `json:"id"`
	Type               string         `json:"type"` // e.g. "job", "workflow_job", "project_update"
	Name               string         `json:"name"`
	Status             string         `json:"status"`
	UnifiedJobTemplate int            `json:"unified_job_template,omitempty"`
	JobTemplate        int            `json:"job_template,omitempty"`
	WorkflowTemplate   int            `json:"workflow_job_template,omitempty"`
	JobTemplateName    string         `json:"job_template_name,omitempty"`
	Created            time.Time      `json:"created"`
	Started            time.Time      `json:"started"`
	Finished           time.Time      `json:"finished"`
	Elapsed            float64        `json:"elapsed"`
	PlaybookName       string         `json:"playbook,omitempty"`
	LaunchedBy         LaunchedByUser `json:"launched_by"`
}

// GetTemplateID reliably extracts the ID regardless of the job type
func (j *Job) GetTemplateID() int {
	if j.UnifiedJobTemplate != 0 {
		return j.UnifiedJobTemplate
	}
	if j.JobTemplate != 0 {
		return j.JobTemplate
	}
	if j.WorkflowTemplate != 0 {
		return j.WorkflowTemplate
	}
	return 0
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
	rawResponse []byte                 // Store raw API response for debug output
}

type Template struct {
	ID   int    `json:"id"`
	Type string `json:"type"`
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
		baseURL: strings.TrimRight("https://"+baseURL, "/"),
		client:  client,
	}
}

// fetchJobs retrieves jobs from AAP using the unified endpoint
func (a *Api) fetchJobs(filter string) ([]Job, error) {
	url := fmt.Sprintf("%s/api/v2/unified_jobs/", a.baseURL)
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

// getTemplateIDByName finds template ID by name using the unified template endpoint
func (a *Api) getTemplateIDByName(templateName string) (int, error) {
	url := fmt.Sprintf("%s/api/v2/unified_job_templates/?name=%s", a.baseURL, templateName)

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

// ShowRunningJobs displays all currently running unified jobs
func (a *Api) ShowRunningJobs() {
	jobs, err := a.fetchJobs("status=running")
	if err != nil {
		log.Fatal("failed to fetch running jobs:", err)
	}
	a.displayJobs(jobs, "Currently Running Jobs")
}

// ShowJobsByTemplateID displays jobs for specific template ID
func (a *Api) ShowJobsByTemplateID(templateID int) {
	// Filter by unified_job_template to cover standard and workflow templates
	filter := fmt.Sprintf("unified_job_template=%d", templateID)
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

// RelaunchJob relaunches a job only if it's not currently running
func (a *Api) RelaunchJob(jobID int) {
	job, err := a.fetchJobDetails(jobID)
	if err != nil {
		log.Fatal("failed to fetch job details:", err)
	}

	if job.Status == "running" {
		fmt.Printf("Job ID %d is currently running - cannot relaunch\n", jobID)
		fmt.Printf("Job Name: %s\n", job.Name)
		fmt.Printf("Status: %s\n", job.Status)
		if !job.Started.IsZero() {
			fmt.Printf("Started: %s\n", job.Started.Format("2006-01-02 15:04:05"))
			fmt.Printf("Duration: %s\n", formatDuration(job.Job))
		}
		return
	}

	fmt.Printf("Relaunching Job ID %d: %s\n", jobID, job.Name)
	fmt.Printf("Previous Status: %s\n", job.Status)
	fmt.Printf("Job Type: %s\n", job.Type)

	// Determine the correct endpoint based on the specific job type
	var typeEndpoint string
	switch job.Type {
	case "workflow_job":
		typeEndpoint = "workflow_jobs"
	case "project_update":
		typeEndpoint = "project_updates"
	case "inventory_update":
		typeEndpoint = "inventory_updates"
	default:
		typeEndpoint = "jobs"
	}

	relaunchURL := fmt.Sprintf("%s/api/v2/%s/%d/relaunch/", a.baseURL, typeEndpoint, jobID)

	resp, err := a.client.Post(relaunchURL, "application/json", nil)
	if err != nil {
		log.Fatal("failed to relaunch job:", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusCreated || resp.StatusCode == http.StatusOK {
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			log.Fatal("failed to read relaunch response:", err)
		}

		var relaunchResp map[string]interface{}
		if err := json.Unmarshal(body, &relaunchResp); err != nil {
			log.Fatal("failed to parse relaunch response:", err)
		}

		if newJobID, ok := relaunchResp["id"].(float64); ok {
			fmt.Printf("Relaunch successful! New Job ID: %.0f\n", newJobID)
		} else {
			fmt.Println("Relaunch successful!")
		}
	} else {
		body, _ := io.ReadAll(resp.Body)
		fmt.Printf("Relaunch failed with status %d: %s\n", resp.StatusCode, string(body))
	}
}

// fetchJobDetails retrieves detailed information from the unified endpoint
func (a *Api) fetchJobDetails(jobID int) (*JobDetail, error) {
	url := fmt.Sprintf("%s/api/v2/unified_jobs/%d/", a.baseURL, jobID)

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

	job.rawResponse = body
	return &job, nil
}

// displayJobDetails formats and prints detailed job information
func (a *Api) displayJobDetails(job *JobDetail) {
	sep := strings.Repeat("*", 50)
	fmt.Printf("%s Job Details %s\n", sep, sep)

	fmt.Printf("%s, job: %d\n", job.Name, job.ID)
	fmt.Printf("Type: %s\n", job.Type)
	fmt.Printf("Status: %s\n", job.Status)
	fmt.Printf("Template ID: %d\n", job.GetTemplateID())
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

	fmt.Printf("\nTiming:\n")
	fmt.Printf("  Created:  %s\n", job.Created.Format("2006-01-02 15:04:05"))
	if !job.Started.IsZero() {
		fmt.Printf("  Started:  %s\n", job.Started.Format("2006-01-02 15:04:05"))
	}
	if !job.Finished.IsZero() {
		fmt.Printf("  Finished: %s\n", job.Finished.Format("2006-01-02 15:04:05"))
	}
	fmt.Printf("  Duration: %s\n", formatDuration(job.Job))

	if job.Description != "" {
		fmt.Printf("\nDescription:\n%s\n", job.Description)
	}

	if len(job.Artifacts) > 0 {
		fmt.Printf("\nArtifacts:\n")
		for key, value := range job.Artifacts {
			fmt.Printf("  %s: %v\n", key, value)
		}
	}

	a.fetchAndDisplayJobOutput(job)

	if len(job.rawResponse) > 0 {
		var prettyJSON interface{}
		json.Unmarshal(job.rawResponse, &prettyJSON)
		formattedJSON, _ := json.MarshalIndent(prettyJSON, "", "  ")
		fmt.Printf("\n=== API RESPONSE ===\n%s\n=== END ===\n", string(formattedJSON))
	}
}

// displayJobs formats and prints job information
func (a *Api) displayJobs(jobs []Job, title string) {
	sep := strings.Repeat("*", 30)
	fmt.Printf("%s %s %s\n", sep, title, sep)

	if len(jobs) == 0 {
		log.Println("No jobs found")
		return
	}

	for _, job := range jobs {
		duration := formatDuration(job)
		fmt.Printf("%s job: %d\n", job.Name, job.ID)

		templateInfo := fmt.Sprintf("ID: %d", job.GetTemplateID())
		if job.JobTemplateName != "" {
			templateInfo = fmt.Sprintf("%s (ID: %d)", job.JobTemplateName, job.GetTemplateID())
		}

		fmt.Printf("  Type: %s\n", job.Type)
		fmt.Printf("  Template: %s\n", templateInfo)
		fmt.Printf("  Status: %s\n", job.Status)

		if job.Status == "running" && !job.Started.IsZero() {
			fmt.Printf("  Started: %s\n", job.Started.Format("2006-01-02 15:04:05"))
		}

		if job.LaunchedBy.Username != "" {
			fmt.Printf("  Launched By: %s\n", job.LaunchedBy.Username)
		}
		fmt.Printf("  Duration: %s\n", duration)
	}

	fmt.Printf("\nTotal: %d jobs\n", len(jobs))
}

// fetchAndDisplayJobOutput routes the output fetch dynamically based on the job type
func (a *Api) fetchAndDisplayJobOutput(job *JobDetail) {
	if job.Type == "workflow_job" {
		fmt.Printf("\n%s STDOUT %s\n", strings.Repeat("=", 20), strings.Repeat("=", 20))
		fmt.Println("Workflow jobs do not generate standard output natively.")
		fmt.Println("Please inspect the individual child jobs of this workflow for logs.")
		return
	}

	var endpoint string
	switch job.Type {
	case "project_update":
		endpoint = "project_updates"
	case "inventory_update":
		endpoint = "inventory_updates"
	default:
		endpoint = "jobs"
	}

	stdoutURL := fmt.Sprintf("%s/api/v2/%s/%d/stdout/?format=txt", a.baseURL, endpoint, job.ID)
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

	stderrURL := fmt.Sprintf("%s/api/v2/%s/%d/stderr/?format=txt", a.baseURL, endpoint, job.ID)
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
	fmt.Println("  -j          Get all currently running jobs (Standard & Workflow)")
	fmt.Println("  -t <n>      Get jobs by template name or ID")
	fmt.Println("  -d <id>     Get detailed information for specific job ID")
	fmt.Println("  -r <id>     Relaunch job (only if not currently running)")
	fmt.Println("  -h          Show this help")
	fmt.Println("\nExamples:")
	fmt.Println("  go run main.go -j                    # All running jobs")
	fmt.Println("  go run main.go -t \"Deploy Web App\"   # Jobs by template name")
	fmt.Println("  go run main.go -t 42                 # Jobs by template ID")
	fmt.Println("  go run main.go -d 1234               # Detailed job info")
	fmt.Println("  go run main.go -r 1234               # Relaunch job 1234 (if not running)")
}

func main() {
	getAllJobs := flag.Bool("j", false, "Get all currently running jobs")
	getJobsByTemplate := flag.String("t", "", "Get jobs by template name or ID")
	getJobDetails := flag.Int("d", 0, "Get detailed information for specific job ID")
	relaunchJob := flag.Int("r", 0, "Relaunch job (only if not currently running)")
	help := flag.Bool("h", false, "Show usage information")
	flag.Parse()

	if *help {
		printUsage()
		os.Exit(0)
	}

	if err := loadEnvConfig(); err != nil {
		log.Println("Note: No .env file loaded")
	}

	token := os.Getenv("AAP_TOKEN")
	if token == "" {
		log.Fatal("set ENV AAP_TOKEN")
	}

	aapUrl := os.Getenv("AAP_BASE_URL")
	if aapUrl == "" {
		log.Fatal("set ENV AAP_BASE_URL")
	}

	aap := NewApi(token, aapUrl)

	switch {
	case *relaunchJob != 0:
		aap.RelaunchJob(*relaunchJob)
	case *getJobDetails != 0:
		aap.ShowJobDetails(*getJobDetails)
	case *getAllJobs:
		aap.ShowRunningJobs()
	case *getJobsByTemplate != "":
		if templateID, err := strconv.Atoi(*getJobsByTemplate); err == nil {
			aap.ShowJobsByTemplateID(templateID)
		} else {
			aap.ShowJobsByTemplateName(*getJobsByTemplate)
		}
	default:
		aap.ShowRunningJobs()
	}
}
