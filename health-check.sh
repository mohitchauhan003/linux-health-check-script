#!/bin/bash
# health-check.sh - checks disk, memory, load and Nginx status

LOG_FILE="$HOME/health-check.log"
DISK_LIMIT=80
MEM_LIMIT=80
SERVICE="nginx"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

DISK_USED=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
MEM_USED=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
LOAD=$(uptime | awk -F'load average: ' '{print $2}')

log "Disk: ${DISK_USED}% | Memory: ${MEM_USED}% | Load: ${LOAD}"

if [ "$DISK_USED" -ge "$DISK_LIMIT" ]; then
  log "WARNING: disk usage is above ${DISK_LIMIT}%"
fi

if [ "$MEM_USED" -ge "$MEM_LIMIT" ]; then
  log "WARNING: memory usage is above ${MEM_LIMIT}%"
fi

if systemctl is-active --quiet "$SERVICE"; then
  log "OK: $SERVICE is running"
else
  log "ALERT: $SERVICE is NOT running"
fi
