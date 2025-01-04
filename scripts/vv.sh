#!/bin/bash

# Funktion: Volumen erstellen
create_volume() {
  echo "=== Neues VeraCrypt-Volumen erstellen ==="
  read -p "Name des Containers (ohne Erweiterung): " container_name
  read -p "Größe des Volumens (z.B. 100M, 1G): " volume_size
  read -p "Dateisystem (FAT, NTFS, ext4): " filesystem
  read -s -p "Passwort: " password
  echo

  # Volumen erstellen
  veracrypt --create "$container_name".vc --volume-type=normal \
    --size="$volume_size" --encryption=AES --hash=SHA-512 \
    --filesystem="$filesystem" --password="$password" --non-interactive
  if [ $? -eq 0 ]; then
    echo "Volumen $container_name.vc erfolgreich erstellt!"
  else
    echo "Fehler beim Erstellen des Volumens."
  fi
}

# Funktion: Volumen mounten
mount_volume() {
  echo "=== VeraCrypt-Volumen mounten ==="
  read -p "Pfad zum Container: " container_path
  read -p "Mountpunkt (z.B. /mnt/veracrypt1): " mount_point
  read -s -p "Passwort: " password
  echo

  # Volumen mounten
  sudo veracrypt "$container_path" "$mount_point" --password="$password" --non-interactive 
  #sudo chown -R $USER:$USER "$mount_point"
  if [ $? -eq 0 ]; then
    sudo chmod -R 755 "$mount_point"
    echo "Volumen erfolgreich gemountet!"
  else
    echo "Fehler beim Mounten des Volumens."
  fi
}

# Funktion: Volumen dismounten
dismount_volume() {
  echo "=== VeraCrypt-Volumen dismounten ==="
  read -p "Mountpunkt (z.B. /mnt/veracrypt1): " mount_point

  # Volumen dismounten
  sudo veracrypt -d "$mount_point"
  if [ $? -eq 0 ]; then
    echo "Volumen erfolgreich dismountet!"
  else
    echo "Fehler beim Dismounten des Volumens."
  fi
}

# Hauptmenü
while true; do
  echo "============================="
  echo " VeraCrypt Manager"
  echo "============================="
  echo "1. Neues Volumen erstellen"
  echo "2. Volumen mounten"
  echo "3. Volumen dismounten"
  echo "4. Beenden"
  read -p "Bitte wählen: " choice

  case $choice in
    1) create_volume ;;
    2) mount_volume ;;
    3) dismount_volume ;;
    4) exit 0 ;;
    *) echo "Ungültige Auswahl!" ;;
  esac
done
