#!/usr/bin/env bash

APP="$1"
WORKSPACE="special:$APP"

get_window_size() {
  case "$APP" in
    "kitty") echo "800 500" ;;
    "discord") echo "1200 700" ;;
    "zen") echo "1500 900" ;;
    "slack") echo "1200 700" ;;
    "vesktop") echo "1500 900" ;;
    "telegram-desktop") echo "800 500" ;;
    "Minecraft* 1.20.1") echo "854 480" ;;
    *) echo "600 400" ;;
  esac
}
WINDOW_SIZE=$(get_window_size)

if [ "$APP" = "Minecraft* 1.20.1" ]; then
  MINECRAFT_WORKSPACE="special:minecraft"

  if ! hyprctl clients -j | jq -e '.[] | select(.class == "Minecraft* 1.20.1")' > /dev/null; then
    prismlauncher &  # Or whatever command you use to launch Minecraft through Prism Launcher
    sleep 5  # Wait for Minecraft to start
  fi

  if hyprctl clients -j | jq -e ".[] | select(.class == \"Minecraft* 1.20.1\" and .workspace.name == \"$MINECRAFT_WORKSPACE\")" > /dev/null; then
    hyprctl dispatch togglespecialworkspace minecraft
  else
    hyprctl dispatch "[workspace $MINECRAFT_WORKSPACE; float; size $WINDOW_SIZE; center] ^(Minecraft* 1.20.1)$"
  fi
else
  if hyprctl clients -j | jq -e ".[] | select(.class == \"$APP\" and .workspace.name == \"$WORKSPACE\")" > /dev/null; then
    hyprctl dispatch togglespecialworkspace "$APP"
  else
    hyprctl dispatch exec "[workspace $WORKSPACE; float; size $WINDOW_SIZE; center] $APP"
  fi
fi
