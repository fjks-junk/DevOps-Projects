#!/bin/bash

# --------- Color ---------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# --------- CPU ---------
TOTAL_CPU=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.2f", 100 - $8}')
REAL_CPU=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.2f", $2 + $4}')

# CPU Warning Color
if (( $(echo "$TOTAL_CPU > 80" | bc -l) )); then
    CPU_COLOR=$RED
elif (( $(echo "$TOTAL_CPU > 50" | bc -l) )); then
    CPU_COLOR=$YELLOW
else
    CPU_COLOR=$GREEN
fi

# --------- Memory ---------
MEMORY_INFO=$(free -m | awk 'NR==2{printf "%.2f%% (%sMB used / %sMB total)", $3*100/$2, $3, $2 }')
MEMORY_PERCENT=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

# RAM Warning Color
if (( $(echo "$MEMORY_PERCENT > 80" | bc -l) )); then
    MEM_COLOR=$RED
elif (( $(echo "$MEMORY_PERCENT > 50" | bc -l) )); then
    MEM_COLOR=$YELLOW
else
    MEM_COLOR=$GREEN
fi

# --------- Disk ---------
DISK_INFO=$(df -h | awk '$NF=="/"{printf "%s (%s/%s)", $5, $3, $2}')
DISK_PERCENT=$(df -h | awk '$NF=="/"{gsub("%","",$5); printf "%d",$5}')

# Disk Warning Color
if (( DISK_PERCENT > 80 )); then
    DISK_COLOR=$RED
elif (( DISK_PERCENT > 50 )); then
    DISK_COLOR=$YELLOW
else
    DISK_COLOR=$GREEN
fi

# --------- Top 5 Processes ---------
TOP5_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n6)
TOP5_MEM=$(ps -eo pid,comm,%mem --sort=-%mem | head -n6)

# --------- Extra Stats ---------
OS_VERSION=$(lsb_release -d 2>/dev/null | awk -F'\t' '{print $2}')
UPTIME=$(uptime -p)
LOAD_AVG=$(uptime | awk -F'load average: ' '{print $2}')
LOGGED_USERS=$(who | wc -l)
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)

# --------- Print ---------
echo -e "========== SERVER STATS =========="
echo -e "OS Version: ${OS_VERSION:-N/A}"
echo -e "Uptime: $UPTIME"
echo -e "Load Average: $LOAD_AVG"
echo -e "Logged in Users: $LOGGED_USERS"
echo -e "Failed Login Attempts: $FAILED_LOGINS"
echo
echo -e "Total CPU Usage: ${CPU_COLOR}${TOTAL_CPU}%${NC}"
echo -e "CPU Usage (user+system): ${REAL_CPU}%"
echo -e "Memory Usage: ${MEM_COLOR}${MEMORY_INFO}${NC}"
echo -e "Disk Usage (root /): ${DISK_COLOR}${DISK_INFO}${NC}"
echo
echo "Top 5 Processes by CPU:"
printf "%-8s %-25s %-6s\n" "PID" "COMMAND" "%CPU"
echo "$TOP5_CPU" | tail -n +2 | awk '{printf "%-8s %-25s %-6s\n",$1,$2,$3}'
echo
echo "Top 5 Processes by Memory:"
printf "%-8s %-25s %-6s\n" "PID" "COMMAND" "%MEM"
echo "$TOP5_MEM" | tail -n +2 | awk '{printf "%-8s %-25s %-6s\n",$1,$2,$3}'
echo "================================="
