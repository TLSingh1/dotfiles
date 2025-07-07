#!/usr/bin/env bash

# Simple emoji picker using fuzzel
# Usage: fuzzel-emoji.sh [copy|type]

# Get emoji data - you'll need to install an emoji font package
# This is a simplified version - the full version would have a complete emoji list
EMOJIS="😀 Grinning Face
😃 Grinning Face with Big Eyes
😄 Grinning Face with Smiling Eyes
😁 Beaming Face with Smiling Eyes
😆 Grinning Squinting Face
😅 Grinning Face with Sweat
🤣 Rolling on the Floor Laughing
😂 Face with Tears of Joy
🙂 Slightly Smiling Face
🙃 Upside-Down Face
😉 Winking Face
😊 Smiling Face with Smiling Eyes
😇 Smiling Face with Halo
🥰 Smiling Face with Hearts
😍 Smiling Face with Heart-Eyes
🤩 Star-Struck
😘 Face Blowing a Kiss
😗 Kissing Face
😚 Kissing Face with Closed Eyes
😙 Kissing Face with Smiling Eyes
😋 Face Savoring Food
😛 Face with Tongue
😜 Winking Face with Tongue
🤪 Zany Face
😝 Squinting Face with Tongue
🤑 Money-Mouth Face
🤗 Hugging Face
🤭 Face with Hand Over Mouth
🤫 Shushing Face
🤔 Thinking Face
🤐 Zipper-Mouth Face
🤨 Face with Raised Eyebrow
😐 Neutral Face
😑 Expressionless Face
😶 Face Without Mouth
😏 Smirking Face
😒 Unamused Face
🙄 Face with Rolling Eyes
😬 Grimacing Face
🤥 Lying Face
😌 Relieved Face
😔 Pensive Face
😪 Sleepy Face
🤤 Drooling Face
😴 Sleeping Face
😷 Face with Medical Mask
🤒 Face with Thermometer
🤕 Face with Head-Bandage
🤢 Nauseated Face
🤮 Face Vomiting
🤧 Sneezing Face
🥵 Hot Face
🥶 Cold Face
🥴 Woozy Face
😵 Dizzy Face
🤯 Exploding Head
🤠 Cowboy Hat Face
🥳 Partying Face
😎 Smiling Face with Sunglasses
🤓 Nerd Face
🧐 Face with Monocle"

# Select emoji with fuzzel
SELECTED=$(echo "$EMOJIS" | fuzzel --dmenu --prompt="Emoji: " | cut -d' ' -f1)

if [ -n "$SELECTED" ]; then
    if [ "$1" = "copy" ]; then
        echo -n "$SELECTED" | wl-copy
        notify-send "Emoji Copied" "$SELECTED copied to clipboard" -t 2000
    else
        # Type the emoji (requires ydotool or similar)
        echo -n "$SELECTED" | wl-copy
    fi
fi