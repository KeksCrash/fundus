#!/bin/bash
# Pfad zum Ordner mit den Videodateien
input_folder="/media/nw/Robot/Robot"

# Zähle die Gesamtanzahl der Dateien, auch in Unterordnern
total_files=$(find "$input_folder" -type f | wc -l)
current_file=0

# Funktion zur Anzeige des Fortschritts
show_progress() {
  percent=$((100 * current_file / total_files))
  echo -ne "Fortschritt: $percent% ($current_file/$total_files Dateien verarbeitet)\r"
}

# Schleife durch alle Dateien im Ordner und Unterordnern
find "$input_folder" -type f | while read -r file; do
  if [[ -f "$file" ]]; then
    # Erhöhe den Zähler für die aktuelle Datei
    ((current_file++))
    show_progress

    # Saubere Ausgabedatei mit "Episode X Staffel Y" als Name
    base_name=$(basename "$file")
    safe_name=$(echo "$base_name" | sed -E 's/(Episode [0-9]+ Staffel [0-9]+).*/\1/g')
    temp_file="$(dirname "$file")/${safe_name}.temp.mp4"

    # FFmpeg-Befehl zur Komprimierung
    ffmpeg -i "$file" -vcodec libx264 -crf 23 -preset medium "$temp_file" -y
    if [[ $? -eq 0 ]]; then
      # Ersetze die Originaldatei nur, wenn die Verarbeitung erfolgreich war
      mv "$temp_file" "$file"
      echo "Datei $current_file erfolgreich bearbeitet: $safe_name"
    else
      echo "Fehler bei der Verarbeitung von: $base_name"
      rm -f "$temp_file" # Lösche die temporäre Datei, wenn ein Fehler auftritt
    fi
  fi
done

# EXIF-Daten aus allen Dateien in Unterordnern entfernen
find "$input_folder" -type f -exec exiftool -all= -overwrite_original {} \;

# Abschlussmeldung
echo -e "\nAlle Dateien ($total_files) wurden verarbeitet!"
