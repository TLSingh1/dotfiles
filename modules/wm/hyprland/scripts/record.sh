#!/usr/bin/env bash

# Simple screen recording script for Hyprland
# Based on dots-hyprland recording functionality

RECORDINGS_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORDINGS_DIR"

# Check if already recording
if pgrep -x "wf-recorder" > /dev/null; then
    # Stop recording
    pkill -INT wf-recorder
    notify-send "Recording Stopped" "Screen recording has been saved" -t 3000
    exit 0
fi

# Generate filename with timestamp
FILENAME="$RECORDINGS_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"

# Parse arguments
AUDIO=""
REGION=""

for arg in "$@"; do
    case $arg in
        --fullscreen)
            REGION=""
            ;;
        --fullscreen-sound)
            REGION=""
            AUDIO="--audio"
            ;;
        *)
            # Default is region selection
            REGION="-g \"$(slurp)\""
            ;;
    esac
done

# Start recording
notify-send "Recording Started" "Press the recording keybind again to stop" -t 3000

if [ -z "$REGION" ]; then
    # Fullscreen recording
    if [ -n "$AUDIO" ]; then
        wf-recorder -f "$FILENAME" --audio --codec=h264_vaapi &
    else
        wf-recorder -f "$FILENAME" --codec=h264_vaapi &
    fi
else
    # Region recording
    eval "wf-recorder -f \"$FILENAME\" $REGION --codec=h264_vaapi &"
fi