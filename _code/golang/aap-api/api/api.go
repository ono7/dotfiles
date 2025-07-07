/*
endpoints:

	update project: /api/v2/projects/$PROJECT_ID/update/
	get projects: /api/v2/projects
*/
package api

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"strings"
	"time"
	"unicode"
)

type PaginatedResponse struct {
	Count    int     `json:"count"`
	Next     *string `json:"next"`
	Previous *string `json:"previous"`
	Results  []repo  `json:"results"`
}

type results struct {
	Results  []repo  `json:"results"`
	Count    int     `json:"count"`
	Next     *string `json:"next"`
	Previous *string `json:"previous"`
	// Results []map[string]interface{} `json:"results"`
}

type repo struct {
	ScmUrl      string    `json:"scm_url"`
	Id          int       `json:"id"`
	LastUpdated time.Time `json:"last_updated"`
	Name        string    `json:"name"`
}

type authTransport struct {
	Transport http.RoundTripper
	AuthToken string
}

func (t *authTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Add("Authorization", "Bearer "+t.AuthToken)
	req.Header.Set("Content-Type", "application/json")
	return t.Transport.RoundTrip(req)
}

// tries to resolve git remote url from local dir
// TODO: allow passing directory for ondemand lookup
func GetRepoUrl() string {
	cmd := exec.Command("git", "config", "--get", "remote.origin.url")
	cmdout, err := cmd.Output()
	if err != nil {
		log.Fatal("GetRepoUrl: Unable to get remote.origin.url, are you in a git repo? ")
	}
	if string(cmdout) == "" {
		log.Fatal("no remote.origin.url configured")
	}

	return string(cmdout)
}

func CleanString(s string) string {
	return strings.Join(strings.FieldsFunc(s, func(r rune) bool {
		return unicode.IsSpace(r) || r == '\n' || r == '\t'
	}), " ")
}

// GetRepoSuffix should return the Org/Project.git as the element name
func GetRepoSuffix(repourl string) string {

	// url = https://git.homeet.local/Network-DevOps/iac_sdwan_config_mgmt.git
	// url = git@github.com:ono7/dotfiles.git

	if strings.HasPrefix(repourl, "git@") {
		return strings.Split(repourl[4:], `:`)[1]
	} else if strings.HasPrefix(repourl, "http") {
		pre := strings.Split(repourl, `/`)
		parsed := strings.Join(pre[len(pre)-2:], "/")
		return parsed
	} else {
		log.Fatalf("Invalid URL: %v", repourl)
	}
	return ""
}

// takes an interface/any and returns a json payload
// used for client.Port() body
func Marshall(d any) (*bytes.Buffer, error) {
	jsonbody, err := json.Marshal(d)
	if err != nil {
		log.Fatal("Marshall error:", err)
	}
	return bytes.NewBuffer(jsonbody), nil
}

type Api struct {
	Repos      []repo
	Host       string
	BaseUrl    string
	Client     *http.Client
	RepoSuffix string
}

func NewApi(token, hostname string) *Api {
	c := &http.Client{
		Transport: &authTransport{
			Transport: http.DefaultTransport,
			AuthToken: token,
		},
	}
	return &Api{Host: hostname, Client: c, BaseUrl: "https://" + hostname}
}

func (a *Api) SetLocalRepo() {
	repourl := CleanString(GetRepoUrl())
	element := GetRepoSuffix(repourl)
	log.Println("Repo:", element)
	a.RepoSuffix = element
}

// Get all projects in AAP, deals with API paging
func (a *Api) GetAllProjects() {
	log.Println("Fetching projects ➜ AAP")

	nextURL := "/api/v2/projects"

	for nextURL != "" {
		resp, err := a.Client.Get(a.BaseUrl + nextURL)
		if err != nil {
			log.Fatal("a.Client.Get err:", err)
		}
		defer resp.Body.Close()

		var pageResp PaginatedResponse
		if err := json.NewDecoder(resp.Body).Decode(&pageResp); err != nil {
			log.Fatal("json.NewDecorder", err)
		}

		a.Repos = append(a.Repos, pageResp.Results...)

		if pageResp.Next == nil {
			break
		}
		nextURL = *pageResp.Next
	}
}

func (a *Api) ShowRepos() {
	// out, err := json.MarshalIndent(projects, " ", "   ")
	// if err != nil {
	// 	log.Fatal("MarshalIndent err:", err)
	// }
	if len(a.Repos) == 0 {
		a.GetAllProjects()
	}
	sep := strings.Repeat(`*`, 30)
	fmt.Println(sep, "AAP Projects", sep)
	for _, p := range a.Repos {
		fmt.Println()
		fmt.Printf("Project: %s, ID: %d\n", p.Name, p.Id)
		fmt.Println("URL:", p.ScmUrl)
		fmt.Println("LastUpdate:", p.LastUpdated)
	}
}

func (a *Api) GetWithPattern(pattern string) {
	log.Println("GetWithPattern: to implement")
}

func (a *Api) UpdateProjectID(id int) int {
	url := fmt.Sprintf("%s/api/v2/projects/%d/update/", a.BaseUrl, id)
	payload := map[string]string{
		"launch_type": "manual",
	}
	p, err := Marshall(payload)
	if err != nil {
		log.Fatal("Marshall err:", err)
	}
	resp, err := a.Client.Post(url, "application/json", p)
	if err != nil {
		log.Fatal("a.Client.Post", err)
	}
	if resp.StatusCode != 202 {
		log.Fatalf("oh... we recieved status %v from the aap api.....oops", resp.StatusCode)
	}
	return resp.StatusCode
}

func (a *Api) UpdateLocalRepo() {
	var found bool
	if a.RepoSuffix == "" {
		a.SetLocalRepo()
	}
	if len(a.Repos) == 0 {
		a.GetAllProjects()
	}
	for _, v := range a.Repos {
		if strings.Contains(v.ScmUrl, a.RepoSuffix) {
			statusCode := a.UpdateProjectID(v.Id)
			found = true
			if statusCode == 202 {
				log.Printf("AAP ➜ Project Sync Request Accepted - ID: %v, %s  ", v.Id, v.Name)
			}
		}
	}
	if !found {
		log.Printf("No projects in AAP match our repo %s\n", a.RepoSuffix)
	}
}
