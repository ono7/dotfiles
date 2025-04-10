/*
Author: jose.lima3@marriott.com
Date: 2024-07-18 16:46 CST

HTTP service for transferring Network OS images:

  - Accommodates poor file transfer client implementations (notably Cisco IOS)

  - Sets Linux system TCP parameters for the server to allow more throughput with fewer TCP ACKs and Selective ACKs

  - Lessens the amount of data that needs to be retransmitted over poor quality, high-latency links

    Features:
    1. Prevents access outside of DIRECTORY (images/)
    2. Logs all requests
    3. Logs total time it takes for a request to complete
    4. Applies TCP settings (applyTCPSettings) to accommodate high-latency, low-bandwidth WAN links
    5. Only allows GET HTTP requests
    6. run inside a jail/chroot to prevent access to other parts of the container/filesystem
*/
package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"golang.org/x/sys/unix"
)

const (
	LOG_INTERVAL = 10 // Log progress every 10%
	CHROOT_DIR   = "images"
)

func main() {

	if user := os.Getuid(); user != 0 {
		log.Fatal("this container should run as root for chroot to work..")
	}

	// TODO: rotate logs
	logFile, err := os.OpenFile("logs/server.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatalf("Error opening log file: %v", err)
	}
	defer logFile.Close()

	mw := io.MultiWriter(os.Stdout, logFile) // Write to both stdout and the file
	log.SetOutput(mw)

	port := flag.String("port", "2022", "Set TCP port to listen on")
	flag.Parse()

	// Get the absolute path of the images directory
	absImagePath, err := filepath.Abs(CHROOT_DIR)
	if err != nil {
		log.Fatalf("Failed to get absolute path of %s: %v", CHROOT_DIR, err)
	}
	log.Println("WWW_PATH:", absImagePath)

	// Ensure the images directory exists
	if err := os.MkdirAll(absImagePath, 0755); err != nil {
		log.Fatalf("Failed to create images directory: %v", err)
	}

	// Change to the images directory
	if err := os.Chdir(absImagePath); err != nil {
		log.Fatalf("Failed to change to images directory: %v", err)
	}

	// Perform chroot
	if err := syscall.Chroot(absImagePath); err != nil {
		log.Fatalf("Failed to chroot: %v", err)
	}

	// Change to root directory inside chroot
	if err := os.Chdir("/"); err != nil {
		log.Fatalf("Failed to change to root directory after chroot: %v", err)
	}

	log.Println("new chroot @ images/")

	fs := http.FileServer(http.Dir("/"))
	http.Handle("/", imageTransfer(handleRequests(fs, "/")))
	http.HandleFunc("/health", healthCheckHandler)

	listener, err := net.Listen("tcp", fmt.Sprintf(":%s", *port))
	if err != nil {
		log.Fatalf("Failed to open service port: %v", err)
	}
	defer listener.Close()

	server := &http.Server{
		ReadHeaderTimeout: 5 * time.Second,
		IdleTimeout:       120 * time.Second,
	}

	// Apply TCP connection parameters before starting the server
	applyTCPSettings(listener)

	log.Printf("Starting server on port %s serving files from %s (chrooted)...\n\n", *port, absImagePath)
	if err := server.Serve(listener); err != nil {
		log.Fatalf("Failed to start server: %s", err)
	}
}

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		w.Write([]byte("ok"))
		log.Printf("%s %s %s", r.RemoteAddr, r.Method, r.URL.Path)
	}
}

// progressWriter is a custom writer that tracks the number of bytes written
type progressWriter struct {
	http.ResponseWriter
	total        int64
	written      int64
	nextLogPoint int64
	clientIP     string
}

func (pw *progressWriter) Write(p []byte) (int, error) {
	n, err := pw.ResponseWriter.Write(p)
	pw.written += int64(n)
	pw.reportProgress()
	return n, err
}

func (pw *progressWriter) reportProgress() {
	if pw.total > 0 {
		progress := float64(pw.written) / float64(pw.total) * 100
		if pw.written >= pw.nextLogPoint {
			log.Printf("%s Progress: %.2f%% (%d/%d bytes)\n", pw.clientIP, progress, pw.written, pw.total)
			pw.nextLogPoint += int64(pw.total * LOG_INTERVAL / 100)
		}
	}
}

// imageTransfer serves files and logs transfer times and progress
func imageTransfer(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		fileInfo, err := os.Stat(filepath.Join("/", r.URL.Path))
		var total int64
		if err == nil {
			total = fileInfo.Size()
		} else {
			log.Println(err.Error())
		}

		pw := &progressWriter{
			ResponseWriter: w,
			total:          total,
			nextLogPoint:   int64(total * LOG_INTERVAL / 100),
			clientIP:       r.RemoteAddr,
		}
		next.ServeHTTP(pw, r)
		duration := time.Since(start)
		log.Printf("%s %s %s in %v\n", r.RemoteAddr, r.Method, r.URL.Path, duration)
	})
}

// handleRequests ensures the path is confined to the chroot directory
func handleRequests(next http.Handler, dir string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "GET" {
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
			return
		}

		log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL.Path)

		path := r.URL.Path
		cleanPath := filepath.Clean(path)
		if !strings.HasPrefix(cleanPath, "/") {
			cleanPath = "/" + cleanPath
		}

		fullPath := filepath.Join(dir, cleanPath)
		if !strings.HasPrefix(fullPath, dir) {
			http.Error(w, "Forbidden", http.StatusForbidden)
			return
		}

		next.ServeHTTP(w, r)
	})
}

// Optimize for slow WAN links with high latency, settings/syscalls are OS-specific and
// *** THIS IS SPECIFIC TO THE OS API/SYSCALLS - Linux, MacOS, and Windows ***
func applyTCPSettings(listener net.Listener) {
	border := strings.Repeat("*", 40)

	log.Println(border)
	defer log.Println(border)

	tcpClampSize := 65535

	file, err := listener.(*net.TCPListener).File()
	if err != nil {
		log.Fatalf("Failed to get listener file: %v", err)
	}
	defer file.Close()

	// Enable SaCK (Selective Acknowledgments)
	if err := syscall.SetsockoptInt(int(file.Fd()), syscall.IPPROTO_TCP, unix.TCPOPT_SACK, 1); err != nil {
		log.Fatalf("Failed to enable SaCK: %v", err)
	}
	log.Println("TCP SaCK enabled")

	// Set and clamp the receive buffer size (indirectly controls window size)
	if err := syscall.SetsockoptInt(int(file.Fd()), syscall.SOL_SOCKET, syscall.SO_RCVBUF, tcpClampSize); err != nil {
		log.Fatalf("Failed to set SO_RCVBUF: %v", err)
	}

	// Negotiate better clamp size for high latency links
	if err := syscall.SetsockoptInt(int(file.Fd()), syscall.IPPROTO_TCP, syscall.TCP_WINDOW_CLAMP, tcpClampSize); err != nil {
		log.Fatalf("Failed to set TCP_WINDOW_CLAMP: %v", err)
	}
	log.Println("TCP Window Clamp set to", tcpClampSize)
}
