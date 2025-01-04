#!/bin/bash

# Frage nach dem Git-Repository-Link
read -p "Please enter the Git repository URL: " git_url

# Frage nach dem Zielpath
read -p "Please enter the target directory path where the repository should be cloned: " target_path

# Frage nach dem Repository-Pfad, den du nach dem Pull aktualisieren möchtest (optional)
read -p "Please enter the path to the folder inside the repository (e.g., _Converted_/CSV/H/Harman_Kardon/): " repo_path

# Schritt 1: Initialisiere Git und konfiguriere das Remote-Repository
echo "Initializing git repository..."
git init

# Schritt 2: Füge das Remote-Repository hinzu
echo "Adding remote repository..."
git remote add origin "$git_url"

# Schritt 3: Konfiguriere sparseCheckout
echo "Configuring sparseCheckout..."
git config core.sparseCheckout true

# Schritt 4: Definiere den Sparse-Checkout-Pfad
echo "$repo_path/*" >> .git/info/sparse-checkout

# Schritt 5: Hole die Daten vom Remote-Repository und wechsle in das Verzeichnis
echo "Pulling data from the repository and checking out the path..."
git pull origin main

# Schritt 6: Wechsel in den Ziel-Path
cd "$target_path" || { echo "Directory not found: $target_path"; exit 1; }

# Bestätigung
echo "Successfully navigated to the target path: $target_path"

