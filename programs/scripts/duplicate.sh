#!/bin/sh

# Get the current working directory
current_directory=$(pwd)

# Launch a new terminal and execute 'cd' command
alacritty -e sh -c "cd '$current_directory'; exec ${SHELL:-bash}"

