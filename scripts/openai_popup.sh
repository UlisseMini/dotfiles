#!/bin/bash

# Define the website URL and window name
url="https://chat.openai.com"
window_name="OpenAI Chat"

# Check if the window is already open
window_id=$(xdotool search --name "$window_name" | head -1)

if [ -z "$window_id" ]; then
  # If the window is not open, open it in your preferred browser (e.g., google-chrome, firefox)
  google-chrome-stable --new-window "$url" &

  # Wait for the window to appear and set its name
  sleep 1
  window_id=$(xdotool search --sync --onlyvisible --class "google-chrome" | head -1)
  xdotool set_window --name "$window_name" "$window_id"
else
  # If the window is open, check if it's currently visible
  is_visible=$(xdotool search --onlyvisible --name "$window_name" | head -1)

  if [ -z "$is_visible" ]; then
    # If the window is hidden, unhide it and bring it to the front
    xdotool windowmap "$window_id"
    xdotool windowactivate "$window_id"
  else
    # If the window is visible, hide it
    xdotool windowunmap "$window_id"
  fi
fi

