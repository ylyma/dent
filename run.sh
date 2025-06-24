#!/bin/bash

echo "dent: my dev container yay"
echo "nvim version: $(nvim --version | head -n1)"
DOTFILES_REPO="https://github.com/ylyma/dotfiles.git"
USERNAME=amy

for dir in projects curr; do
  if [ -d "/home/$USERNAME/$dir" ]; then
    sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/$dir" 2>/dev/null || true
  fi
done

# fix nvim permissions
sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/.local" 2>/dev/null || true
sudo chown -R $USERNAME:$USERNAME "/home/$USERNAME/.cache" 2>/dev/null || true

# clone my dotfiles
NEED_NVIM=false

if [ ! -d "/home/$USERNAME/.config/nvim" ] || [ -z "$(ls -A /home/$USERNAME/.config/nvim 2>/dev/null)" ]; then
    NEED_NVIM=true
fi
# clone dotfiles if missing configs
if [ "$NEED_NVIM" = true ]; then
    echo "missing configs, cloning dotfiles..."
    git clone "$DOTFILES_REPO" /tmp
    
    if [ "$NEED_NVIM" = true ]; then
        echo "setting up nvim config..."
        mkdir -p /home/$USERNAME/.config/nvim
        cp -r /tmp/dotfiles/.config/nvim/* /home/$USERNAME/.config/nvim/ 2>/dev/null || true
        sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/nvim
    fi

    rm -rf /tmp/dotfiles
    echo "dotfiles setup complete!"
fi

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

