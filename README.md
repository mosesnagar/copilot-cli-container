<div align="center">

# 🐳 Copilot CLI Container

**Run GitHub Copilot CLI safely in a sandboxed container**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](Dockerfile)
[![GitHub](https://img.shields.io/badge/GitHub-Copilot-black?logo=github)](https://github.com/features/copilot)

*Use `--yolo` mode without fear — your system is protected!*

</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔒 **Isolated Filesystem** | Container can ONLY access your mounted project directory |
| 🔐 **Security Hardened** | No privilege escalation, read-only root filesystem |
| 🐳 **Multi-Runtime** | Works with Docker and Podman |
| 🔑 **Auto-Auth** | Automatically uses your `gh` CLI credentials |
| 🚀 **Easy Setup** | Single command to get started |

---

## 🚀 Quick Start

```bash
# Build the container
./copilot-container --build

# Run with your project mounted
./copilot-container --mount ~/my-project

# Run with --yolo (auto-accept) mode
./copilot-container --mount ~/my-project --yolo
```

---

## 📦 Installation

```bash
# Clone this repository
git clone https://github.com/mosesnagar/copilot-cli-container.git
cd copilot-cli-container

# Make the script executable
chmod +x copilot-container

# Build the container image
./copilot-container --build
```

### 🌍 Global Installation (Optional)

<details>
<summary><b>🐧 Linux / macOS</b></summary>

**Option 1: Symlink (Recommended)**
```bash
# Create symlink in ~/.local/bin
mkdir -p ~/.local/bin
ln -s $(pwd)/copilot-container ~/.local/bin/copilot-container

# Make sure ~/.local/bin is in your PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

**Option 2: Alias**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias copilot-container='/path/to/copilot-cli-container/copilot-container'

# Or with a shorter name
alias cpc='/path/to/copilot-cli-container/copilot-container'
```

**Option 3: Copy to system bin**
```bash
sudo cp copilot-container /usr/local/bin/
```
</details>

<details>
<summary><b>🪟 Windows</b></summary>

> **Prerequisites:** Docker Desktop or Podman for Windows, and WSL2 or Git Bash

**Option 1: WSL2 (Recommended)**
```bash
# Inside WSL2, follow the Linux instructions above
wsl
cd /mnt/c/path/to/copilot-cli-container
./copilot-container --build
```

**Option 2: Git Bash**
```bash
# Clone and build
git clone https://github.com/mosesnagar/copilot-cli-container.git
cd copilot-cli-container
./copilot-container --build

# Add to PATH via Windows Environment Variables:
# 1. Press Win + R, type: systempropertiesadvanced
# 2. Click "Environment Variables"
# 3. Edit "Path" under User variables
# 4. Add: C:\path\to\copilot-cli-container
```

**Option 3: PowerShell Alias**
```powershell
# Add to your PowerShell profile (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
function copilot-container { & "C:\path\to\copilot-cli-container\copilot-container" @args }
Set-Alias -Name cpc -Value copilot-container
```

**Option 4: Batch wrapper**
```batch
:: Create copilot-container.cmd and add to PATH
@echo off
bash "C:\path\to\copilot-cli-container\copilot-container" %*
```
</details>

After setup, use from anywhere:
```bash
copilot-container --mount ~/any-project --yolo
```

---

## 📖 Usage

### Mount Mode (`--mount`)
Mount your local project directory. Changes are written directly.

```bash
./copilot-container --mount ~/my-project
./copilot-container --mount ~/my-project --yolo
```

> 💡 **Recovery:** Use git - `git checkout .` or `git stash`

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

---

## 🔑 Authentication

The container automatically detects your GitHub token from:

1. `GH_TOKEN` environment variable
2. `GITHUB_TOKEN` environment variable  
3. `gh auth token` (GitHub CLI)

> ✅ No manual setup needed if you're logged into `gh` CLI!

---

## 🛡️ Security Model

### ✅ What the container CAN access:
- The mounted project directory (`/workspace`)
- Internet (required for Copilot API)
- Temporary files (`/tmp`)

### ❌ What the container CANNOT access:
- Your home directory (except mounted project)
- System files (`/etc`, `/usr`, etc.)
- Other projects/directories
- Docker socket
- Host processes

### 🔐 Security Features
- `--security-opt no-new-privileges` — Prevents privilege escalation
- `--read-only` — Root filesystem is read-only
- Non-root user inside container

---

## ⏹️ Exiting

| Key | Action |
|-----|--------|
| `Ctrl+D` | Shutdown |
| `/exit` | Exit command |
| `Ctrl+C` ×2 | Force exit |

---

## 📋 Requirements

- **Docker** or **Podman**
- **Bash** shell
- *(Optional)* GitHub CLI (`gh`) for auto-authentication

---

## 🔧 Troubleshooting

<details>
<summary><b>"Permission denied" errors</b></summary>

```bash
chmod +x copilot-container entrypoint.sh
```
</details>

<details>
<summary><b>Token not working</b></summary>

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
</details>

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

**Made with ❤️ for safe AI-assisted coding**

</div>
