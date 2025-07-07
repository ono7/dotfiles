#!/bin/bash

# Backup the password store
cp -r ~/.password-store ~/.password-store-backup

# Generate a new GPG key (interactive)
# gpg --full-generate-key

# Get the ID of the new key
# NEW_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | tail -n 1 | awk '{print $2}' | cut -d'/' -f2)

NEW_KEY_ID=CHANGEMETONEWKEY

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Function to re-encrypt passwords
re_encrypt() {
  local path=$1
  local file
  for file in "$path"/*; do
    if [[ -f "$file" ]]; then
      # Decrypt and re-encrypt each password file
      gpg --decrypt "$file" | gpg --encrypt --recipient "$NEW_KEY_ID" -o "$TEMP_DIR/${file##*/}"
    elif [[ -d "$file" ]]; then
      # If it's a directory, create it in the temp dir and recurse
      mkdir -p "$TEMP_DIR/${file##*/}"
      re_encrypt "$file"
    fi
  done
}

# Re-encrypt all passwords
re_encrypt ~/.password-store

# Replace old password store with new one
rm -rf ~/.password-store
mv "$TEMP_DIR" ~/.password-store

# Update .gpg-id file with new key ID
echo "$NEW_KEY_ID" >~/.password-store/.gpg-id

echo "GPG key change complete. New key ID: $NEW_KEY_ID"
echo "Please verify your password store and then remove the backup if everything is correct."
