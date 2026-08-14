# archive files older than x amount of time in a given directory

```bash
#!/bin/bash

# Define your exact paths here
TARGET_DIR="/path/to/your/folder"
ARCHIVE_NAME="archive_$(date +%Y%m%d).tgz"

# Move into the directory
cd "$TARGET_DIR" || exit

# Check if there are actually any files to archive before running tar
if find . -maxdepth 1 -name "*.csv" -type f -mtime +30 | read -r; then

    # 1. Create the archive
    find . -maxdepth 1 -name "*.csv" -type f -mtime +30 -print0 | tar -czvf "$ARCHIVE_NAME" --null -T -

    # 2. If the tar command was successful (exit code 0), delete the originals
    if [ $? -eq 0 ]; then
        find . -maxdepth 1 -name "*.csv" -type f -mtime +30 -delete
        echo "Successfully archived and cleaned up on $(date)"
    else
        echo "Error: Tar failed, skipping deletion."
    fi
else
    echo "No files older than 30 days found."
fi

```
