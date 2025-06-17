{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    whisper-cpp
    sox
    wl-clipboard
    wtype
  ];

  home.file.".local/bin/whisper-dictate" = {
    executable = true;
    source = ./scripts/whisper-dictate.sh;
  };

  home.activation.downloadWhisperModel = lib.hm.dag.entryAfter ["writeBoundary"] ''
    MODEL_DIR="$HOME/.local/share/whisper/models"
    MODEL_PATH="$MODEL_DIR/ggml-base.en.bin"
    
    if [ ! -f "$MODEL_PATH" ]; then
      echo "Whisper model not found. Downloading..."
      mkdir -p "$MODEL_DIR"
      ${pkgs.curl}/bin/curl -L "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin" \
           -o "$MODEL_PATH"
      echo "Model downloaded to $MODEL_PATH"
    fi
  '';
}