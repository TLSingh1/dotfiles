#!/usr/bin/env bash

# Test whisper with a sample recording
echo "Recording 3 seconds of audio..."
sox -d /tmp/test.wav trim 0 3

echo -e "\nFile info:"
file /tmp/test.wav
ls -la /tmp/test.wav

echo -e "\nRunning whisper-cpp..."
whisper-cpp -m "$HOME/.local/share/whisper/models/ggml-base.en.bin" -f /tmp/test.wav

echo -e "\nRunning whisper-cpp with -nt -np flags..."
whisper-cpp -m "$HOME/.local/share/whisper/models/ggml-base.en.bin" -f /tmp/test.wav -nt -np