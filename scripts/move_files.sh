#!/bin/bash

# Pfade definieren
processed_folder="/home/kali/ah/processed_files/"
original_folder="/home/kali/ah/AH/"
start_file="23111)_Monster_House(1).mp4"
move_flag=0

# Durchlaufe alle Dateien im processed_folder
for file in $(ls -ltAr "$processed_folder" | awk '{print $9}'); do
  # Prüfe, ob wir die Startdatei erreicht haben
  if [[ "$file" == "$start_file" ]]; then
    move_flag=1
    continue
  fi

  # Wenn die Startdatei noch nicht erreicht wurde, verschiebe die Datei
  if [[ $move_flag -eq 0 && -f "$processed_folder/$file" ]]; then
    mv "$processed_folder/$file" "$original_folder"
    echo "Verschoben: $file"
  fi
done

echo "Alle Dateien oberhalb von '$start_file' wurden verschoben!"
