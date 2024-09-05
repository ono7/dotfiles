#!/bin/bash

name="Lima, Jose"
emai="20385388+ono7@users.noreply.github.com"


# Function to generate GPG key
generate_gpg_key() {
  echo "Generating GPG key..."
  gpg --batch --generate-key <<EOF
    Key-Type: RSA
    Key-Length: 4096
    Name-Real: "$name"
    Name-Email: "$email"
    Expire-Date: 0
    %no-protection
    %commit
EOF
}

# Main script
echo "GPG and Git Setup Script"
echo "------------------------"

generate_gpg_key

# List keys and get the key ID
echo "Listing GPG keys..."
key_id=$(gpg --list-keys --keyid-format SHORT "$email" | grep pub | awk '{print $2}' | awk -F'/' '{print $2}')

if [ -z "$key_id" ]; then
  echo "Error: Could not find the generated key."
  exit 1
fi

echo "Your GPG key ID is: $key_id"

# Configure Git
echo "Configuring Git..."
git config --global user.signingkey "$key_id"
git config --global commit.gpgsign true
git config --global user.name "$name"
git config --global user.email "$email"

# Export public key
echo "Exporting public key..."
gpg --armor --export "$key_id" >gpg_public_key.txt

echo "Setup complete!"
echo "Your public GPG key has been saved to gpg_public_key.txt"
echo "Add this key to your GitHub account: https://github.com/settings/keys"
