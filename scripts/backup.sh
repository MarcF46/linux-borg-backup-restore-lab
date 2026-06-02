#!/usr/bin/env bash

# Stoppt das Skript bei Fehlern, nicht gesetzten Variablen und Fehlern in Pipelines.
set -Eeuo pipefail

# Projektpfade
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$PROJECT_DIR/backup-repo"
SOURCE_DIR="$PROJECT_DIR/lab-data"
LOG_DIR="$PROJECT_DIR/logs"

# Archivname mit Zeitstempel.
# Beispiel: lab-backup-2026-06-02_22-15-30
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
ARCHIVE_NAME="lab-backup-$TIMESTAMP"

# Logdatei für diesen Backup-Lauf
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup-$TIMESTAMP.log"

echo "=== Borg Backup Lab v1.1 ===" | tee -a "$LOG_FILE"
echo "Startzeit: $(date)" | tee -a "$LOG_FILE"
echo "Projektordner: $PROJECT_DIR" | tee -a "$LOG_FILE"
echo "Repository: $REPO" | tee -a "$LOG_FILE"
echo "Quelle: $SOURCE_DIR" | tee -a "$LOG_FILE"
echo "Archivname: $ARCHIVE_NAME" | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

# Sicherheitsprüfung: Existiert das Borg-Repository?
if [[ ! -d "$REPO" ]]; then
  echo "FEHLER: Borg-Repository wurde nicht gefunden: $REPO" | tee -a "$LOG_FILE"
  exit 1
fi

# Sicherheitsprüfung: Existiert der Quellordner?
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "FEHLER: Quellordner wurde nicht gefunden: $SOURCE_DIR" | tee -a "$LOG_FILE"
  exit 1
fi

echo "Starte Backup..." | tee -a "$LOG_FILE"

borg create \
  --stats \
  --compression lz4 \
  "$REPO::$ARCHIVE_NAME" \
  "$SOURCE_DIR" 2>&1 | tee -a "$LOG_FILE"

echo | tee -a "$LOG_FILE"
echo "Backup abgeschlossen." | tee -a "$LOG_FILE"
echo "Verfügbare Archive:" | tee -a "$LOG_FILE"

borg list "$REPO" 2>&1 | tee -a "$LOG_FILE"

echo | tee -a "$LOG_FILE"
echo "Endzeit: $(date)" | tee -a "$LOG_FILE"
echo "Logdatei: $LOG_FILE"
