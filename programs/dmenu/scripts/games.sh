#!/bin/sh

games=$(ls ~/Games)

keuze=$(echo -e "$games" | dmenu -i -p "Choose your game")
cd ~/Games/$keuze
bash start*
