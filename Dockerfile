FROM ubuntu:24.04

LABEL maintainer="Copilot CLI Container"
LABEL description="Sandboxed environment for running GitHub Copilot CLI safely"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    ca-certificates \
    gnupg \
    sudo \
    fuse-overlayfs \
    rsync \
    diffutils \
    tree \
    jq \
    vim \
    nano \
    # Build essentials for various projects
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub Copilot CLI
RUN npm install -g @github/copilot

# Create non-root user for security (use UID 1001 to avoid conflicts)
RUN useradd -m -s /bin/bash copilot \
    && echo "copilot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directories
RUN mkdir -p /workspace /workspace-base /workspace-changes /workspace-work \
    && chown -R copilot:copilot /workspace /workspace-base /workspace-changes /workspace-work

# Copy scripts
COPY --chown=copilot:copilot entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chown=copilot:copilot overlay-setup.sh /usr/local/bin/overlay-setup.sh
COPY --chown=copilot:copilot apply-changes.sh /usr/local/bin/apply-changes.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
    /usr/local/bin/overlay-setup.sh \
    /usr/local/bin/apply-changes.sh

# Switch to non-root user
USER copilot
WORKDIR /workspace

# Set environment
ENV HOME=/home/copilot
ENV PATH="/home/copilot/.local/bin:${PATH}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["copilot"]
