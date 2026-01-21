# Copilot CLI Container

Run GitHub Copilot CLI inside a sandboxed container for safe `--yolo` mode usage.

## Features

- 🔒 **Isolated filesystem** - Container can only access mounted project directory
- 🛡️ **OverlayFS mode** - Review all changes before applying to your files
- 🐳 **Multi-runtime** - Works with Docker and Podman
- 🚀 **Easy setup** - Single command to get started

## Quick Start

```bash
# Build the container
./copilot-container --build

# Run with your project mounted
./copilot-container --mount ~/my-project

# Run with --yolo (auto-accept) safely using overlay mode
./copilot-container --mount-overlay ~/my-project --yolo
```

## Installation

```bash
# Clone this repository
git clone <this-repo>
cd copilot-cli-container

# Make the script executable
chmod +x copilot-container

# Build the container image
./copilot-container --build

# (Optional) Add to PATH
ln -s $(pwd)/copilot-container ~/.local/bin/copilot-container
```

## Usage

### Three Modes of Operation

#### 1. Direct Mount (`--mount`)
Changes are written directly to your project files.

```bash
./copilot-container --mount ~/my-project
```

**Best for:** Trusted tasks, when you have git for recovery.

#### 2. Overlay Mount (`--mount-overlay`) 
Changes are isolated. Review and apply them after the session.

```bash
# Work on your project (changes go to overlay)
./copilot-container --mount-overlay ~/my-project --yolo

# Inside the container, when done:
# Run: apply-changes.sh show   # List changes
# Run: apply-changes.sh diff   # See detailed diff
# Run: apply-changes.sh apply  # Apply to original files
```

**Best for:** Using `--yolo` mode, experimental changes, untrusted tasks.

#### 3. Clone (`--clone`)
Clone a fresh repo from GitHub and work on it.

```bash
./copilot-container --clone facebook/react
```

**Best for:** Exploring repos, one-off tasks, contributing to open source.

### Additional Options

```bash
# Start a shell instead of Copilot CLI
./copilot-container --mount ~/my-project --shell

# Show help
./copilot-container --help
```

## Authentication

Set your GitHub token before running:

```bash
export GH_TOKEN="ghp_your_token_here"
./copilot-container --mount ~/my-project
```

Or authenticate inside the container:
```
/login
```

## Docker Compose

For easier configuration, use docker-compose:

```bash
# Edit docker-compose.yml to set your project path
# Then run:
docker compose run --rm copilot

# Or for overlay mode:
docker compose run --rm copilot-overlay
```

## Makefile Commands

```bash
make build                     # Build the container image
make run PROJECT=~/my-project  # Run with direct mount
make run-overlay PROJECT=~/my-project YOLO=1  # Run with overlay + yolo
make run-clone REPO=owner/repo # Clone and run
make shell PROJECT=~/my-project # Start a shell
make clean                     # Remove the image
```

## Security Model

### What the container CAN access:
- ✅ The mounted project directory (`/workspace`)
- ✅ Internet (required for Copilot API)
- ✅ Temporary files (`/tmp`)

### What the container CANNOT access:
- ❌ Your home directory (except mounted project)
- ❌ System files (`/etc`, `/usr`, etc.)
- ❌ Other projects/directories
- ❌ Docker socket
- ❌ Host processes

### Overlay Mode Protection

In overlay mode, even the mounted project is protected:

```
┌─────────────────────────────────────────────────────────┐
│ Your project files (READ-ONLY)                          │
└────────────────────────────┬────────────────────────────┘
                             │
         ┌───────────────────┴───────────────────┐
         │         OverlayFS Merge               │
         │  (What Copilot sees and modifies)     │
         └───────────────────┬───────────────────┘
                             │
┌────────────────────────────┴────────────────────────────┐
│ Changes Layer (isolated, reviewable)                     │
└─────────────────────────────────────────────────────────┘
```

## Requirements

- Docker or Podman
- Bash shell
- (For overlay mode) FUSE support

## Troubleshooting

### "Permission denied" errors
```bash
# Make sure the script is executable
chmod +x copilot-container entrypoint.sh overlay-setup.sh apply-changes.sh
```

### Overlay mode not working
Overlay mode requires `--cap-add=SYS_ADMIN` and `/dev/fuse`. If your system doesn't support this, use `--mount` mode with git for recovery.

### Token not working
Make sure you're exporting the token, not just setting it:
```bash
export GH_TOKEN="your_token"  # ✓ Correct
GH_TOKEN="your_token"         # ✗ Won't be passed to container
```

## License

MIT
