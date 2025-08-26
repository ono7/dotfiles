/*
Author:  Jose Lima
Date:    2024-09-06  11:31
*/
package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"syscall"

	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func main() {

	if os.Getuid() != 0 {
		log.Fatal("chroot requires this program to run as root, please start the container as root")
	}

	logFile, err := os.OpenFile("logs/server.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatalf("Error opening log file: %v", err)
	}
	defer logFile.Close()

	mw := io.MultiWriter(os.Stdout, logFile) // Write to both stdout and the file
	log.SetOutput(mw)

	key := os.Getenv("SSH_KEY")
	if key == "" {
		log.Fatal("inject SSH KEY as a string using SSH_KEY environment var")
	}

	signer, err := ssh.ParsePrivateKey([]byte(key))
	if err != nil {
		panic(fmt.Errorf("invalid SSH PEM key, %s", err.Error()))
	}

	// Get username and password from environment variables or use defaults
	username := getEnvOrDefault("SFTP_USER", "getfiles")
	password := getEnvOrDefault("SFTP_PASS", "welcome!")

	if err := syscall.Chroot("images"); err != nil {
		log.Fatalf("Chroot failed: %v", err)
	}

	if err := os.Chdir("/"); err != nil {
		log.Fatalf("Chdir failed: %v", err)
	}

	log.Println("Running inside a chroot, app is now lockdown to images/", getCwd())

	config := &ssh.ServerConfig{
		PasswordCallback: func(c ssh.ConnMetadata, pass []byte) (*ssh.Permissions, error) {
			if c.User() == username && string(pass) == password {
				return nil, nil
			}
			return nil, fmt.Errorf("password rejected for %q", c.User())
		},
	}
	config.AddHostKey(signer)

	listener, err := net.Listen("tcp", "0.0.0.0:2022")
	if err != nil {
		log.Fatalf("failed to listen on port 2022: %v", err)
	}
	defer listener.Close()

	log.Println("SFTP server listening on port 2022...")

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("failed to accept connection: %v", err)
			continue
		}
		go handleConnection(conn, config)
	}
}

func handleConnection(conn net.Conn, config *ssh.ServerConfig) {
	sshConn, channels, requests, err := ssh.NewServerConn(conn, config)
	if err != nil {
		log.Printf("failed to handshake %v: %v", conn.RemoteAddr(), err)
		return
	}
	defer sshConn.Close()

	go ssh.DiscardRequests(requests)

	for ch := range channels {
		go handleChannel(ch)
		log.Printf("Request received from: %s", conn.RemoteAddr())
	}
}

func handleChannel(ch ssh.NewChannel) {
	if ch.ChannelType() != "session" {
		ch.Reject(ssh.UnknownChannelType, "unknown channel type")
		return
	}

	channel, _, err := ch.Accept()
	if err != nil {
		log.Printf("could not accept channel: %v", err)
		return
	}
	defer channel.Close()

	server, err := sftp.NewServer(
		channel,
		sftp.ReadOnly(),
	)
	if err != nil {
		log.Printf("failed to create SFTP server: %v", err)
		return
	}
	defer server.Close()

	if err := server.Serve(); err != nil {
		log.Printf("failed to serve SFTP requests: %v", err)
	}
}

func getEnvOrDefault(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

func getCwd() string {
	cwd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Failed to get current working directory: %v", err)
	}
	return cwd
}
