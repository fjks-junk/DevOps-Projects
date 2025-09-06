# Server Stats Script

A simple Bash script to display system statistics (CPU, memory, disk, processes, and security logs) with color-coded output in the terminal.

---

## Features
- Show OS version and system uptime
- Display **load average** and number of logged-in users
- Count failed SSH login attempts (`/var/log/auth.log`)
- CPU usage:
  - Total CPU usage
  - User + system CPU usage
  - Color-coded warnings (green/yellow/red)
- Memory usage:
  - Usage percentage and used/total MB
  - Color-coded warnings
- Disk usage (root `/`):
  - Usage percentage and used/total
  - Color-coded warnings
- Top 5 processes by **CPU**
- Top 5 processes by **memory**

---

## Requirements
The script works on most Linux distributions (Debian, Ubuntu, CentOS, ...). It requires the following commands to be available:
- `bash`
- `awk`
- `top`
- `free`
- `df`
- `ps`
- `uptime`
- `who`
- `lsb_release` (optional, for OS version)

> Note: To count failed login attempts, the script reads `/var/log/auth.log`.  
> You may need `sudo` privileges depending on your system configuration.

---

## Color Legend
The script uses color-coded output to indicate system health:

- 🟢 **Green** → Normal (≤ 50%)  
- 🟡 **Yellow** → Warning (51–80%)  
- 🔴 **Red** → Critical (> 80%)  

This applies to **CPU**, **memory**, and **disk** usage.

---

## Usage
1. Save the script as `server-stats.sh`.
2. Make it executable:
   ```bash
   chmod +x server-stats.sh


This project is part of roadmap.sh DevOps projects.
**https://roadmap.sh/projects/server-stats**
