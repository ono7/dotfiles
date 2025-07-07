package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"sync"
	"time"
)

type PingMonitor struct {
	target     string
	failures   int
	lastStatus bool
	logger     *log.Logger
	mu         sync.Mutex
}

func NewPingMonitor(target string, logger *log.Logger) *PingMonitor {
	return &PingMonitor{
		target:     target,
		failures:   0,
		lastStatus: true,
		logger:     logger,
	}
}

func (pm *PingMonitor) ping() bool {
	conn, err := net.DialTimeout("ip4:icmp", pm.target, 3*time.Second)
	if err != nil {
		// Fallback to TCP ping if ICMP fails (might need privileges)
		conn, err := net.DialTimeout("tcp", pm.target+":53", 3*time.Second)
		if err != nil {
			return false
		}
		conn.Close()
		return true
	}
	conn.Close()
	return true
}

func (pm *PingMonitor) tcpPing() bool {
	// Use TCP ping to port 53 (DNS) for more reliable results without requiring root
	conn, err := net.DialTimeout("tcp", pm.target+":53", 3*time.Second)
	if err != nil {
		return false
	}
	conn.Close()
	return true
}

func (pm *PingMonitor) monitor() {
	// TODO(jlima): make this time a constant
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		pm.mu.Lock()

		success := pm.tcpPing()

		if !success {
			pm.failures++

			if pm.failures >= 2 && pm.lastStatus {
				pm.logger.Printf("ALERT: %s is unreachable - 2 consecutive ping failures detected", pm.target)
				pm.lastStatus = false
			} else if pm.failures == 1 {
				pm.logger.Printf("WARNING: %s ping failed (failure count: %d)", pm.target, pm.failures)
			}
		} else {
			if !pm.lastStatus && pm.failures >= 2 {
				pm.logger.Printf("RECOVERY: %s is now reachable again after %d failures", pm.target, pm.failures)
			} else if pm.failures > 0 {
				pm.logger.Printf("INFO: %s ping restored", pm.target)
			}

			pm.failures = 0
			pm.lastStatus = true
		}

		pm.mu.Unlock()
	}
}

func main() {
	// Create or open log file
	logFile, err := os.OpenFile("network_monitor.log",
		os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		fmt.Printf("Error opening log file: %v\n", err)
		os.Exit(1)
	}
	defer logFile.Close()

	// Create multi-writer to write to both stdout and log file
	multiWriter := io.MultiWriter(os.Stdout, logFile)

	// Create logger with timestamp that writes to both destinations
	logger := log.New(multiWriter, "LOG: ", log.LstdFlags)

	// Log startup
	logger.Println("Network monitor started - monitoring 8.8.8.8 and 100.64.0.1")
	logger.Println("Pinging every 1 seconds. Press Ctrl+C to stop.")

	// TODO(jlima): make this take arglist instead of static
	monitor1 := NewPingMonitor("8.8.8.8", logger)
	monitor2 := NewPingMonitor("100.64.0.1", logger)

	// Start monitoring in separate goroutines
	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		monitor1.monitor()
	}()

	go func() {
		defer wg.Done()
		monitor2.monitor()
	}()

	// Wait for goroutines (they run indefinitely)
	wg.Wait()
}
