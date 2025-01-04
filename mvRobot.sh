#!/bin/bash

# Ordner definieren
source_dir="/media/nw/Robot/Robot/Staffel4"
destination_dir="/home/kali/ah/AH"

# Funktion: Dateien verschieben
move_processed_files() {
    # Rekursive Suche nach Dateien in allen "Stafel*" und "Staffel*" Unterordnern
    find "$source_dir" -type f -name 'Episode*' | while read -r file; do
        # Basisname der Datei ermitteln
        base_name=$(basename "$file")

        # Prüfen, ob die Datei bearbeitet wurde
        if [[ "$base_name" =~ ^Episode\ [0-9]+\ Staffel\ [0-9]+\.mp4$ ]]; then
            # Staffel-Ordner ermitteln
            parent_dir=$(dirname "$file")
            folder_name=$(basename "$parent_dir")
            
            # Zielordner vorbereiten
            target_folder="$destination_dir/$folder_name"
            mkdir -p "$target_folder"

            # Datei verschieben
            mv "$file" "$target_folder/"
            echo "Verschoben: $file -> $target_folder/"
        else
            echo "Übersprungen: $file (nicht bearbeitet)"
        fi
    done
}

# Skript ausführen
move_processed_files
