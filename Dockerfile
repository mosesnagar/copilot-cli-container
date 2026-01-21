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

# Create workspace directory
RUN mkdir -p /workspace \
    && chown -R copilot:copilot /workspace

# Copy entrypoint script
COPY --chown=copilot:copilot entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to non-root user
USER copilot
WORKDIR /workspace

# Set environment
ENV HOME=/home/copilot
ENV PATH="/home/copilot/.local/bin:${PATH}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["copilot"]
