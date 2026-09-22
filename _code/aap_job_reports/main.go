package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/joho/godotenv"
	_ "modernc.org/sqlite"
)

type Project struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type ProjectResponse struct {
	Count   int       `json:"count"`
	Results []Project `json:"results"`
}

type JobTemplate struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	ProjectID   int    `json:"project"`
}

type JobTemplatesResponse struct {
	Count   int           `json:"count"`
	Next    *string       `json:"next"`
	Results []JobTemplate `json:"results"`
}

type LaunchedByUser struct {
	ID       int    `json:"id,omitempty"`
	Username string `json:"username,omitempty"`
	Name     string `json:"first_name,omitempty"`
}

type JobSummaryFields struct {
	CreatedBy *LaunchedByUser `json:"created_by,omitempty"`
	User      *LaunchedByUser `json:"user,omitempty"`
}

type JobExecution struct {
	ID             int               `json:"id"`
	Status         string            `json:"status"`
	Failed         bool              `json:"failed"`
	LaunchType     string            `json:"launch_type"`
	Elapsed        float64           `json:"elapsed"`
	Created        time.Time         `json:"created"`
	Started        time.Time         `json:"started"`
	Finished       time.Time         `json:"finished"`
	ExtraVars      string            `json:"extra_vars"`
	JobExplanation string            `json:"job_explanation"`
	ResultTrace    string            `json:"result_traceback"`
	LaunchedBy     LaunchedByUser    `json:"launched_by"`
	SummaryFields  *JobSummaryFields `json:"summary_fields,omitempty"`
}

type JobExecutionsResponse struct {
	Count   int            `json:"count"`
	Next    *string        `json:"next"`
	Results []JobExecution `json:"results"`
}

type JobRunRecord struct {
	JobID              int       `json:"job_id"`
	TemplateID         int       `json:"template_id"`
	TemplateName       string    `json:"template_name"`
	ProjectID          int       `json:"project_id"`
	ProjectName        string    `json:"project_name"`
	Status             string    `json:"status"`
	Failed             bool      `json:"failed"`
	LaunchType         string    `json:"launch_type"`
	LaunchedByUsername string    `json:"launched_by_username"`
	LaunchedByName     string    `json:"launched_by_name"`
	ExtraVars          string    `json:"extra_vars"`
	ErrorMessage       string    `json:"error_message"`
	ElapsedSeconds     float64   `json:"elapsed_seconds"`
	StartedAt          time.Time `json:"started_at"`
	FinishedAt         time.Time `json:"finished_at"`
	CollectedAt        time.Time `json:"collected_at"`
}

type authTransport struct {
	Transport http.RoundTripper
	AuthToken string
	Debug     bool
}

func (t *authTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Add("Authorization", "Bearer "+t.AuthToken)
	req.Header.Set("Content-Type", "application/json")

	if t.Debug {
		log.Printf("[DEBUG HTTP] >>> %s %s", req.Method, req.URL.String())
	}

	resp, err := t.Transport.RoundTrip(req)
	if err != nil {
		if t.Debug {
			log.Printf("[DEBUG HTTP] <<< ERROR: %v", err)
		}
		return nil, err
	}

	if t.Debug {
		log.Printf("[DEBUG HTTP] <<< Status: %d %s", resp.StatusCode, http.StatusText(resp.StatusCode))
	}
	return resp, nil
}

type ApiClient struct {
	baseURL string
	client  *http.Client
	debug   bool
}

func NewApiClient(token, baseURL string, debug bool) *ApiClient {
	return &ApiClient{
		baseURL: strings.TrimRight("https://"+baseURL, "/"),
		debug:   debug,
		client: &http.Client{
			Timeout: 60 * time.Second,
			Transport: &authTransport{
				Transport: http.DefaultTransport,
				AuthToken: token,
				Debug:     debug,
			},
		},
	}
}

func (c *ApiClient) resolveProject(projectIdentifier string) (*Project, error) {
	if id, err := strconv.Atoi(projectIdentifier); err == nil {
		reqURL := fmt.Sprintf("%s/api/controller/v2/projects/%d/", c.baseURL, id)
		resp, err := c.client.Get(reqURL)
		if err != nil {
			return nil, err
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			body, _ := io.ReadAll(resp.Body)
			return nil, fmt.Errorf("project lookup failed (HTTP %d): %s", resp.StatusCode, string(body))
		}

		var p Project
		if err := json.NewDecoder(resp.Body).Decode(&p); err != nil {
			return nil, err
		}
		return &p, nil
	}

	encoded := url.QueryEscape(projectIdentifier)
	reqURL := fmt.Sprintf("%s/api/controller/v2/projects/?name=%s", c.baseURL, encoded)
	resp, err := c.client.Get(reqURL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("project lookup failed (HTTP %d): %s", resp.StatusCode, string(body))
	}

	var pr ProjectResponse
	if err := json.NewDecoder(resp.Body).Decode(&pr); err != nil {
		return nil, err
	}

	if len(pr.Results) == 0 {
		return nil, fmt.Errorf("project %q not found", projectIdentifier)
	}
	return &pr.Results[0], nil
}

func (c *ApiClient) fetchTemplatesForProject(projectID int) ([]JobTemplate, error) {
	var templates []JobTemplate
	reqURL := fmt.Sprintf("%s/api/controller/v2/job_templates/?project=%d&page_size=100", c.baseURL, projectID)

	for reqURL != "" {
		resp, err := c.client.Get(reqURL)
		if err != nil {
			return nil, err
		}

		if resp.StatusCode != http.StatusOK {
			body, _ := io.ReadAll(resp.Body)
			resp.Body.Close()
			return nil, fmt.Errorf("failed fetching templates (HTTP %d) URL: %s | Response: %s", resp.StatusCode, reqURL, string(body))
		}

		var page JobTemplatesResponse
		err = json.NewDecoder(resp.Body).Decode(&page)
		resp.Body.Close()
		if err != nil {
			return nil, err
		}

		templates = append(templates, page.Results...)
		if page.Next != nil && *page.Next != "" {
			if strings.HasPrefix(*page.Next, "http") {
				reqURL = *page.Next
			} else {
				reqURL = c.baseURL + *page.Next
			}
		} else {
			reqURL = ""
		}
	}

	return templates, nil
}

func (c *ApiClient) fetchExecutions(templateID int) ([]JobExecution, error) {
	var executions []JobExecution
	reqURL := fmt.Sprintf("%s/api/controller/v2/job_templates/%d/jobs/?order_by=-created&page_size=100", c.baseURL, templateID)

	for reqURL != "" {
		resp, err := c.client.Get(reqURL)
		if err != nil {
			return nil, err
		}

		if resp.StatusCode != http.StatusOK {
			body, _ := io.ReadAll(resp.Body)
			resp.Body.Close()
			return nil, fmt.Errorf("failed fetching executions (HTTP %d) URL: %s | Response: %s", resp.StatusCode, reqURL, string(body))
		}

		var page JobExecutionsResponse
		err = json.NewDecoder(resp.Body).Decode(&page)
		resp.Body.Close()
		if err != nil {
			return nil, err
		}

		executions = append(executions, page.Results...)
		if page.Next != nil && *page.Next != "" {
			if strings.HasPrefix(*page.Next, "http") {
				reqURL = *page.Next
			} else {
				reqURL = c.baseURL + *page.Next
			}
		} else {
			reqURL = ""
		}
	}

	return executions, nil
}

func initDatabase(ctx context.Context, dbPath string) (*sql.DB, error) {
	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return nil, err
	}

	if _, err := db.ExecContext(ctx, "PRAGMA journal_mode=WAL;"); err != nil {
		db.Close()
		return nil, err
	}

	schema := `
	CREATE TABLE IF NOT EXISTS job_runs (
		job_id INTEGER PRIMARY KEY,
		template_id INTEGER NOT NULL,
		template_name TEXT NOT NULL,
		project_id INTEGER NOT NULL,
		project_name TEXT NOT NULL,
		status TEXT NOT NULL,
		failed INTEGER NOT NULL DEFAULT 0,
		launch_type TEXT NOT NULL,
		launched_by_username TEXT NOT NULL,
		launched_by_name TEXT NOT NULL,
		extra_vars TEXT,
		error_message TEXT,
		elapsed_seconds REAL NOT NULL,
		started_at TEXT,
		finished_at TEXT,
		collected_at TEXT NOT NULL
	);

	CREATE INDEX IF NOT EXISTS idx_job_runs_template ON job_runs(template_id);
	CREATE INDEX IF NOT EXISTS idx_job_runs_user ON job_runs(launched_by_username);
	CREATE INDEX IF NOT EXISTS idx_job_runs_status ON job_runs(status);
	CREATE INDEX IF NOT EXISTS idx_job_runs_failed ON job_runs(failed);

	CREATE VIEW IF NOT EXISTS v_template_user_summary AS
	SELECT
		template_name,
		launched_by_username,
		status,
		COUNT(*) AS execution_count,
		ROUND(AVG(elapsed_seconds), 2) AS avg_duration_sec,
		MAX(started_at) AS last_executed_at
	FROM job_runs
	GROUP BY template_name, launched_by_username, status;
	`

	if _, err := db.ExecContext(ctx, schema); err != nil {
		db.Close()
		return nil, err
	}

	return db, nil
}

func parseUser(job JobExecution) (username string, name string) {
	if job.LaunchedBy.Username != "" {
		return job.LaunchedBy.Username, job.LaunchedBy.Name
	}
	if job.SummaryFields != nil {
		if job.SummaryFields.CreatedBy != nil && job.SummaryFields.CreatedBy.Username != "" {
			return job.SummaryFields.CreatedBy.Username, job.SummaryFields.CreatedBy.Name
		}
		if job.SummaryFields.User != nil && job.SummaryFields.User.Username != "" {
			return job.SummaryFields.User.Username, job.SummaryFields.User.Name
		}
	}
	if job.LaunchType != "" {
		return job.LaunchType, ""
	}
	return "system", ""
}

func parseErrorDiagnostics(job JobExecution) string {
	var errs []string
	if job.JobExplanation != "" {
		errs = append(errs, strings.TrimSpace(job.JobExplanation))
	}
	if job.ResultTrace != "" {
		errs = append(errs, strings.TrimSpace(job.ResultTrace))
	}
	return strings.Join(errs, " | ")
}

func saveJobRuns(ctx context.Context, db *sql.DB, runs []JobRunRecord) error {
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	query := `
	INSERT INTO job_runs (
		job_id, template_id, template_name, project_id, project_name,
		status, failed, launch_type, launched_by_username, launched_by_name,
		extra_vars, error_message, elapsed_seconds, started_at, finished_at, collected_at
	) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
	ON CONFLICT(job_id) DO UPDATE SET
		status=excluded.status,
		failed=excluded.failed,
		error_message=excluded.error_message,
		extra_vars=excluded.extra_vars,
		elapsed_seconds=excluded.elapsed_seconds,
		finished_at=excluded.finished_at,
		collected_at=excluded.collected_at;
	`

	stmt, err := tx.PrepareContext(ctx, query)
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, r := range runs {
		var startStr, finishStr *string
		if !r.StartedAt.IsZero() {
			val := r.StartedAt.UTC().Format(time.RFC3339)
			startStr = &val
		}
		if !r.FinishedAt.IsZero() {
			val := r.FinishedAt.UTC().Format(time.RFC3339)
			finishStr = &val
		}

		failedInt := 0
		if r.Failed {
			failedInt = 1
		}

		_, err := stmt.ExecContext(
			ctx,
			r.JobID,
			r.TemplateID,
			r.TemplateName,
			r.ProjectID,
			r.ProjectName,
			r.Status,
			failedInt,
			r.LaunchType,
			r.LaunchedByUsername,
			r.LaunchedByName,
			r.ExtraVars,
			r.ErrorMessage,
			r.ElapsedSeconds,
			startStr,
			finishStr,
			r.CollectedAt.UTC().Format(time.RFC3339),
		)
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func printTerminalReport(db *sql.DB) error {
	summaryQuery := `
	SELECT
		template_name,
		COUNT(*) AS total_runs,
		SUM(CASE WHEN status = 'successful' THEN 1 ELSE 0 END) AS success,
		SUM(CASE WHEN status = 'failed' OR failed = 1 THEN 1 ELSE 0 END) AS failed,
		ROUND(AVG(elapsed_seconds), 1) AS avg_sec,
		COALESCE(MAX(started_at), 'Never') AS last_run_time
	FROM job_runs
	GROUP BY template_name
	ORDER BY total_runs DESC;
	`

	rows, err := db.Query(summaryQuery)
	if err != nil {
		return err
	}
	defer rows.Close()

	fmt.Printf("\n=== AUTOMATION RUN OVERVIEW ===\n")
	fmt.Printf("%-32s | %-5s | %-7s | %-6s | %-8s | %-20s\n",
		"TEMPLATE NAME", "TOTAL", "SUCCESS", "FAILED", "AVG SEC", "LAST RUN (UTC)")
	fmt.Println(strings.Repeat("-", 90))

	for rows.Next() {
		var name, lastRun string
		var total, success, failed int
		var avgSec float64
		if err := rows.Scan(&name, &total, &success, &failed, &avgSec, &lastRun); err != nil {
			return err
		}
		fmt.Printf("%-32s | %-5d | %-7d | %-6d | %-8.1f | %-20s\n",
			name, total, success, failed, avgSec, lastRun)
	}

	userQuery := `
	SELECT template_name, launched_by_username, status, COUNT(*), MAX(started_at)
	FROM job_runs
	GROUP BY template_name, launched_by_username, status
	ORDER BY COUNT(*) DESC;
	`
	uRows, err := db.Query(userQuery)
	if err != nil {
		return err
	}
	defer uRows.Close()

	fmt.Printf("\n=== USER / STATUS BREAKDOWN ===\n")
	fmt.Printf("%-32s | %-18s | %-12s | %-5s | %-20s\n",
		"TEMPLATE NAME", "USER", "STATUS", "RUNS", "LAST EXECUTION")
	fmt.Println(strings.Repeat("-", 95))

	for uRows.Next() {
		var tName, user, status, lastRun string
		var count int
		if err := uRows.Scan(&tName, &user, &status, &count, &lastRun); err != nil {
			return err
		}
		fmt.Printf("%-32s | %-18s | %-12s | %-5d | %-20s\n",
			tName, user, status, count, lastRun)
	}

	errQuery := `
	SELECT job_id, template_name, launched_by_username, started_at, COALESCE(error_message, '')
	FROM job_runs
	WHERE (failed = 1 OR status = 'failed') AND error_message != ''
	ORDER BY started_at DESC
	LIMIT 5;
	`
	eRows, err := db.Query(errQuery)
	if err != nil {
		return err
	}
	defer eRows.Close()

	fmt.Printf("\n=== RECENT RECORDED FAILURE DIAGNOSTICS (TOP 5) ===\n")
	hasErrors := false
	for eRows.Next() {
		hasErrors = true
		var jID int
		var tName, user, startedAt, errMsg string
		if err := eRows.Scan(&jID, &tName, &user, &startedAt, &errMsg); err != nil {
			return err
		}
		fmt.Printf("• Job #%d [%s] - User: %s - Started: %s\n  Reason: %s\n",
			jID, tName, user, startedAt, errMsg)
	}
	if !hasErrors {
		fmt.Println("No system explanations or fatal tracebacks recorded for failed jobs.")
	}

	return nil
}

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

	for _, path := range envPaths {
		if err := godotenv.Load(path); err == nil {
			return nil
		}
	}
	return nil
}

func main() {
	projectFlag := flag.String("p", "", "Project Name or ID")
	dbPath := flag.String("db", "automation_metrics.db", "SQLite database file destination")
	jsonOut := flag.String("json", "", "Optional path to export raw execution details to JSON")
	debug := flag.Bool("v", false, "Verbose debug output for HTTP requests")
	reportOnly := flag.Bool("report", false, "Print summary report from local SQLite DB and exit")
	flag.Parse()

	ctx := context.Background()

	db, err := initDatabase(ctx, *dbPath)
	if err != nil {
		log.Fatalf("Error initializing SQLite database: %v", err)
	}
	defer db.Close()

	if *reportOnly {
		if err := printTerminalReport(db); err != nil {
			log.Fatalf("Error rendering report: %v", err)
		}
		return
	}

	if *projectFlag == "" {
		fmt.Println("Usage:")
		fmt.Println("  Pull from AAP:  ./aap-report -p <project-name-or-id> [-db metrics.db] [-v]")
		fmt.Println("  View Report:    ./aap-report -report [-db metrics.db]")
		os.Exit(1)
	}

	_ = loadEnvConfig()
	token := os.Getenv("AAP_TOKEN")
	if token == "" {
		log.Fatal("Fatal: Missing AAP_TOKEN environment variable")
	}

	aapURL := os.Getenv("AAP_BASE_URL")
	if aapURL == "" {
		log.Fatal("Fatal: Missing AAP_BASE_URL environment variable")
	}

	client := NewApiClient(token, aapURL, *debug)

	project, err := client.resolveProject(*projectFlag)
	if err != nil {
		log.Fatalf("Error resolving project: %v", err)
	}
	fmt.Printf("Resolved Project: %s (ID: %d)\n", project.Name, project.ID)

	templates, err := client.fetchTemplatesForProject(project.ID)
	if err != nil {
		log.Fatalf("Error fetching templates: %v", err)
	}
	fmt.Printf("Found %d job templates in project\n", len(templates))

	var allRuns []JobRunRecord
	now := time.Now().UTC()

	for _, tmpl := range templates {
		jobs, err := client.fetchExecutions(tmpl.ID)
		if err != nil {
			log.Printf("Warning: failed to fetch executions for %s (%d): %v", tmpl.Name, tmpl.ID, err)
			continue
		}

		userCounts := make(map[string]int)
		statusCounts := make(map[string]int)

		for _, j := range jobs {
			uname, fname := parseUser(j)
			userCounts[uname]++
			statusCounts[j.Status]++

			lType := j.LaunchType
			if lType == "" {
				lType = "manual"
			}

			record := JobRunRecord{
				JobID:              j.ID,
				TemplateID:         tmpl.ID,
				TemplateName:       tmpl.Name,
				ProjectID:          project.ID,
				ProjectName:        project.Name,
				Status:             j.Status,
				Failed:             j.Failed,
				LaunchType:         lType,
				LaunchedByUsername: uname,
				LaunchedByName:     fname,
				ExtraVars:          j.ExtraVars,
				ErrorMessage:       parseErrorDiagnostics(j),
				ElapsedSeconds:     j.Elapsed,
				StartedAt:          j.Started,
				FinishedAt:         j.Finished,
				CollectedAt:        now,
			}
			allRuns = append(allRuns, record)
		}

		fmt.Printf("  • %-30s | Total: %-4d | Users: %d unique | Statuses: %v\n",
			tmpl.Name, len(jobs), len(userCounts), statusCounts)
	}

	if err := saveJobRuns(ctx, db, allRuns); err != nil {
		log.Fatalf("Error saving job executions: %v", err)
	}
	fmt.Printf("\nSuccessfully saved/updated %d job run records into %s\n", len(allRuns), *dbPath)

	_ = printTerminalReport(db)

	if *jsonOut != "" {
		data, err := json.MarshalIndent(allRuns, "", "  ")
		if err != nil {
			log.Fatalf("Error marshaling to JSON: %v", err)
		}
		if err := os.WriteFile(*jsonOut, data, 0644); err != nil {
			log.Fatalf("Error writing JSON output: %v", err)
		}
		fmt.Printf("Exported JSON records to %s\n", *jsonOut)
	}
}
