# Backup-Konzept

## Zweck

Dieses Dokument beschreibt das Backup-Konzept des BorgBackup-Labs.

Das Ziel ist ein einfacher, nachvollziehbarer Backup-Prozess unter Linux. Dabei geht es nicht um produktive Daten, sondern um ein kontrolliertes Lern- und Portfolio-Szenario.

## Backup-Umfang

Gesichert werden ausschließlich harmlose Testdaten im Ordner:

- `lab-data/`

Die Testdaten bestehen aus:

- einer Beispiel-Webseite
- einer Beispiel-Konfigurationsdatei
- einer kurzen Restore-Notiz

## Projektstruktur

Wichtige Ordner:

- `lab-data/` enthält die Testdaten
- `backup-repo/` enthält das lokale Borg-Repository
- `restore-test/` dient als Zielordner für Wiederherstellungstests
- `docs/` enthält die technische Dokumentation
- `scripts/` ist für spätere Automatisierung vorgesehen
- `logs/` ist für spätere Logdateien vorgesehen

## Borg-Repository

Das Borg-Repository wurde lokal erstellt:

- `backup-repo/`

Dieser Ordner wird nicht in Git aufgenommen. Er ist in `.gitignore` ausgeschlossen.

## Verschlüsselung

Das Repository wurde mit folgendem Befehl initialisiert:

- `borg init --encryption=repokey backup-repo`

`repokey` bedeutet, dass der Verschlüsselungsschlüssel im Repository gespeichert wird, aber durch eine Passphrase geschützt ist.

Wichtig:

- Die Passphrase wird nicht dokumentiert.
- Die Passphrase wird nicht in Git gespeichert.
- Die Passphrase wird nicht in Screenshots gezeigt.

## Erstes Backup

Das erste Backup-Archiv wurde mit folgendem Befehl erstellt:

- `borg create --stats --compression lz4 backup-repo::first-backup lab-data`

Bedeutung:

- `borg create` erstellt ein neues Backup-Archiv.
- `--stats` zeigt Statistiken zum Backup an.
- `--compression lz4` aktiviert schnelle Kompression.
- `backup-repo::first-backup` bedeutet Repository `backup-repo` und Archivname `first-backup`.
- `lab-data` ist der zu sichernde Ordner.

## Prüfung

Die vorhandenen Archive wurden mit folgendem Befehl angezeigt:

- `borg list backup-repo`

Der Inhalt des ersten Archivs wurde mit folgendem Befehl geprüft:

- `borg list backup-repo::first-backup`

Das Repository wurde mit folgendem Befehl geprüft:

- `borg check backup-repo`

## Restore-Test

Für den Restore-Test wurde die Datei `lab-data/configs/app.conf` gelöscht und anschließend aus dem Borg-Archiv wiederhergestellt.

Der Restore wurde nicht direkt in den Originalordner durchgeführt, sondern zuerst in den separaten Ordner `restore-test/`.

Das ist eine wichtige Sicherheitsmaßnahme, weil man wiederhergestellte Daten vor dem Zurückkopieren prüfen sollte.

## Sicherheitsgrenzen

Folgende Inhalte dürfen nicht in GitHub landen:

- Borg-Repositories
- Passphrases
- SSH Private Keys
- echte Backup-Daten
- Kundendaten
- produktive Konfigurationen
- Datenbank-Dumps
- sensible Logs

## Geplante Erweiterungen

Mögliche nächste Schritte:

- automatisiertes Backup-Skript
- Archivnamen mit Zeitstempel
- Retention Policy mit `borg prune`
- Remote-Backup per SSH
- Logdateien
- automatisierter Restore-Test
- Monitoring oder Reporting
