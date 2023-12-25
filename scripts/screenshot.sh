#!/bin/sh

# Tijdelijk bestand voor de screenshot
TEMP_FILE=$(mktemp /tmp/screenshotXXXXXX.png)

# Maak een screenshot met maim en slop
maim -s "$TEMP_FILE"

# Controleer of er daadwerkelijk een screenshot is gemaakt
if [ -f "$TEMP_FILE" ]; then
    # Gebruik YAD om een "Opslaan Als" dialoog te tonen
    SAVE_PATH=$(yad --file --file-selection --save --confirm-overwrite --filename="$TEMP_FILE")

    # Verplaats de screenshot als de gebruiker een locatie heeft gekozen
    if [ -n "$SAVE_PATH" ]; then
        mv "$TEMP_FILE" "$SAVE_PATH"
    else
        # Verwijder het tijdelijke bestand als er geen locatie is gekozen
        rm "$TEMP_FILE"
    fi
else
    # Verwijder het tijdelijke bestand als er geen screenshot is gemaakt
    rm "$TEMP_FILE"
fi

