## collection of usefull reusable functions in golang

```go

func MakeRequest(url, token string) (*http.Response, error) {
	client := &http.Client{}
	client.Timeout = 10 * time.Second
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Add("Authorization", "Bearer "+token)
	req.Header.Add("Content-Type", "application/json")
	return client.Do(req)
}


func GetAllPages(apiEndpoint, token string) ([]repo, error) {
	// var allResults []json.RawMessage
	var projects []repo

	baseUrl := os.Getenv("AAP_BASE_URL")
	IsEmpty("GetAllPages", baseUrl)

	url := fmt.Sprintf("https://%s", baseUrl)

	// TODO: do a check to make sure this is valid
	nextURL := apiEndpoint

	log.Println(url + nextURL)
	for nextURL != "" {
		// log.Printf("API GET: %s", nextURL)
		resp, err := MakeRequest(url+nextURL, token)
		if err != nil {
			return nil, fmt.Errorf("error making request: %w", err)
		}
		defer resp.Body.Close()

		var pageResp PaginatedResponse
		if err := json.NewDecoder(resp.Body).Decode(&pageResp); err != nil {
			return nil, fmt.Errorf("error unmarshaling JSON: %w", err)
		}

		projects = append(projects, pageResp.Results...)

		if pageResp.Next == nil {
			break
		}
		nextURL = *pageResp.Next
	}
	return projects, nil
}

// MakeGet handles errors and returns only response when valid
func MakeGet(url, token string, payload interface{}) *http.Response {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatal("error in ApiGet:", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")

	log.Printf("Calling %s", url)

	resp, err := client.Do(req)
	if err != nil {
		log.Fatal("client.Do(): ", err)
	}
	if resp.StatusCode != 200 {
		log.Fatalf("status %v, invalid api response %v", resp.StatusCode, resp)
	}
	log.Printf("Status: %v", resp.StatusCode)
	return resp
}

func CheckErr(s string, e error) {
	if e != nil {
		log.Fatalf("%s: %s", s, e)
	}
}

func IsEmpty(value, name string) {
	if value == "" {
		log.Fatalf("ENV: $%s not set", name)
	}
}

// PrettyPrinter returns nicely formatted json string
func PrettyPrinter(m any) {
	if m == nil {
		log.Fatal("PrettyPrinter: Empty data structure")
	}
	prettyJSON, err := json.MarshalIndent(m, "", "  ")
	if err != nil {
		log.Fatalf("Failed to generate pretty JSON: %v", err)
	}
	fmt.Println(string(prettyJSON))
}

```
