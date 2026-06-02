# Restore-Runbook

## Zweck

Dieses Runbook beschreibt, wie eine gelöschte Datei aus einem BorgBackup-Archiv wiederhergestellt wird.

Ein Runbook ist eine Schritt-für-Schritt-Anleitung für wiederholbare Betriebsaufgaben.

## Szenario

Eine Konfigurationsdatei wurde versehentlich gelöscht.

Betroffene Datei:

- `lab-data/configs/app.conf`

Ziel:

- Datei aus dem Borg-Archiv wiederherstellen
- Inhalt prüfen
- Datei zurück an den ursprünglichen Speicherort kopieren
- Borg-Repository prüfen

## Verwendetes Backup-Archiv

- `backup-repo::first-backup`

## Schritt 1: In den Projektordner wechseln

Befehl:

- `cd ~/projects/linux-borg-backup-restore-lab`

Erklärung:

- `cd` wechselt das aktuelle Verzeichnis.
- `~` steht für das Home-Verzeichnis des Linux-Benutzers.
- Der Projektordner enthält Testdaten, Repository, Restore-Ordner und Dokumentation.

## Schritt 2: Restore-Test-Ordner leeren

Befehl:

- `rm -rf restore-test/*`

Erklärung:

- `rm` löscht Dateien.
- `-r` bedeutet rekursiv, also inklusive Unterordnern.
- `-f` bedeutet force, also ohne Rückfrage.
- `restore-test/*` betrifft nur den Inhalt des Restore-Test-Ordners.

Warnung:

`rm -rf` muss mit äußerster Vorsicht verwendet werden. Im Terminal werden Dateien durch `rm` normalerweise nicht in einen Papierkorb verschoben.

## Schritt 3: In den Restore-Test-Ordner wechseln

Befehl:

- `cd restore-test`

Der Restore wird zuerst in einem separaten Testordner durchgeführt, nicht direkt in den Originalpfad.

## Schritt 4: Datei aus Borg wiederherstellen

Befehl:

- `borg extract ../backup-repo::first-backup lab-data/configs/app.conf`

Erklärung:

- `borg extract` stellt Dateien aus einem Borg-Archiv wieder her.
- `../backup-repo` verweist vom Ordner `restore-test/` aus auf das Repository im übergeordneten Projektordner.
- `first-backup` ist der Archivname.
- `lab-data/configs/app.conf` ist die Datei, die wiederhergestellt werden soll.

## Schritt 5: Wiederhergestellte Datei prüfen

Befehl:

- `cat lab-data/configs/app.conf`

Erwarteter Inhalt:

- `app_name=borg-backup-lab`
- `environment=lab`
- `backup_required=true`

Erklärung:

- `cat` zeigt den Inhalt einer Datei im Terminal an.
- Vor dem Zurückkopieren wird geprüft, ob die Datei korrekt wiederhergestellt wurde.

## Schritt 6: Zurück in den Projektordner wechseln

Befehl:

- `cd ..`

Erklärung:

- `..` bedeutet ein Verzeichnis nach oben.

## Schritt 7: Datei zurück an den Originalort kopieren

Befehl:

- `cp restore-test/lab-data/configs/app.conf lab-data/configs/app.conf`

Erklärung:

- `cp` kopiert Dateien.
- Die erste Pfadangabe ist die Quelle.
- Die zweite Pfadangabe ist das Ziel.

## Schritt 8: Datei am Originalort prüfen

Befehl:

- `cat lab-data/configs/app.conf`

Erwarteter Inhalt:

- `app_name=borg-backup-lab`
- `environment=lab`
- `backup_required=true`

## Schritt 9: Borg-Repository prüfen

Befehl:

- `borg check backup-repo`

Erklärung:

- `borg check` prüft die Integrität des Borg-Repositories.
- Dieser technische Check ergänzt den Restore-Test.
- Er ersetzt keinen echten Restore-Test.

## Ergebnis

Der Restore-Test war erfolgreich, wenn:

- die gelöschte Datei wiederhergestellt wurde
- der Inhalt korrekt ist
- die Datei wieder am Originalort liegt
- `borg check` ohne Fehlermeldung abgeschlossen wurde

## Wichtigste Erkenntnis

Ein Backup sollte erst dann als zuverlässig gelten, wenn eine Wiederherstellung erfolgreich getestet und geprüft wurde.
