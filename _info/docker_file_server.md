```go

package main

import (
  "crypto/ecdsa"
  "crypto/elliptic"
  "crypto/rand"
  "crypto/x509"
  "crypto/x509/pkix"
  "encoding/base64"
  "encoding/csv"
  "encoding/json"
  "encoding/pem"
  "html/template"
  "io"
  "log"
  "math/big"
  "net/http"
  "os"
  "path/filepath"
  "sort"
  "strings"
  "sync"
  "time"
)

const (
  port      = ":8443"
  certFile  = "server.crt"
  keyFile   = "server.key"
  reportDir = "./reports"
  publicDir = "./public"
)

type CSVRequest struct {
  Data     string `json:"data"`
  Filename string `json:"filename"`
}

type FileEntry struct {
  Name     string
  ModTime  time.Time
  RowCount int
}

var fsMutex sync.Mutex

func main() {
  adminUser := getEnv("POST_USER", "test")
  adminPass := getEnv("POST_PASS", "test")

  viewUser := getEnv("VIEWER_USER", "test")
  viewPass := getEnv("VIEWER_PASS", "test")

  os.MkdirAll(reportDir, 0755)
  os.MkdirAll(publicDir, 0755)

  if err := generateCertificate(); err != nil {
    log.Fatalf("Failed to generate certificate: %v", err)
  }

  // 1. Serve Static Files
  fs := http.FileServer(http.Dir(publicDir))
  http.Handle("/public/", http.StripPrefix("/public/", fs))

  // 2. Register Routes
  http.HandleFunc("/csv", basicAuth(adminUser, adminPass, csvHandler))
  http.HandleFunc("/reports", basicAuth(viewUser, viewPass, reportsHandler))

  log.Printf("Server starting on https://localhost%s", port)
  log.Fatal(http.ListenAndServeTLS(port, certFile, keyFile, nil))
}

func reportsHandler(w http.ResponseWriter, r *http.Request) {
  if r.Method != http.MethodGet {
    http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    return
  }

  // Handle file download
  filename := r.URL.Query().Get("file")
  if filename != "" {
    cleanName := filepath.Base(filename)
    safePath := filepath.Join(reportDir, cleanName)
    if _, err := os.Stat(safePath); os.IsNotExist(err) {
      http.Error(w, "File not found", http.StatusNotFound)
      return
    }
    w.Header().Set("Content-Type", "text/csv")
    w.Header().Set("Content-Disposition", "attachment; filename="+cleanName)
    http.ServeFile(w, r, safePath)
    return
  }

  search := strings.ToLower(r.URL.Query().Get("search"))

  // 2. Read and Filter Files
  entries, err := os.ReadDir(reportDir)
  if err != nil {
    http.Error(w, "Failed to read directory", http.StatusInternalServerError)
    return
  }

  var files []FileEntry
  for _, entry := range entries {
    if !entry.IsDir() && strings.HasSuffix(entry.Name(), ".csv") {
      if search != "" && !strings.Contains(strings.ToLower(entry.Name()), search) {
        continue
      }

      info, err := entry.Info()
      if err == nil {
        // Calculate rows
        count := countCSVRows(filepath.Join(reportDir, entry.Name()))

        files = append(files, FileEntry{
          Name:     entry.Name(),
          ModTime:  info.ModTime(),
          RowCount: count,
        })
      }
    }
  }

  sort.Slice(files, func(i, j int) bool {
    return files[i].ModTime.After(files[j].ModTime)
  })

  const tplStr = `
{{define "tbody"}}
  <tbody id="file-list"
       hx-get="/reports"
       hx-trigger="every 2s"
       hx-swap="outerHTML"
       hx-include="[name='search']">
  {{range .}}
    <tr>
      <th scope="row"><a href="/reports?file={{.Name}}">{{.Name}}</a></th>
      <td>{{.RowCount}}</td>
      <td>{{.ModTime.Format "Jan 02 15:04:05"}}</td>
    </tr>
  {{else}}
    <tr>
      <td colspan="3" style="text-align:center; color: #888;">No files found</td>
    </tr>
  {{end}}
  </tbody>
{{end}}

{{define "page"}}
<!DOCTYPE html>
<html data-theme="light">
<head>
  <title>Welcome</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="public/css/css/pico.min.css">
  <script src="public/htmx.min.js"></script>
  <style>
    body { padding-top: 2rem; }
    th[scope="row"] a { font-weight: bold; text-decoration: none; }
    th[scope="row"] a:hover { text-decoration: underline; }
    input[type="search"] { margin-bottom: 1.5rem; }
  </style>
</head>
<body>
  <main class="container">
    <h1>Network DevOps automation reports</h1>

    <input type="search"
         name="search"
         placeholder="Filter files..."
         hx-get="/reports"
         hx-trigger="keyup changed delay:200ms, search"
         hx-target="#file-list"
         hx-swap="outerHTML">

    <figure>
      <table>
        <thead>
          <tr>
            <th scope="col">Filename</th>
            <th scope="col">Rows</th>
            <th scope="col">Uploaded</th>
          </tr>
        </thead>
        {{template "tbody" .}}
      </table>
    </figure>
  </main>
</body>
</html>
{{end}}`

  tmpl := template.Must(template.New("base").Parse(tplStr))

  w.Header().Set("Content-Type", "text/html")

  if r.Header.Get("HX-Request") == "true" {
    tmpl.ExecuteTemplate(w, "tbody", files)
  } else {
    tmpl.ExecuteTemplate(w, "page", files)
  }
}

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------

// countCSVRows reads the file and returns the number of records minus 1 (header).
// Returns 0 if the file cannot be read or has only a header.
func countCSVRows(path string) int {
  f, err := os.Open(path)
  if err != nil {
    return 0
  }
  defer f.Close()

  r := csv.NewReader(f)
  r.ReuseRecord = true // Optimization: reuse the backing array

  count := 0
  for {
    _, err := r.Read()
    if err == io.EOF {
      break
    }
    if err != nil {
      return 0 // Stop counting on malformed CSV
    }
    count++
  }

  if count > 1 {
    return count - 1
  }
  return 0
}

func basicAuth(username, password string, next http.HandlerFunc) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    user, pass, ok := r.BasicAuth()
    if !ok || user != username || pass != password {
      w.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
      http.Error(w, "Unauthorized", http.StatusUnauthorized)
      return
    }
    next(w, r)
  }
}

func csvHandler(w http.ResponseWriter, r *http.Request) {
  if r.Method != http.MethodPost {
    http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    return
  }

  var req CSVRequest
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
    http.Error(w, "Invalid JSON", http.StatusBadRequest)
    return
  }

  // 1. Decode Base64
  decodedBytes, err := base64.StdEncoding.DecodeString(req.Data)
  if err != nil {
    http.Error(w, "Invalid base64 data", http.StatusBadRequest)
    return
  }

  cleanName := filepath.Base(req.Filename)
  if cleanName == "." || cleanName == "/" || !strings.HasSuffix(cleanName, ".csv") {
    http.Error(w, "Invalid filename", http.StatusBadRequest)
    return
  }

  // 2. Read decoded data
  reader := csv.NewReader(strings.NewReader(string(decodedBytes)))
  records, err := reader.ReadAll()
  if err != nil || len(records) == 0 {
    http.Error(w, "Invalid or empty CSV data", http.StatusBadRequest)
    return
  }

  safePath := filepath.Join(reportDir, cleanName)

  fsMutex.Lock()
  defer fsMutex.Unlock()

  file, err := os.Create(safePath)
  if err != nil {
    http.Error(w, "Failed to create file", http.StatusInternalServerError)
    return
  }
  defer file.Close()

  if err := csv.NewWriter(file).WriteAll(records); err != nil {
    http.Error(w, "Failed to write CSV", http.StatusInternalServerError)
    return
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(map[string]string{
    "message":  "CSV file created successfully",
    "filename": cleanName,
  })
}

func getEnv(key, fallback string) string {
  if value, exists := os.LookupEnv(key); exists {
    return value
  }
  return fallback
}

func generateCertificate() error {
  if _, err := os.Stat(certFile); err == nil {
    if _, err := os.Stat(keyFile); err == nil {
      log.Println("Using existing certificate")
      return nil
    }
  }
  log.Println("Generating self-signed certificate...")
  priv, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
  if err != nil {
    return err
  }
  notBefore := time.Now()
  notAfter := notBefore.Add(965 * 24 * time.Hour)
  serialNumber, err := rand.Int(rand.Reader, new(big.Int).Lsh(big.NewInt(1), 128))
  if err != nil {
    return err
  }
  template := x509.Certificate{
    SerialNumber: serialNumber,
    Subject: pkix.Name{
      Organization: []string{"CSV Server"},
    },
    NotBefore:             notBefore,
    NotAfter:              notAfter,
    KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
    ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
    BasicConstraintsValid: true,
    DNSNames:              []string{"localhost"},
  }
  derBytes, err := x509.CreateCertificate(rand.Reader, &template, &template, &priv.PublicKey, priv)
  if err != nil {
    return err
  }
  certOut, err := os.Create(certFile)
  if err != nil {
    return err
  }
  defer certOut.Close()
  if err := pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: derBytes}); err != nil {
    return err
  }
  keyOut, err := os.Create(keyFile)
  if err != nil {
    return err
  }
  defer keyOut.Close()
  privBytes, err := x509.MarshalECPrivateKey(priv)
  if err != nil {
    return err
  }
  if err := pem.Encode(keyOut, &pem.Block{Type: "EC PRIVATE KEY", Bytes: privBytes}); err != nil {
    return err
  }
  log.Println("Certificate generated successfully")
  return nil
}

```
