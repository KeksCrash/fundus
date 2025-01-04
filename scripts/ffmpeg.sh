#!/bin/bash

# Pfad zum Ordner mit den Videodateien
input_folder="/home/kali/Downloads/"

# Zähle die Gesamtanzahl der Dateien
total_files=$(ls "$input_folder" | wc -l)
current_file=0

# Schleife durch alle Dateien im Ordner
for file in "$input_folder"/*; do
  if [[ -f "$file" ]]; then
    # Erhöhe den Zähler für die aktuelle Datei
    ((current_file++))
    
    # Fortschritt anzeigen
    echo "Bearbeite Datei $current_file von $total_files: $(basename "$file")"

    # Saubere Ausgabedatei mit gültiger Endung und ohne Sonderzeichen
    safe_name=$(basename "$file" | sed 's/[^a-zA-Z0-9._-]/_/g')
    temp_file="${input_folder}/${safe_name}.temp.mp4"
    
    # FFmpeg-Befehl zur Komprimierung
    ffmpeg -i "$file" -vcodec libx264 -crf 23  -preset medium  "$temp_file"
    
    if [[ $? -eq 0 ]]; then
      # Ersetze die Originaldatei nur, wenn die Verarbeitung erfolgreich war
      mv "$temp_file" "$file"
      echo "Datei $current_file erfolgreich bearbeitet: $(basename "$file")"
    else
      echo "Fehler bei der Verarbeitung von: $(basename "$file")"
      rm -f "$temp_file" # Lösche die temporäre Datei, wenn ein Fehler auftritt
    fi
  fi
done

# Abschlussmeldung
echo "Alle Dateien ($total_files) wurden verarbeitet!"

exiftool -all= -overwrite_original /home/kali/Downloads
