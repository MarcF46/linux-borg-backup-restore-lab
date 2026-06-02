# Backup-Skript

## Zweck

Dieses Dokument beschreibt das Backup-Skript scripts/backup.sh.

Das Skript erweitert das Borg Backup Lab um eine einfache Automatisierung. Es erstellt ein neues Borg-Archiv mit Zeitstempel, schreibt eine Logdatei und zeigt nach dem Backup die vorhandenen Archive an.

## Ziel

Das Skript soll:

- ein neues Borg-Archiv mit eindeutigem Zeitstempel erstellen
- den Ordner lab-data/ sichern
- pro Backup-Lauf eine eigene Logdatei schreiben
- vorhandene Archive nach dem Backup anzeigen
- Fehler sichtbar machen

## Skriptpfad

scripts/backup.sh

## Gesicherte Daten

Quelle:

lab-data/

## Borg-Repository

Ziel:

backup-repo/

Der Ordner backup-repo/ wird nicht in Git aufgenommen, weil er lokale Backup-Daten enthält.

## Archivnamen

Das Skript erzeugt Archivnamen mit Datum und Uhrzeit.

Beispiel:

lab-backup-2026-06-02_23-02-07

Dadurch wird verhindert, dass ein Archivname mehrfach verwendet wird.

## Logdateien

Pro Backup-Lauf wird eine Logdatei erzeugt.

Beispiel:

logs/backup-2026-06-02_23-02-07.log

Der Ordner logs/ wird nicht in Git aufgenommen, weil Logdateien lokale Pfade oder sensible Betriebsinformationen enthalten können.

## Ausführung

./scripts/backup.sh

## Wichtige Befehle im Skript

borg create --stats --compression lz4 "$REPO::$ARCHIVE_NAME" "$SOURCE_DIR"

Bedeutung:

- borg create erstellt ein neues Backup-Archiv.
- --stats zeigt Statistiken zum Backup an.
- --compression lz4 nutzt schnelle Kompression.
- $REPO::$ARCHIVE_NAME besteht aus Repository-Pfad und Archivname.
- $SOURCE_DIR ist der zu sichernde Quellordner.

borg list "$REPO"

Bedeutung:

- zeigt die vorhandenen Archive im Borg-Repository an.

## Passphrase

Die Borg-Passphrase wird nicht im Skript gespeichert.

Für dieses Lab wird die Passphrase interaktiv eingegeben.

In produktionsnahen Umgebungen sollten Passphrases nicht hart im Skript stehen. Mögliche Ansätze sind zum Beispiel:

- Passwortmanager
- geschützte Secret-Dateien
- BORG_PASSCOMMAND
- sichere Automatisierungsumgebung

## Prüfung nach dem Backup

Archive anzeigen:

borg list backup-repo

Repository prüfen:

borg check backup-repo

## Deduplizierung

Borg speichert gleiche Daten nicht mehrfach. Wenn dieselben Testdaten erneut gesichert werden, kann ein neues Archiv logisch vorhanden sein, ohne dass dafür viele neue Datenblöcke gespeichert werden müssen.

Das erkennt man an den Werten für:

- Original size
- Compressed size
- Deduplicated size
- Unique chunks
- Total chunks

## Wichtigste Erkenntnis

Ein Backup-Skript ist nur ein Baustein. Entscheidend bleibt, dass Backups regelmäßig geprüft und Restore-Abläufe getestet werden.
