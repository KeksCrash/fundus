#!/bin/bash

# Pfad zum Hauptordner mit den Videodateien
input_folder="/media/nw/Robot/Robot"

# Funktion zur Verarbeitung einer Datei
process_file() {
    file="$1"
    if [[ -f "$file" ]]; then
        # Dateiname extrahieren
        base_name=$(basename "$file")
        echo "Verarbeite Datei: $base_name"
        
        # Überprüfen, ob die Datei bereits verarbeitet wurde
        if [[ "$base_name" =~ ^Episode\ [0-9]+\ Staffel\ [0-9]+\.mp4$ ]]; then
            echo "Überspringe: Datei $base_name wurde bereits verarbeitet."
            return
        fi

        # Staffel- und Episodeninformationen aus dem Dateinamen extrahieren
        episode=$(echo "$base_name" | grep -oP "Episode \d+" || echo "")
        season=$(echo "$base_name" | grep -oP "Staffel \d+" || echo "")

        # Prüfen, ob gültige Informationen gefunden wurden
        if [[ -z "$episode" || -z "$season" ]]; then
            echo "Fehler: Dateiname enthält keine gültigen Episode- und Staffelnummern. Überspringe Datei."
            return
        fi

        # Neues Dateiformat
        output_file="$(dirname "$file")/${episode} ${season}.mp4"

        # Überprüfen, ob die Zieldatei bereits existiert
        if [[ -f "$output_file" ]]; then
            echo "Überspringe: Zieldatei $output_file existiert bereits."
            return
        fi

         # Fortschritt in eine temporäre Datei schreiben 
         echo -e "$file\n$output_file" > /tmp/current_file.txt
        
         # Video verarbeiten und Metadaten entfernen (qualitätsbewusst)
        ffmpeg -i "$file" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k -map_metadata -1 -y "$output_file" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\nDatei erfolgreich verarbeitet: $output_file"
        else
            echo -e "\nFehler bei der Verarbeitung von $base_name. Lösche unvollständige Datei."
            rm -f "$output_file"
        fi
    fi
}

# Wiederhole die Verarbeitung 46-mal
for ((i = 1; i <= 20; i++)); do
    echo "Durchlauf $i/46..."
    find "$input_folder" -type f -name "*.mp4" -print0 | while IFS= read -r -d '' file; do
        process_file "$file"
    done
done

echo -e "\nAlle Dateien wurden nach 46 Durchläufen verarbeitet."
