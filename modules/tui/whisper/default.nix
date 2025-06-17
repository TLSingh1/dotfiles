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

  home.file.".local/bin/whisper-download-model" = {
    executable = true;
    source = ./scripts/whisper-download-model.sh;
  };

  home.activation.downloadWhisperModel = lib.hm.dag.entryAfter ["writeBoundary"] ''
    MODEL_PATH="$HOME/.local/share/whisper/models/ggml-base.en.bin"
    if [ ! -f "$MODEL_PATH" ]; then
      echo "Whisper model not found. Downloading..."
      $HOME/.local/bin/whisper-download-model
    fi
  '';
}