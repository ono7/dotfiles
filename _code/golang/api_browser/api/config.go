package api

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

type ProfileConfig struct {
	BaseURL            string            `yaml:"base_url"`
	InsecureSkipVerify bool              `yaml:"insecure_skip_verify"`
	Headers            map[string]string `yaml:"headers"`
}

// LoadProfile reads a YAML file and expands environment variables (e.g., ${AAP_TOKEN})
func LoadProfile(filePath string) (*ProfileConfig, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to read profile file: %w", err)
	}

	// Expand shell variables before unmarshaling YAML
	expanded := os.ExpandEnv(string(data))

	var config ProfileConfig
	if err := yaml.Unmarshal([]byte(expanded), &config); err != nil {
		return nil, fmt.Errorf("failed to parse profile YAML: %w", err)
	}

	if config.BaseURL == "" {
		return nil, fmt.Errorf("profile must specify 'base_url'")
	}

	return &config, nil
}
