#!/bin/bash

# Funktionsdefinitionen

# Configurationsdatei setzen
set_config_path() {
    echo "Setze den OneDrive Konfigurationspfad..."
    read -p "Gib den vollständigen Pfad zum OneDrive-Ordner ein: " config_path
    export ONEDRIVE_CONFIG_PATH="$config_path"
    echo "Konfigurationspfad gesetzt: $ONEDRIVE_CONFIG_PATH"
}

# Zeigt eine Liste von Dateien und Ordnern auf OneDrive
list_files() {
    echo "Lade die Liste der Dateien und Ordner auf OneDrive..."
    onedrive --list
}

# Download der gesamten OneDrive-Daten
download_all() {
    echo "Starte den Download aller OneDrive-Daten..."
    onedrive --synchronize --download-only
}

# Download nur eines bestimmten Ordners
download_directory() {
    echo "Lade nur einen bestimmten Ordner von OneDrive herunter..."
    read -p "Gib den lokalen Pfad des Ordners ein, den du herunterladen möchtest: " directory
    onedrive --synchronize --download-only --single-directory "$directory"
}

# Upload aller neuen Dateien oder geänderten Dateien
upload_all() {
    echo "Starte den Upload aller geänderten Dateien auf OneDrive..."
    onedrive --synchronize --upload-only
}

# Upload nur eines bestimmten Ordners
upload_directory() {
    echo "Lade nur einen bestimmten Ordner zu OneDrive hoch..."
    read -p "Gib den lokalen Pfad des Ordners ein, den du hochladen möchtest: " directory
    onedrive --synchronize --upload-only --single-directory "$directory"
}

# Zeigt den Status von OneDrive
status() {
    echo "Zeige den Status von OneDrive an..."
    onedrive --status
}

# Hauptmenü
menu() {
    clear
    echo "OneDrive Manager"
    echo "================"
    echo "1. Upload aller Dateien"
    echo "2. Upload eines bestimmten Ordners"
    echo "3. Download aller Dateien"
    echo "4. Download eines bestimmten Ordners"
    echo "5. Liste alle Dateien und Ordner"
    echo "6. Setze den OneDrive Konfigurationspfad"
    echo "7. Zeige den Status von OneDrive"
    echo "8. Beenden"
    echo -n "Wähle eine Option (1-8): "
    read option
    case $option in
        1)
            upload_all
            ;;
        2)
            upload_directory
            ;;
        3)
            download_all
            ;;
        4)
            download_directory
            ;;
        5)
            list_files
            ;;
        6)
            set_config_path
            ;;
        7)
            status
            ;;
        8)
            exit 0
            ;;
        *)
            echo "Ungültige Auswahl!"
            ;;
    esac
}

# Endlosschleife für das Menü
while true; do
    menu
    echo -n "Möchtest du eine weitere Aktion durchführen? (j/n): "
    read continue_choice
    if [[ "$continue_choice" != "j" && "$continue_choice" != "J" ]]; then
        break
    fi
done
