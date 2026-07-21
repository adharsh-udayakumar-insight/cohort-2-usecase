#!/bin/bash
# backup_project.sh

echo "Backup Usecase 2 project"

TARGET_DIR="$1"
BACKUP_DEST="$HOME/backups"
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/backup_report.txt"
START_TIME=$(date "+%Y-%m-%d %H:%M:%S")


mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DEST"

echo "Target Directory: $TARGET_DIR"
echo "lets check the directory"

if [ -z "$TARGET_DIR" ]; then
    echo "[ERROR]  target directory not provided"
    echo "Usage: ./backup_project.sh <project_directory>"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] Source directory does not look to exist "
    exit 1
fi

if [ ! -r "$TARGET_DIR" ]; then
    echo "[ERROR] Insufficient permissions"
    STATUS="Failed"
    WARNINGS="Permission denied on source directory."
    ARCHIVE_NAME="N/A"
    ARCHIVE_SIZE="0 MB"
else
    STATUS="Success"
    WARNINGS="None"
    
    echo "[INFO] backup start"
    PROJECT_NAME=$(basename "$TARGET_DIR")
    ARCHIVE_NAME="${PROJECT_NAME}_backup.tar.gz"
    ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"

    if [ -f "$ARCHIVE_PATH" ]; then
        echo "[WARNING] Existing archive detected. creating new arch"
        TIMESTAMP=$(date +%s)
        ARCHIVE_NAME="${PROJECT_NAME}_backup_${TIMESTAMP}.tar.gz"
        ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"
        WARNINGS="Existing archive found. Appended timestamp to prevent overwrite."
    fi

    echo "[INFO] Compressing "
    tar -czf "$ARCHIVE_PATH" -C "$(dirname "$TARGET_DIR")" "$PROJECT_NAME" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        WARNINGS="Some files were skipped due to insufficient permissions or read errors."
    fi

    echo "[INFO] Moving archive to backup location"
    
    if [ -f "$ARCHIVE_PATH" ]; then
        ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
    else
        STATUS="Failed"
        WARNINGS="Failed to create the archive."
        ARCHIVE_SIZE="0 MB"
    fi
fi

END_TIME=$(date "+%Y-%m-%d %H:%M:%S")

echo "Backup completed successfully."
echo ""

REPORT="=== Summary ===
Backup Start Time  : $START_TIME
Backup End Time    : $END_TIME
Source Directory   : $TARGET_DIR
Archive Created    : $ARCHIVE_NAME
Archive Size       : $ARCHIVE_SIZE
Backup Location    : $BACKUP_DEST
Status             : $STATUS
Warnings/Errors    : $WARNINGS
================="


echo "$REPORT"


echo "$REPORT" >> "$LOG_FILE"
echo "Backup report saved to: $LOG_FILE"
