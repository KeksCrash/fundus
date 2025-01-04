#!/bin/bash

# Pfad zum Zielordner
target_folder="/mnt/"

# Zähle die Gesamtanzahl der Dateien
total_files=$(find "$target_folder" -type f | wc -l)
current_file=0

# Verarbeite jede Datei mit ExifTool
find "$target_folder" -type f | while read -r file; do
    ((current_file++))
    
    # Fortschrittsanzeige
    percent=$((100 * current_file / total_files))
    echo -ne "Fortschritt: $percent% ($current_file/$total_files Dateien verarbeitet)\r"
    
    # ExifTool-Befehl (anpassen, falls spezifische Metadaten geändert werden sollen)
    exiftool -overwrite_original -all= "$file" > /dev/null 2>&1
done

echo -e "\nExifTool wurde auf alle Dateien angewendet."
