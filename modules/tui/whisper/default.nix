{pkgs, ...}: {
  home.packages = with pkgs; [
    openai-whisper
    sox
    wl-clipboard
    wtype
    ffmpeg
  ];

  home.file.".local/bin/whisper-dictate" = {
    executable = true;
    source = ./scripts/whisper-dictate.sh;
  };
}

