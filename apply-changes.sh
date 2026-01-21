#!/bin/bash
set -e

# This script shows changes made in overlay mode and optionally applies them

UPPER="/workspace-changes"
LOWER="/workspace-base"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_changes() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}                    CHANGES SUMMARY${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Find all changed files
    if [ -z "$(ls -A $UPPER 2>/dev/null)" ]; then
        echo -e "${YELLOW}No changes detected.${NC}"
        return 0
    fi
    
    # List new files
    echo -e "${GREEN}New/Modified files:${NC}"
    find "$UPPER" -type f | while read -r file; do
        rel_path="${file#$UPPER/}"
        if [ -f "$LOWER/$rel_path" ]; then
            echo -e "  ${YELLOW}M${NC} $rel_path"
        else
            echo -e "  ${GREEN}A${NC} $rel_path"
        fi
    done
    
    # List deleted files (marked with whiteout)
    find "$UPPER" -name ".wh.*" -type c 2>/dev/null | while read -r file; do
        rel_path="${file#$UPPER/}"
        original_name="${rel_path/.wh./}"
        echo -e "  ${RED}D${NC} $original_name"
    done
    
    echo ""
}

show_diff() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}                    DETAILED DIFF${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    find "$UPPER" -type f | while read -r file; do
        rel_path="${file#$UPPER/}"
        if [ -f "$LOWER/$rel_path" ]; then
            echo -e "${YELLOW}=== $rel_path ===${NC}"
            diff -u "$LOWER/$rel_path" "$file" || true
            echo ""
        else
            echo -e "${GREEN}=== $rel_path (new file) ===${NC}"
            head -50 "$file"
            if [ $(wc -l < "$file") -gt 50 ]; then
                echo "... (truncated)"
            fi
            echo ""
        fi
    done
}

apply_changes() {
    echo -e "${YELLOW}Applying changes to original files...${NC}"
    
    # Copy modified/new files
    find "$UPPER" -type f | while read -r file; do
        rel_path="${file#$UPPER/}"
        target="$LOWER/$rel_path"
        mkdir -p "$(dirname "$target")"
        cp "$file" "$target"
        echo -e "  ${GREEN}✓${NC} $rel_path"
    done
    
    # Handle deletions (whiteout files)
    find "$UPPER" -name ".wh.*" -type c 2>/dev/null | while read -r file; do
        rel_path="${file#$UPPER/}"
        original_name="${rel_path/.wh./}"
        target="$LOWER/$original_name"
        if [ -f "$target" ]; then
            rm "$target"
            echo -e "  ${RED}✓${NC} Deleted: $original_name"
        fi
    done
    
    echo ""
    echo -e "${GREEN}Changes applied successfully!${NC}"
}

# Parse command
case "${1:-show}" in
    show)
        show_changes
        ;;
    diff)
        show_diff
        ;;
    apply)
        show_changes
        echo ""
        read -p "Apply these changes? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            apply_changes
        else
            echo "Cancelled."
        fi
        ;;
    *)
        echo "Usage: apply-changes.sh [show|diff|apply]"
        echo "  show  - List changed files (default)"
        echo "  diff  - Show detailed diff"
        echo "  apply - Apply changes to original files"
        exit 1
        ;;
esac
