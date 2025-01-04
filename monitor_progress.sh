#!/bin/bash

while true; do
    clear
    echo "Fortschritt der Datei-Verarbeitung:"
    echo

    # Lese die Datei mit Original- und Zielpfad
    if [[ -f /tmp/current_file.txt ]]; then
        readarray -t files < /tmp/current_file.txt
        original_file="${files[0]}"
        processed_file="${files[1]}"

        if [[ -n "$original_file" && -f "$original_file" ]]; then
            echo "Original-Datei:"
            ls -lh "$original_file"
        else
            echo "Original-Datei nicht verfügbar."
        fi

        echo
        if [[ -n "$processed_file" && -f "$processed_file" ]]; then
            echo "Bearbeitete Datei:"
            ls -lh "$processed_file"
        else
            echo "Bearbeitete Datei wird noch erstellt: $processed_file"
        fi
    else
        echo "Keine Datei wird derzeit verarbeitet."
    fi

    echo
    sleep 2  # Aktualisierung alle 2 Sekunden
done
