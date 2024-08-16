/* golang sftp server implementation for highlatency, low bandwith clients

Date: 2024-08-16 08:09 CST

binds to 0.0.0.0:2022, run inside container with chroot


// TODO: finish this
1. generates its own crypto throw away key that is unique on startup
2.


*/

package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"log"
	"net"

	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func encodePrivateKeyToPEM(privateKey *rsa.PrivateKey) []byte {
	// Convert the RSA private key to ASN.1 PKCS#1 DER encoded form
	privateKeyDER := x509.MarshalPKCS1PrivateKey(privateKey)

	// Create a PEM block with the DER encoded private key
	privateKeyPEMBlock := &pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: privateKeyDER,
	}

	// Encode the PEM block to bytes
	return pem.EncodeToMemory(privateKeyPEMBlock)
}

func main() {

	// Generate a 4096-bit RSA private throw away key each time we boot
	privateKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		fmt.Println("Error generating RSA key:", err)
		return
	}

	privateKeyPEM := encodePrivateKeyToPEM(privateKey)

	signer, err := ssh.ParsePrivateKey(privateKeyPEM)
	if err != nil {
		panic(fmt.Errorf("signer %s", err.Error()))
	}

	config := &ssh.ServerConfig{
		NoClientAuth: true, // no client authentication
	}
	config.AddHostKey(signer)

	// Listen for incoming connections
	// implement flag for port
	listener, err := net.Listen("tcp", "0.0.0.0:2022") // Listening on port 2022
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
		log.Printf("Request recieved from: %s", conn.RemoteAddr())
	}
}

func handleChannel(ch ssh.NewChannel) {
	if ch.ChannelType() != "session" {
		ch.Reject(ssh.UnknownChannelType, "unknown channel type")
		return
	}
	// TODO: remove this comment
	log.Printf("Channel type: %s", ch.ChannelType())

	// Accept the channel
	channel, _, err := ch.Accept()
	if err != nil {
		log.Printf("could not accept channel: %v", err)
		return
	}
	defer channel.Close()

	server, err := sftp.NewServer(
		channel,
		// NOTE: we should always run this service in ReadOnly mode
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
