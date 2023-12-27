#!/bin/sh

# Tijdelijk bestand voor de screenshot
TEMP_FILE=$(mktemp /tmp/screenshotXXXXXX.png)

# Maak een screenshot met maim en slop
maim -s --hidecursor --highlight --color 0.0,0.0,0.0,0.7 "$TEMP_FILE"

# Controleer of er daadwerkelijk een screenshot is gemaakt
if [ -f "$TEMP_FILE" ]; then
    # Gebruik Zenity om een "Opslaan Als" dialoog te tonen

    SAVE_PATH=$(cat /tmp/.screenshotpath)
    # SAVE_PATH=$(zenity --file-selection --save --confirm-overwrite --filename="$TEMP_FILE") --class screenshot

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

