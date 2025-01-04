#!/bin/bash

# Array mit den GPIO-Zeilen, die aktiviert oder deaktiviert werden sollen
gpio_lines_chip0=(2 3 4 17 18)        # GPIOs für gpiochip0 (zum Beispiel)
gpio_lines_chip1=(0 1 2)               # GPIOs für gpiochip1 (zum Beispiel)

# Funktion zum Aktivieren der GPIOs
enable_gpio() {
    echo "Aktiviere GPIO-Header..."
    # Aktiviert die GPIOs für gpiochip0
    for pin in "${gpio_lines_chip0[@]}"; do
        sudo gpioset --chip gpiochip0 $pin=1  # Setzt den GPIO auf HIGH (1)
        echo "GPIO$pin wurde aktiviert auf gpiochip0."
    done

    # Aktiviert die GPIOs für gpiochip1
    for pin in "${gpio_lines_chip1[@]}"; do
        sudo gpioset --chip gpiochip1 $pin=1  # Setzt den GPIO auf HIGH (1)
        echo "GPIO$pin wurde aktiviert auf gpiochip1."
    done
    echo "Alle GPIOs wurden aktiviert."
}

# Funktion zum Deaktivieren der GPIOs
disable_gpio() {
    echo "Deaktiviere GPIO-Header..."
    # Deaktiviert die GPIOs für gpiochip0
    for pin in "${gpio_lines_chip0[@]}"; do
        sudo gpioset --chip gpiochip0 $pin=0  # Setzt den GPIO auf LOW (0)
        echo "GPIO$pin wurde deaktiviert auf gpiochip0."
    done

    # Deaktiviert die GPIOs für gpiochip1
    for pin in "${gpio_lines_chip1[@]}"; do
        sudo gpioset --chip gpiochip1 $pin=0  # Setzt den GPIO auf LOW (0)
        echo "GPIO$pin wurde deaktiviert auf gpiochip1."
    done
    echo "Alle GPIOs wurden deaktiviert."
}

# Menü für den Benutzer
echo "Möchtest du die GPIO-Header aktivieren oder deaktivieren?"
echo "1. Aktivieren"
echo "2. Deaktivieren"
read -p "Gib die Zahl ein (1 oder 2): " choice

# Bedingung basierend auf der Benutzerauswahl
if [ "$choice" -eq 1 ]; then
    enable_gpio
elif [ "$choice" -eq 2 ]; then
    disable_gpio
else
    echo "Ungültige Eingabe. Bitte gib 1 oder 2 ein."
fi

