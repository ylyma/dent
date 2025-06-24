#!/bin/bash

echo "dent: my dev container yay"
echo "nvim version: $(nvim --version)"


for dir in projects curr; do
  if [ -d "/home/$USERNAME/$dir" ]; then
    sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/$dir" 2>/dev/null || true
  fi
done

# fix nvim permissions
sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/.local" 2>/dev/null || true
sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/.cache" 2>/dev/null || true

export EDITOR=nvim
export VISUAL=nvim
export TERM=xterm-256color
export COLORTERM=truecolor

export PATH="/home/amy/.cargo/bin:/usr/local/go/bin:$PATH"

if [ $# -eq 0 ]; then
  exec bash
else
  exec "$@"
fi

