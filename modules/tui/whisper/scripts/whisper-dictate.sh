#!/usr/bin/env bash

# Whisper dictation script
# Records audio and transcribes it using whisper.cpp

TEMP_DIR="/tmp/whisper-dictate"
AUDIO_FILE="$TEMP_DIR/recording.wav"
MODEL_PATH="$HOME/.local/share/whisper/models/ggml-base.en.bin"
PIDFILE="$TEMP_DIR/recording.pid"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Check if already recording
if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    # Stop recording
    kill $(cat "$PIDFILE")
    rm -f "$PIDFILE"
    
    # Wait for file to be written
    sleep 0.5
    
    # Transcribe audio
    if [ -f "$AUDIO_FILE" ]; then
        # Send notification
        notify-send "Whisper" "Transcribing..." -t 2000
        
        # Run whisper.cpp
        TEXT=$(whisper-cpp -m "$MODEL_PATH" -f "$AUDIO_FILE" -nt -np 2>/dev/null | tail -n 1)
        
        # Type the text using wtype
        if [ -n "$TEXT" ]; then
            wtype "$TEXT"
            notify-send "Whisper" "Transcription complete" -t 2000
        else
            notify-send "Whisper" "No text detected" -t 2000
        fi
        
        # Clean up
        rm -f "$AUDIO_FILE"
    fi
else
    # Start recording
    notify-send "Whisper" "Recording... Press SUPER+V to stop" -t 2000
    sox -d "$AUDIO_FILE" &
    echo $! > "$PIDFILE"
fi