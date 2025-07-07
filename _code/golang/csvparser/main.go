package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"os"
)

type Host struct {
	Hostname string `json:"hostname"`
	IP       string `json:"ip"`
	Key      string `json:"key"`
}

func createGroup(records *[][]string) []Host {
	group := make([]Host, 0)
	m := make(map[string]*Host)
	remainingRecords := make([][]string, 0)

	for i, record := range *records {
		host := &Host{
			Hostname: record[0],
			IP:       record[1],
			Key:      record[0][:5],
		}

		if _, ok := m[host.Key]; !ok {
			m[host.Key] = host
			group = append(group, *host)

			if len(group) == 15 {
				// When we hit 15 items, keep all remaining records including current index
				// this will first dereference the *records, then perform slice operation
				*records = (*records)[i+1:]
				return group
			}
		} else {
			remainingRecords = append(remainingRecords, record)
		}
	}

	*records = remainingRecords
	return group
}

func main() {

	// Path to your CSV file
	csvFilePath := "hosts.csv"
	records, err := readCSV(csvFilePath)
	if err != nil {
		panic(err)
	}

	groups := make([][]Host, 500)

	for len(records) > 0 {
		group := createGroup(&records)
		groups = append(groups, group)
	}

	for _, g := range groups {
		if len(g) == 0 {
			continue
		}
		fmt.Printf("************************* %d ****************\n", len(g))
		jsonData, err := json.MarshalIndent(g, "", "    ")
		if err != nil {
			fmt.Println("Error marshaling JSON:", err)
			continue
		}

		// Print the JSON string
		fmt.Println(string(jsonData))
	}

}

// readCSV reads a CSV file and returns its contents as a slice of slices.
func readCSV(filePath string) ([][]string, error) {
	// Open the CSV file for reading
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to open CSV file: %v", err)
	}
	defer file.Close()

	// Create a new CSV reader that reads from the file
	reader := csv.NewReader(file)

	// Read all records from the CSV file
	records, err := reader.ReadAll()
	if err != nil {
		return nil, fmt.Errorf("failed to read CSV data: %v", err)
	}

	return records, nil
}
