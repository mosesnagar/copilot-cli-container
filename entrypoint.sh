#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check for GitHub token
if [ -z "$GH_TOKEN" ] && [ -z "$GITHUB_TOKEN" ]; then
    log_warn "No GitHub token found. You'll need to run /login in Copilot CLI."
    log_warn "Set GH_TOKEN or GITHUB_TOKEN environment variable for auto-auth."
fi

# Show workspace info
log_info "Workspace: /workspace"
if [ -d "/workspace/.git" ]; then
    log_info "Git repo detected: $(git -C /workspace remote get-url origin 2>/dev/null || echo 'local repo')"
fi

# Handle clone mode
if [ -n "$COPILOT_CLONE_REPO" ]; then
    log_info "Cloning repository: $COPILOT_CLONE_REPO"
    git clone "https://github.com/$COPILOT_CLONE_REPO" /workspace
    cd /workspace
fi

echo ""
log_info "Starting Copilot CLI..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Execute the command (default: copilot)
exec "$@"
