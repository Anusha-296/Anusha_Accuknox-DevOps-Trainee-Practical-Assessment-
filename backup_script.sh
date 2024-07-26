#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source_directory"
REMOTE_USER="ubuntu"
REMOTE_SERVER="54.253.152.244"
REMOTE_DIR="/home/ubuntu"
LOG_FILE="/var/log/backup.log"

# Log message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Perform backup
backup_directory() {
    rsync -avz $SOURCE_DIR $REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR
    if [[ $? -eq 0 ]]; then
        log_message "Backup completed successfully"
    else
        log_message "Backup failed"
    fi
}

# Main function
main() {
    backup_directory
}

main

