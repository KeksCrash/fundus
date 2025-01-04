#!/bin/bash

# Fragt nach dem Verzeichnis, das bearbeitet werden soll
read -p "Geben Sie den Pfad zum Verzeichnis ein, in dem Metadaten gelöscht werden sollen: " target_dir

# Überprüfen, ob das Verzeichnis existiert
if [ ! -d "$target_dir" ]; then
    echo "Das angegebene Verzeichnis existiert nicht."
    exit 1
fi

echo "Beginne mit dem Entfernen von Metadaten im Verzeichnis: $target_dir"

# Entfernt Metadaten für MP3-Dateien
echo "Bearbeite MP3-Dateien..."
find "$target_dir" -type f -iname "*.mp3" -print0 | while IFS= read -r -d '' file; do
    echo "Entferne Metadaten aus: $file"
    id3v2 --delete-all "$file" || echo "Fehler beim Bearbeiten von: $file"
done

# Entfernt Metadaten für MP4-Dateien
echo "Bearbeite MP4-Dateien..."
find "$target_dir" -type f -iname "*.mp4" -print0 | while IFS= read -r -d '' file; do
    echo "Entferne Metadaten aus: $file"
    exiftool -all= -overwrite_original "$file" || echo "Fehler beim Bearbeiten von: $file"
done

# Entfernt Metadaten für Bilder (JPEG, PNG)
echo "Bearbeite Bilddateien..."
find "$target_dir" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -print0 | while IFS= read -r -d '' file; do
    echo "Entferne Metadaten aus: $file"
    exiftool -all= -overwrite_original "$file" || echo "Fehler beim Bearbeiten von: $file"
done

# Entfernt Metadaten für andere Dateien
echo "Bearbeite andere Dateien..."
find "$target_dir" -type f ! -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -print0 | while IFS= read -r -d '' file; do
    echo "Entferne Metadaten aus: $file"
    exiftool -all= -overwrite_original "$file" || echo "Fehler beim Bearbeiten von: $file"
done

echo "Alle Metadaten wurden erfolgreich entfernt."
