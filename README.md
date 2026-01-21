# Copilot CLI Container

Run GitHub Copilot CLI inside a sandboxed container for safe `--yolo` mode usage.

## Features

- 🔒 **Isolated filesystem** - Container can ONLY access mounted project directory
- 🔐 **Security hardened** - No privilege escalation, read-only root filesystem
- 🐳 **Multi-runtime** - Works with Docker and Podman
- 🔑 **Auto-auth** - Automatically uses your `gh` CLI credentials
- 🚀 **Easy setup** - Single command to get started

## Quick Start

```bash
# Build the container
./copilot-container --build

# Run with your project mounted
./copilot-container --mount ~/my-project

# Run with --yolo (auto-accept) mode
./copilot-container --mount ~/my-project --yolo
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

### Mount Mode (`--mount`)
Mount your local project directory. Changes are written directly.

```bash
./copilot-container --mount ~/my-project
./copilot-container --mount ~/my-project --yolo
```

**Recovery:** Use git - `git checkout .` or `git stash`

### Clone Mode (`--clone`)
Clone a fresh repo from GitHub and work on it.

```bash
./copilot-container --clone facebook/react
```

### Additional Options

```bash
# Start a shell instead of Copilot CLI
./copilot-container --mount ~/my-project --shell

# Rebuild the image
./copilot-container --build

# Show help
./copilot-container --help
```

## Authentication

The container automatically detects your GitHub token from:
1. `GH_TOKEN` environment variable
2. `GITHUB_TOKEN` environment variable  
3. `gh auth token` (GitHub CLI)

No manual setup needed if you're logged into `gh` CLI!

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

### Security Features:
- `--security-opt no-new-privileges` - Prevents privilege escalation
- `--read-only` - Root filesystem is read-only
- Non-root user inside container

## Exiting

- **Ctrl+D** - Shutdown
- **`/exit`** - Exit command
- **Ctrl+C twice** - Force exit

## Requirements

- Docker or Podman
- Bash shell
- (Optional) GitHub CLI (`gh`) for auto-authentication

## Troubleshooting

### "Permission denied" errors
```bash
chmod +x copilot-container entrypoint.sh
```

### Token not working
Make sure `gh` CLI is logged in:
```bash
gh auth status
gh auth login  # if not logged in
```

Or set token manually:
```bash
export GH_TOKEN="ghp_your_token"
./copilot-container --mount ~/my-project
```

## License

MIT
