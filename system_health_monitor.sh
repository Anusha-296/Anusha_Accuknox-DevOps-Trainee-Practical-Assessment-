#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

# Log message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Check CPU usage
check_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        log_message "ALERT: High CPU usage detected: ${CPU_USAGE}%"
    fi
}

# Check memory usage
check_memory_usage() {
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        log_message "ALERT: High memory usage detected: ${MEMORY_USAGE}%"
    fi
}

# Check disk usage
check_disk_usage() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if (( DISK_USAGE > DISK_THRESHOLD )); then
        log_message "ALERT: High disk usage detected: ${DISK_USAGE}%"
    fi
}

# Check number of running processes
check_running_processes() {
    PROCESS_COUNT=$(ps aux | wc -l)
    log_message "Number of running processes: ${PROCESS_COUNT}"
}

# Main function
main() {
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
}

main

