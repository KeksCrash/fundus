#!/bin/bash

# Schritt 1: Alle .ir-Dateien im Ordner und Unterordnern durchsuchen und ihren Inhalt in einer .txt-Datei speichern
output_file="output.txt"

# Leere die Datei output.txt, wenn sie existiert
> "$output_file"

echo "Saving content of all .ir files to $output_file"

# Durchsuche alle .ir-Dateien im aktuellen Verzeichnis und Unterverzeichnissen
find . -type f -name "*.ir" | while read file; do
    echo "Processing file: $file"
    cat "$file" >> "$output_file"  # Inhalt der Datei in output.txt speichern
    echo -e "\n" >> "$output_file" # Zeilenumbruch nach jedem Dateiinhalt
done

echo "Content of all .ir files has been saved to $output_file."

# Schritt 2: Nutzerabfrage, ob er die Namen in der .txt-Datei ändern möchte
echo "Would you like to modify the 'name:' parameters in the output file?"
echo "1. Yes (change all 'name: <value>' to 'name: POWER')"
echo "2. No (do nothing)"
read -p "Enter 1 or 2: " user_choice

# Funktion zum Entfernen von Zeilen "Filetype: IR signals" und "fileVersion: 1", die nicht in den ersten beiden Zeilen stehen
remove_specific_lines() {
    # Temporäre Datei, um den veränderten Inhalt zu speichern
    temp_file=$(mktemp)

    # Behalte die ersten beiden Zeilen bei
    head -n 2 "$output_file" > "$temp_file"

    # Entferne alle Zeilen, die "Filetype: IR signals" oder "fileVersion: 1" enthalten, außer den ersten beiden Zeilen
    tail -n +3 "$output_file" | sed '/Filetype: IR signals/d' | sed '/fileVersion: 1/d' >> "$temp_file"

    # Ersetze die Originaldatei durch die temporäre Datei
    mv "$temp_file" "$output_file"
}

# Funktion zum Entfernen von leeren Zeilen
remove_empty_lines() {
    # Entferne alle leeren Zeilen
    sed -i '/^[[:space:]]*$/d' "$output_file"
}

# Schritt 3: Wenn der Nutzer "1" wählt, werden alle 'name:' Parameter geändert
if [ "$user_choice" -eq 1 ]; then
    echo "Changing all 'name: <value>' to 'name: POWER' in $output_file"

    # Entferne spezifische Zeilen, die nicht in den ersten beiden Zeilen sind
    remove_specific_lines

    # Ersetze alle Vorkommen von "name: <value>" durch "name: POWER"
    sed -i 's/name: .*/name: POWER/g' "$output_file"
    
    # Entferne leere Zeilen
    remove_empty_lines

    echo "Changes have been made."
else
    echo "No changes were made."
fi

echo "Script execution completed."

