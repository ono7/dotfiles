// # Build the tool
// go build -o text2hex text2hex.go
//
// # Basic text to hex (default little-endian)
// echo "ABC" | ./text2hex
// # Output: b"\x41\x42\x43\x0a"
//
// # Convert numbers to hex
// echo "65 66 67" | ./text2hex -n
// # Output: b"\x41\x42\x43"
//
// # 32-bit little-endian numbers
// echo "0x41424344" | ./text2hex -n -w 4
// # Output: b"\x44\x43\x42\x41"
//
// # Big-endian mode
// echo "0x41424344" | ./text2hex -n -w 4 -be
// # Output: b"\x41\x42\x43\x44"
//
// # Custom prefix/suffix for different languages
// echo "test" | ./text2hex -p "\\x" -s ""
// # Output: \x74\x65\x73\x74\x0a
package main

import (
	"bufio"
	"encoding/binary"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	var (
		bigEndian    = flag.Bool("be", false, "Use big-endian byte order")
		// littleEndian = flag.Bool("le", true, "Use little-endian byte order (default)")
		wordSize     = flag.Int("w", 1, "Word size in bytes (1, 2, 4, 8)")
		prefix       = flag.String("p", "b\"", "Prefix for output")
		suffix       = flag.String("s", "\"", "Suffix for output")
		separator    = flag.String("sep", "", "Separator between hex values")
		numbers      = flag.Bool("n", false, "Treat input as space-separated numbers instead of text")
	)
	flag.Parse()

	// Read from stdin
	scanner := bufio.NewScanner(os.Stdin)
	var input strings.Builder

	for scanner.Scan() {
		input.WriteString(scanner.Text())
		if !*numbers {
			input.WriteString("\n")
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error reading input: %v\n", err)
		os.Exit(1)
	}

	inputText := strings.TrimRight(input.String(), "\n")

	var hexOutput strings.Builder
	hexOutput.WriteString(*prefix)

	if *numbers {
		// Parse input as numbers
		fields := strings.Fields(inputText)
		for i, field := range fields {
			if i > 0 && *separator != "" {
				hexOutput.WriteString(*separator)
			}

			num, err := strconv.ParseUint(field, 0, 64)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error parsing number '%s': %v\n", field, err)
				os.Exit(1)
			}

			hexBytes := numberToHex(num, *wordSize, *bigEndian)
			for _, b := range hexBytes {
				hexOutput.WriteString(fmt.Sprintf("\\x%02x", b))
			}
		}
	} else {
		// Process as text
		data := []byte(inputText)

		if *wordSize == 1 {
			// Byte-by-byte conversion
			for i, b := range data {
				if i > 0 && *separator != "" {
					hexOutput.WriteString(*separator)
				}
				hexOutput.WriteString(fmt.Sprintf("\\x%02x", b))
			}
		} else {
			// Multi-byte word conversion
			for i := 0; i < len(data); i += *wordSize {
				if i > 0 && *separator != "" {
					hexOutput.WriteString(*separator)
				}

				// Pad with zeros if needed
				word := make([]byte, *wordSize)
				copy(word, data[i:])

				if *bigEndian {
					for _, b := range word {
						hexOutput.WriteString(fmt.Sprintf("\\x%02x", b))
					}
				} else {
					for j := len(word) - 1; j >= 0; j-- {
						hexOutput.WriteString(fmt.Sprintf("\\x%02x", word[j]))
					}
				}
			}
		}
	}

	hexOutput.WriteString(*suffix)
	fmt.Print(hexOutput.String())
}

func numberToHex(num uint64, wordSize int, bigEndian bool) []byte {
	buf := make([]byte, 8)

	switch wordSize {
	case 1:
		return []byte{byte(num)}
	case 2:
		if bigEndian {
			binary.BigEndian.PutUint16(buf, uint16(num))
		} else {
			binary.LittleEndian.PutUint16(buf, uint16(num))
		}
		return buf[:2]
	case 4:
		if bigEndian {
			binary.BigEndian.PutUint32(buf, uint32(num))
		} else {
			binary.LittleEndian.PutUint32(buf, uint32(num))
		}
		return buf[:4]
	case 8:
		if bigEndian {
			binary.BigEndian.PutUint64(buf, num)
		} else {
			binary.LittleEndian.PutUint64(buf, num)
		}
		return buf[:8]
	default:
		return []byte{byte(num)}
	}
}
