
# Log Archive Tool

**A simple CLI tool to archive and compress old log files on Linux systems.**
This tool helps maintain a clean system by compressing old logs and storing them in a dedicated archive directory while keeping detailed logs of all operations.

---

## Features

* Finds log files older than a specified number of days (default: 7)
* Compresses logs using **zstd** (high-speed, high-ratio compression)
* Splits large archives (>1GB) into multiple parts for easier storage
* Calculates and logs:

  * Total size of old files
  * Compressed size
  * Percentage of size reduction
* Optionally removes original log files after compression
* Stores all script operations and statuses in a central log file (`/var/log/log-archive-tool.log`)
* Records script execution time
* Designed to be run on any Linux system

---

## Requirements

* Linux / Unix-like operating system
* `bash`
* `tar` with `--zstd` support
* `split` command
* Permissions to read log directories and write to the archive directory

---

## Usage

```bash
./log-manager.sh <logsDir> <archivedDir>
```

### Arguments

* `<logsDir>`: Directory containing the log files to be archived (e.g., `/var/log`)
* `<archivedDir>`: Directory where the compressed archives will be stored

Example:

```bash
./log-manager.sh /var/log /home/user/log-archive
```

---

## How It Works

1. The script checks for input directories.
2. It finds `.log` files older than **7 days** (default) in the specified `logsDir`.
3. If old files exist:

   * Calculates their total size
   * Compresses them using `tar --zstd`
   * Splits archives larger than 1GB
   * Optionally deletes original files (commented by default)
   * Logs all actions in `LOG_FILE`
4. Prints summary of compression results and execution time.

---

## Log File

All operations and statuses are recorded in:

```
/var/log/log-archive-tool.log
```


## Notes

* The `rm "$name"` line is commented out by default.
  Uncomment it if you want to remove the original log files after archiving.
* Adjust `Age` in the script to change the minimum age of logs to archive (default 7 days).
* Large log files are split into 1GB parts automatically.

