#!/usr/bin/env bash

# Whisper dictation script
# Records audio and transcribes it using whisper.cpp

TEMP_DIR="/tmp/whisper-dictate"
AUDIO_FILE="$TEMP_DIR/recording.wav"
MODEL_PATH="$HOME/.local/share/whisper/models/ggml-base.en.bin"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Check if already recording
if pgrep -x "sox" > /dev/null; then
    # Stop recording
    pkill -x sox
    
    # Wait for file to be written
    sleep 0.5
    
    # Transcribe audio
    if [ -f "$AUDIO_FILE" ]; then
        echo "Transcribing..."
        
        # Run whisper.cpp
        TEXT=$(whisper-cpp -m "$MODEL_PATH" -f "$AUDIO_FILE" -nt -np 2>/dev/null | tail -n 1)
        
        # Type the text using wtype
        if [ -n "$TEXT" ]; then
            wtype "$TEXT"
        fi
        
        # Clean up
        rm -f "$AUDIO_FILE"
    fi
else
    # Start recording
    echo "Recording... Press keybind again to stop."
    sox -d "$AUDIO_FILE" &
fi