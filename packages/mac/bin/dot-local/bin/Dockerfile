# AI Agent Sandbox - Isolated environment for running AI coding agents
# Supports: Claude Code, OpenCode

FROM ubuntu:24.04

LABEL maintainer="AI Sandbox"
LABEL description="Sandboxed environment for AI coding agents"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base system utilities and development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  # Essential tools
  ca-certificates \
  curl \
  wget \
  git \
  gnupg \
  # Build essentials (for native modules)
  build-essential \
  # Common development tools
  jq \
  ripgrep \
  fd-find \
  fzf \
  tree \
  less \
  vim \
  # Process management
  procps \
  # Networking tools (for debugging)
  iputils-ping \
  dnsutils \
  # SSH client (for git operations)
  openssh-client \
  # Python (many tools need it)
  python3 \
  python3-pip \
  python3-venv \
  # Locales
  locales \
  && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Switch to ubuntu user to install binaries
USER ubuntu
WORKDIR /home/ubuntu

# Install Claude Code using official installer
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install OpenCode using official installer
RUN curl -fsSL https://opencode.ai/install | bash

# Set up config directory structure using single volume mount point
# All agent data lives in ~/.sandbox/ (volume-mounted at runtime)
# Symlinks point expected config paths to volume subdirectories
RUN mkdir -p ~/.sandbox/claude \
             ~/.sandbox/opencode-config/agent \
             ~/.sandbox/opencode-config/logs \
             ~/.sandbox/opencode-share \
  && echo '{}' > ~/.sandbox/claude/claude.json \
  && rm -rf ~/.claude ~/.claude.json ~/.config/opencode ~/.local/share/opencode \
  && mkdir -p ~/.config ~/.local/share \
  && ln -s ~/.sandbox/claude ~/.claude \
  && ln -s ~/.sandbox/claude/claude.json ~/.claude.json \
  && ln -s ~/.sandbox/opencode-config ~/.config/opencode \
  && ln -s ~/.sandbox/opencode-share ~/.local/share/opencode

# Add binary locations to PATH for all users
ENV PATH="/home/ubuntu/.local/bin:/home/ubuntu/.claude/bin:/home/ubuntu/.opencode/bin/:${PATH}"

# Default command
CMD ["/bin/bash"]
