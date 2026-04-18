#!/usr/bin/env bash
# hyperion.sh
# EndeavourOS Community Edition — Hyperion
# Manual install/update script for post-installation use
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/patrixr/dotfiles/feat/hyperion/hyperion/hyperion.sh | sudo bash
#   OR
#   git clone ... && cd hyperion/hyperion && sudo ./hyperion.sh
#
# Must be run with sudo.

# Check if running from file or piped (before strict mode)
if [ -n "${BASH_SOURCE:-}" ] && [ -f "${BASH_SOURCE[0]:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    FROM_FILE=true
else
    SCRIPT_DIR=""
    FROM_FILE=false
fi

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

username="${SUDO_USER:-$(logname)}"

echo ":: Hyperion CE — install/update for user: $username"

# Check if we're running from inside the repo
if [ "$FROM_FILE" = true ] && [ -f "$SCRIPT_DIR/hyperion.nu" ]; then
    # Running from cloned repo - use it directly
    echo ":: Using local Hyperion repo..."
    HYPERION_DIR="$SCRIPT_DIR"
else
    # Need to clone the repo (either piped from curl or not in repo)
    echo ":: Fetching latest Hyperion from GitHub..."
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    git clone --depth=1 --branch feat/hyperion https://github.com/patrixr/dotfiles.git "$TEMP_DIR/hyperion"
    HYPERION_DIR="$TEMP_DIR/hyperion/hyperion"
fi

# Install nushell if needed
echo ":: Bootstrapping nushell..."
pacman -S --needed --noconfirm nushell

# Run the main nushell install script
echo ":: Running Hyperion installer..."
HYPERION_USER="$username" nu "$HYPERION_DIR/hyperion.nu"

echo ":: Hyperion CE complete. Log out and back in for all changes to take effect."
