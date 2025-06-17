#!/usr/bin/env bash

# Whisper dictation script
# Records audio and transcribes it using OpenAI whisper

TEMP_DIR="/tmp/whisper-dictate"
AUDIO_FILE="$TEMP_DIR/recording.wav"
TEXT_FILE="$TEMP_DIR/transcription.txt"
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
        
        # Run whisper
        whisper "$AUDIO_FILE" --model base.en --language en --output_format txt --output_dir "$TEMP_DIR" 2>/dev/null
        
        # Read the transcription
        if [ -f "$TEXT_FILE" ]; then
            TEXT=$(cat "$TEXT_FILE" | tr -d '\n')
            
            # Type the text using wtype
            if [ -n "$TEXT" ]; then
                wtype "$TEXT"
                notify-send "Whisper" "Transcription complete" -t 2000
            else
                notify-send "Whisper" "No text detected" -t 2000
            fi
        else
            notify-send "Whisper" "Transcription failed" -t 2000
        fi
        
        # Clean up
        rm -f "$AUDIO_FILE" "$TEXT_FILE"
    fi
else
    # Start recording
    notify-send "Whisper" "Recording... Press SUPER+V to stop" -t 2000
    sox -d "$AUDIO_FILE" &
    echo $! > "$PIDFILE"
fi