package main

import (
	"encoding/csv"
	"fmt"
	"os"
)

type Host struct {
	hostname string
	ip       string
	key      string
}

func createGroup(records *[][]string) []Host {
	group := make([]Host, 0)
	m := make(map[string]*Host)

	// Create a new slice to hold remaining records
	remainingRecords := make([][]string, 0)

	for i, record := range *records {
		host := &Host{
			hostname: record[0],
			ip:       record[1],
			key:      record[0][:5],
		}

		if _, ok := m[host.key]; !ok {
			m[host.key] = host
			group = append(group, *host)
		} else {
			// If we're not using this record for a new host, keep it
			remainingRecords = append(remainingRecords, (*records)[i])
		}
	}

	// Update the original records slice with remaining records
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
		fmt.Println(g)
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
