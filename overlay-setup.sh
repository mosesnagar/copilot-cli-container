#!/bin/bash
set -e

# This script sets up OverlayFS for safe file editing
# Original files are read-only, changes go to a separate layer

LOWER="/workspace-base"    # Read-only original files
UPPER="/workspace-changes" # Where modifications are stored
WORK="/workspace-work"     # OverlayFS work directory
MERGED="/workspace"        # What Copilot sees (merged view)

# Ensure directories exist and are clean
sudo rm -rf "$UPPER"/* "$WORK"/*

# Mount overlayfs
# Note: Requires --privileged or --cap-add=SYS_ADMIN when running container
if command -v fuse-overlayfs &> /dev/null; then
    # Use fuse-overlayfs for unprivileged containers
    fuse-overlayfs -o lowerdir="$LOWER",upperdir="$UPPER",workdir="$WORK" "$MERGED"
else
    # Fall back to kernel overlayfs (requires privileges)
    sudo mount -t overlay overlay -o lowerdir="$LOWER",upperdir="$UPPER",workdir="$WORK" "$MERGED"
fi

echo "OverlayFS mounted successfully"
echo "  Original files: $LOWER (read-only)"
echo "  Your changes:   $UPPER"
echo "  Merged view:    $MERGED"
