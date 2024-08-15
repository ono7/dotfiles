// test
package main

import (
	"log"
	"net"
	"os"

	"golang.org/x/crypto/ssh"

	"github.com/pkg/sftp"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	// Load the private key for SSH server authentication
	privateKeyPath := "id_rsa"
	key, err := os.ReadFile(privateKeyPath)
	if err != nil {
		log.Fatalf("failed to read private key: %v", err)
	}

	signer, err := ssh.ParsePrivateKey(key)
	if err != nil {
		log.Fatalf("failed to parse private key: %v", err)
	}

	// Create SSH server configuration
	config := &ssh.ServerConfig{
		NoClientAuth: true, // no client authentication
	}
	config.AddHostKey(signer)

	// Listen for incoming connections
	listener, err := net.Listen("tcp", ":2022") // Listening on port 2022
	if err != nil {
		log.Fatalf("failed to listen on port 2022: %v", err)
	}
	defer listener.Close()

	log.Println("SFTP server listening on port 2022...")

	for {
		// Accept incoming connections
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("failed to accept connection: %v", err)
			continue
		}

		// Handle each connection in a separate goroutine
		go handleConnection(conn, config)
	}
}

func handleConnection(conn net.Conn, config *ssh.ServerConfig) {
	// Perform SSH handshake
	sshConn, channels, requests, err := ssh.NewServerConn(conn, config)
	if err != nil {
		log.Printf("failed to handshake: %v", err)
		return
	}
	defer sshConn.Close()

	// Discard all global requests
	go ssh.DiscardRequests(requests)

	// Handle each channel
	for ch := range channels {
		go handleChannel(ch)
	}
}

func handleChannel(ch ssh.NewChannel) {
	if ch.ChannelType() != "session" {
		ch.Reject(ssh.UnknownChannelType, "unknown channel type")
		return
	}

	// Accept the channel
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

	// Serve the SFTP requests
	if err := server.Serve(); err != nil {
		log.Printf("failed to serve SFTP requests: %v", err)
	}
}
