FROM debian:bookworm

# --------
# versions
# --------
ARG NVIM_VERSION=v0.10.2
ARG GO_VERSION=1.21.5

# ---------
# packages
# ---------
# core
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    tar \
    gzip \
    sudo \
    openssh-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# build
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# langs
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# misc
RUN apt-get update && apt-get install -y \
    ripgrep \
    fd-find \
    fzf \
    tmux \
    htop \
    tree \
    && rm -rf /var/lib/apt/lists/*

# nvim compat
RUN apt-get update && apt-get install -y \
    python3-pynvim \
    python3-neovim \
    && rm -rf /var/lib/apt/lists/*


# nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux64.tar.gz

# nodejs
RUN npm install -g neovim typescript ts-node eslint prettier

# golang
RUN curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go1.21.5.linux-amd64.tar.gz

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# ------
# setup
# ------

ARG USERNAME=amy
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && usermod -aG sudo $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# setup config + folders
RUN mkdir -p /home/$USERNAME/.config/nvim \
    && mkdir -p /home/$USERNAME/.local/share/nvim \
    && mkdir -p /home/$USERNAME/curr \
    && mkdir -p /home/$USERNAME/projects

RUN git clone --filter=blob:none --branch=stable \
    https://github.com/folke/lazy.nvim.git \
    /home/$USERNAME/.local/share/nvim/lazy/lazy.nvim

# ------
# scripts
# ------
COPY --chown=$USERNAME:$USERNAME --chmod=755 ./run.sh /home/$USERNAME/run.sh 

ENTRYPOINT ["/home/amy/run.sh"]
