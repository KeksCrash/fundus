#!/bin/bash

# Pfad zum Ordner mit den Videodateien
input_folder="/media/nw/Robot/Robot"

# Zähle die Gesamtanzahl der Dateien
total_files=$(find "$input_folder" -type f -name "*.mp4" | wc -l)
current_file=0

# Funktion zur Anzeige des Fortschritts
show_progress() {
    percent=$((100 * current_file / total_files))
    echo -ne "Fortschritt: $percent% ($current_file/$total_files Dateien verarbeitet)\r"
}

# Funktion zur Verarbeitung einer Datei
process_file() {
    file="$1"
    if [[ -f "$file" ]]; then
        # Erhöhe den Dateizähler
        ((current_file++))
        # Dateiname extrahieren
        base_name=$(basename "$file")
        echo "Verarbeite Datei: $base_name"

        # Staffel- und Episodeninformationen aus dem Dateinamen extrahieren
        episode=$(echo "$base_name" | grep -oP "Episode \d+" || echo "")
        season=$(echo "$base_name" | grep -oP "Staffel \d+" || echo "")

        if [[ -z "$episode" || -z "$season" ]]; then
            echo "Warnung: Kein gültiges Muster für Episode und Staffel gefunden. Datei wird dennoch umbenannt."
            episode="UnbekannteEpisode"
            season="UnbekannteStaffel"
        fi

        # Neues Dateiformat
        output_file="$(dirname "$file")/${episode}_${season}.mp4"

        # Überprüfen, ob die Zieldatei bereits existiert, um Überschreiben zu vermeiden
        if [[ -f "$output_file" ]]; then
            echo "Überspringe: Zieldatei $output_file existiert bereits."
            return
        fi

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

# Alle Dateien in einer Schleife verarbeiten
files=$(find "$input_folder" -type f -name "*.mp4")
for file in $files; do
    process_file "$file"
    show_progress
done

echo -e "\nAlle Dateien wurden verarbeitet."
