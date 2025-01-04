#!/bin/bash

input_folder="/home/kali/Downloads"

process_file() {
  file="$1"
  if [[ -f "$file" ]]; then
    safe_name=$(basename "$file" | sed 's/[^a-zA-Z0-9._-]/_/g')
    temp_file="${input_folder}/${safe_name}.temp.mp4"
    
    # Bearbeite das Video mit ffmpeg und gib den Fortschritt aus
    ffmpeg -i "$file" -vcodec libx264 -crf 23 -preset medium -progress pipe:1 "$temp_file" 2>&1 | while read line; do
      # Überprüfen, ob die Zeile den Fortschritt enthält
      if [[ $line == *"out_time_ms"* ]]; then
        time_ms=$(echo $line | sed 's/out_time_ms=//')
        duration_ms=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv="p=0" "$file" | sed 's/\..*//')
        progress=$(echo "scale=2; $time_ms / ($duration_ms * 1000) * 100" | bc)
        echo -ne "Fortschritt: $progress%\r"  # Fortschritt in Prozent
      fi
    done
    
    # Nach der Videobearbeitung: Entferne Metadaten mit exiftool
    exiftool -all= -overwrite_original "$temp_file"
    
    if [[ $? -eq 0 ]]; then
      mv "$temp_file" "$file"
      #mv "file" /mnt/movie/365Tage/
      echo -e "\nDatei erfolgreich bearbeitet und Metadaten entfernt: $(basename "$file")"
    else
      echo -e "\nFehler bei der Verarbeitung der Metadaten von: $(basename "$file")"
      rm -f "$temp_file"
    fi
  fi
}

# Überwache den Ordner auf Änderungen
echo "Starte die Überwachung des Ordners $input_folder"

# Überwache den Ordner auf neue Dateien
while inotifywait -e create "$input_folder"; do
  for file in "$input_folder"/*; do
    if [[ -f "$file" && ! -f "$file.processed" ]]; then
      echo "Neue Datei gefunden: $file"
      process_file "$file"
      touch "$file.processed"
    fi
  done
done

