#!/usr/bin/env bash

# Download whisper model
MODEL_DIR="$HOME/.local/share/whisper/models"
mkdir -p "$MODEL_DIR"

echo "Downloading whisper base.en model..."
curl -L "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin" \
     -o "$MODEL_DIR/ggml-base.en.bin"

echo "Model downloaded to $MODEL_DIR/ggml-base.en.bin"