package api

import (
	"context"
	"crypto/tls"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httptrace"
	"os"
	"strings"
	"time"
)

type Client struct {
	BaseURL    string
	Headers    map[string]string
	HTTPClient *http.Client
	Debug      bool
}

func NewClientFromConfig(cfg *ProfileConfig, debug bool) *Client {
	dialer := &net.Dialer{
		Timeout:   10 * time.Second,
		KeepAlive: 30 * time.Second,
	}

	return &Client{
		BaseURL: strings.TrimRight(cfg.BaseURL, "/"),
		Headers: cfg.Headers,
		Debug:   debug,
		HTTPClient: &http.Client{
			Timeout: 60 * time.Second,
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{
					InsecureSkipVerify: cfg.InsecureSkipVerify,
				},
				// Force IPv4 network dialing to bypass dropped AAAA queries
				DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
					return dialer.DialContext(ctx, "tcp4", addr)
				},
			},
		},
	}
}

func (c *Client) buildURL(endpoint string) string {
	cleaned := strings.TrimSpace(endpoint)
	if cleaned == "" || cleaned == "/" {
		return c.BaseURL + "/"
	}
	if strings.HasPrefix(cleaned, "http://") || strings.HasPrefix(cleaned, "https://") {
		return cleaned
	}

	parts := strings.SplitN(cleaned, "?", 2)
	pathPart := strings.Trim(parts[0], "/")
	finalURL := fmt.Sprintf("%s/%s/", c.BaseURL, pathPart)

	if len(parts) > 1 {
		finalURL = fmt.Sprintf("%s?%s", strings.TrimRight(finalURL, "/"), parts[1])
	}
	return finalURL
}

func (c *Client) Request(method, endpoint string) ([]byte, error) {
	targetURL := c.buildURL(endpoint)

	var (
		tTotalStart = time.Now()
		tDNSStart   time.Time
		tConnStart  time.Time
		tTLSStart   time.Time
		tReqStart   time.Time

		dDNS, dConn, dTLS, dTTFB time.Duration
	)

	req, err := http.NewRequest(strings.ToUpper(method), targetURL, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to build request: %w", err)
	}

	for key, val := range c.Headers {
		req.Header.Set(key, val)
	}

	if c.Debug {
		trace := &httptrace.ClientTrace{
			DNSStart: func(_ httptrace.DNSStartInfo) { tDNSStart = time.Now() },
			DNSDone: func(_ httptrace.DNSDoneInfo) {
				if !tDNSStart.IsZero() {
					dDNS = time.Since(tDNSStart)
				}
			},
			ConnectStart: func(_, _ string) { tConnStart = time.Now() },
			ConnectDone: func(_, _ string, _ error) {
				if !tConnStart.IsZero() {
					dConn = time.Since(tConnStart)
				}
			},
			TLSHandshakeStart: func() { tTLSStart = time.Now() },
			TLSHandshakeDone: func(_ tls.ConnectionState, _ error) {
				if !tTLSStart.IsZero() {
					dTLS = time.Since(tTLSStart)
				}
			},
			WroteHeaders: func() { tReqStart = time.Now() },
			GotFirstResponseByte: func() {
				if !tReqStart.IsZero() {
					dTTFB = time.Since(tReqStart)
				}
			},
		}
		req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace))
	}

	resp, err := c.HTTPClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("HTTP request failed: %w", err)
	}
	defer resp.Body.Close()

	tBodyStart := time.Now()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %w", err)
	}
	dTransfer := time.Since(tBodyStart)
	dTotal := time.Since(tTotalStart)

	// Print diagnostics strictly to STDERR
	if c.Debug {
		fmt.Fprintf(os.Stderr, "\n─── [DEBUG TIMING] %s %s ───\n", method, targetURL)
		fmt.Fprintf(os.Stderr, "  Status:         %d %s\n", resp.StatusCode, http.StatusText(resp.StatusCode))
		fmt.Fprintf(os.Stderr, "  DNS Lookup:     %v\n", dDNS)
		fmt.Fprintf(os.Stderr, "  TCP Connect:    %v\n", dConn)
		fmt.Fprintf(os.Stderr, "  TLS Handshake:  %v\n", dTLS)
		fmt.Fprintf(os.Stderr, "  Server TTFB:    %v  <-- (AAP DB/query processing)\n", dTTFB)
		fmt.Fprintf(os.Stderr, "  Data Transfer:  %v  (Size: %.2f KB)\n", dTransfer, float64(len(body))/1024.0)
		fmt.Fprintf(os.Stderr, "  Total Latency:  %v\n", dTotal)
		fmt.Fprintf(os.Stderr, "───────────────────────────────────────────────────────\n\n")
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("status %d %s: %s", resp.StatusCode, http.StatusText(resp.StatusCode), string(body))
	}

	return body, nil
}
