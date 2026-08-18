package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"time"
)

type IndexedLine struct {
	OriginalIndex int
	Text          string
}

// Helper function to get absolute value
func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func main() {
	// Ensure the user provides exactly one file argument
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run shuffle_csv.go <your_file.csv>")
		os.Exit(1)
	}

	filepath := os.Args[1]

	// Read all lines from the file
	file, err := os.Open(filepath)
	if err != nil {
		fmt.Printf("Error: Could not open '%s'.\n", filepath)
		os.Exit(1)
	}

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	file.Close() // Close as soon as we finish reading

	if err := scanner.Err(); err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		os.Exit(1)
	}

	if len(lines) == 0 {
		fmt.Println("Error: The file is empty.")
		os.Exit(1)
	}

	// Separate the header from the data
	header := lines[0]
	dataLines := lines[1:]
	n := len(dataLines)

	// Mathematically require at least 4 data lines to guarantee no original neighbors touch
	if n < 4 {
		fmt.Println("Error: The file must have a header and at least 4 data rows to ensure a valid shuffle.")
		os.Exit(1)
	}

	// Keep track of each data line's original index
	indexedLines := make([]IndexedLine, n)
	for i, text := range dataLines {
		indexedLines[i] = IndexedLine{OriginalIndex: i, Text: text}
	}

	attempts := 0
	fmt.Printf("Shuffling %d data rows (leaving header untouched)...\n", n)

	// Seed the random number generator
	rng := rand.New(rand.NewSource(time.Now().UnixNano()))

	for {
		attempts++
		rng.Shuffle(n, func(i, j int) {
			indexedLines[i], indexedLines[j] = indexedLines[j], indexedLines[i]
		})

		// Verify no two data rows in the new list were adjacent in the original file
		conflict := false
		for i := 0; i < n-1; i++ {
			if abs(indexedLines[i].OriginalIndex-indexedLines[i+1].OriginalIndex) <= 1 {
				conflict = true
				break
			}
		}

		if !conflict {
			fmt.Printf("Success! Perfect non-adjacent shuffle found in %d attempt(s).\n", attempts)
			break
		}
	}

	// Write the header and the perfectly shuffled lines back to the ORIGINAL file
	// os.Create truncates the existing file so we can overwrite it cleanly
	outFile, err := os.Create(filepath)
	if err != nil {
		fmt.Printf("Error: Could not open '%s' for writing.\n", filepath)
		os.Exit(1)
	}
	defer outFile.Close()

	writer := bufio.NewWriter(outFile)
	fmt.Fprintln(writer, header)
	for _, item := range indexedLines {
		fmt.Fprintln(writer, item.Text)
	}
	writer.Flush()

	fmt.Printf("File '%s' has been successfully updated.\n", filepath)
}
