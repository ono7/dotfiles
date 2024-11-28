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

func createGroup(records *[][]string) []Host _	group := make([]Host, 0) // Initialize an empty slice to hold Hosts
	m := make(map[string]*Host)

	for i, record := range *records {
		host := &Host{
			hostname: record[0],
			ip:       record[1],
			key:      record[0][:5],
		}

		if _, ok := m[host.key]; !ok {
			m[host.key] = host
			group = append(group, *host) // Append the Host to the group slice
		}
        *records = *
	}

	return group
}

func main() {

	// Path to your CSV file
	csvFilePath := "hosts.csv"
	records, err := readCSV(csvFilePath)
	if err != nil {
		panic(err)
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
