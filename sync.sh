#!/bin/bash

# --- CONFIGURATION: SET YOUR PATHS ---
MAC_PATH="/Users/yourname/configs"
LINUX_PATH="/home/ntweb/.config/VSCodium/User"

# --- FILE LIST: ADD THE FILES YOU WANT TO SYNC ---
# Use filenames only; the script handles the paths
FILES_TO_SYNC=(
    "keybindings.json"
    "settings.json"
)
# ------------------------------------------

if [ $# -lt 2 ]; then
    echo "Usage: $0 [pull|push] [MAC|LINUX]"
    exit 1
fi

ACTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
OS_TARGET=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Determine target directory
if [ "$OS_TARGET" == "mac" ]; then
    TARGET_DIR="$MAC_PATH"
elif [ "$OS_TARGET" == "linux" ]; then
    TARGET_DIR="$LINUX_PATH"
else
    echo "Error: Second parameter must be MAC or LINUX."
    exit 1
fi

# Logic for Pull/Push
for FILE in "${FILES_TO_SYNC[@]}"; do
    if [ "$ACTION" == "pull" ]; then
        # Pull from target to current folder
        if [ -f "$TARGET_DIR/$FILE" ]; then
            cp -v "$TARGET_DIR/$FILE" .
        else
            echo "Warning: $FILE not found on $OS_TARGET"
        fi
    elif [ "$ACTION" == "push" ]; then
        # Push from current folder to target
        if [ -f "$FILE" ]; then
            mkdir -p "$TARGET_DIR"
            cp -v "$FILE" "$TARGET_DIR/"
        else
            echo "Warning: $FILE not found in current directory"
        fi
    else
        echo "Error: First parameter must be 'pull' or 'push'."
        exit 1
    fi
done

echo "Operation $ACTION completed for $OS_TARGET."