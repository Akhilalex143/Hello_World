#!/bin/bash

# Get the current date and time
NOW=$(date +"%Y-%m-%d %T")

# Get the load averages for the past 1, 5, and 15 minutes
LOAD=$(uptime | awk '{print $8,$9,$10}')

# Get the total amount of RAM and the amount of free RAM
MEM_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEM_FREE=$(free -m | awk 'NR==2{print $4}')

# Calculate the percentage of used RAM
MEM_USED=$(awk "BEGIN {printf \"%.0f\n\",100-$MEM_FREE/$MEM_TOTAL*100}")

# Get the total amount of disk space and the amount of free disk space
DISK_TOTAL=$(df -h | awk 'NR==2{print $2}')
DISK_FREE=$(df -h | awk 'NR==2{print $4}')

# Calculate the percentage of used disk space
DISK_USED=$(df -h | awk 'NR==2{print $5}' | tr -d '%')

# Print the results
echo "$NOW | Load: $LOAD | RAM: $MEM_USED% used ($MEM_FREE MB free of $MEM_TOTAL MB) | Disk: $DISK_USED% used ($DISK_FREE free of $DISK_TOTAL)"
