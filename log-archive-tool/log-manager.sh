#!/bin/bash

start_time=$(date +%s)

# --------- Inputs ---------
logsDir=$1
archivedDir=$2
LOG_FILE="/var/log/log-archive-tool.log"
Age=7  # days

# --------- Check inputs ---------
if [ -z "$logsDir" ] || [ -z "$archivedDir" ]; then
    echo "Usage: $0 <logsDir> <archivedDir>" | tee -a "$LOG_FILE"
    exit 1
fi

# --------- Prepare destination ---------
mkdir -p "$archivedDir"

echo "Script started at $(date)" >> "$LOG_FILE"

# --------- Find old log files ---------
echo "Finding logs older than $Age days..." >> "$LOG_FILE"
oldFiles=$(find "$logsDir" -type f -mtime +$Age -name '*.log')

if [ -z "$oldFiles" ]; then
    echo "No Old Logs Found! We're Fine!" >> "$LOG_FILE"
    echo "Script completed at $(date)" >> "$LOG_FILE"
    exit 0
fi

originalSize=$(du -cb $oldFiles | tail -1 | awk '{print $1}')
echo "Total size of old files: $originalSize bytes" >> "$LOG_FILE"

# --------- Archive and compress ---------
echo "Creating Archive ..." >> "$LOG_FILE"
compressedSize=0
IFS=$'\n'
for name in $oldFiles; do
    baseName=$(basename "$name")
    dirName=$(basename "$(dirname "$name")")
    archiveName="$archivedDir/${dirName}-${baseName}_$(date +%Y%m%d)"

    # Compress and split
    tar --zstd -cvf - "$name" | split --additional-suffix=.zst.part -b 1G - "$archiveName" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        # Calculate total size of all split parts
        fileSize=$(du -cb "${archiveName}"* | tail -1 | awk '{print $1}')
        compressedSize=$((compressedSize + fileSize))
        echo "Archived: $name -> $archiveName" >> "$LOG_FILE"

        # Optional: remove original file
        # rm "$name"
        echo "Removed original file: $name" >> "$LOG_FILE"
    else
        echo "Failed to archive: $name" >> "$LOG_FILE"
    fi
done
unset IFS

# --------- Summary ---------
if [ "$originalSize" -gt 0 ]; then
    reduction=$(( (originalSize - compressedSize) * 100 / originalSize ))
    echo "Compressed size: $compressedSize bytes"
    echo "Size reduction: $reduction%"
fi

echo "Script completed at $(date)" >> "$LOG_FILE"
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Script execution time: ${execution_time}s" | tee -a "$LOG_FILE"
