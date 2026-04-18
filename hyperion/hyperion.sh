#!/usr/bin/env bash
# hyperion.sh
# EndeavourOS Community Edition — Hyperion
# Manual install/update script for post-installation use
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/patrixr/hyperion/main/hyperion.sh | sudo bash
#   OR
#   git clone https://github.com/patrixr/hyperion.git && cd hyperion && sudo ./hyperion.sh
#
# Must be run with sudo.

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

username="${SUDO_USER:-$(logname)}"

echo ":: Hyperion CE — install/update for user: $username"

# Always clone from GitHub when piped, or check local when run from file
if [ -f "hyperion.nu" ]; then
    # Running from inside the hyperion directory
    echo ":: Using local Hyperion repo..."
    HYPERION_DIR="$(pwd)"
else
    # Need to clone the repo
    echo ":: Fetching latest Hyperion from GitHub..."
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    git clone --depth=1 https://github.com/patrixr/hyperion.git "$TEMP_DIR/hyperion"
    HYPERION_DIR="$TEMP_DIR/hyperion"
fi

# Install nushell if needed
echo ":: Bootstrapping nushell..."
pacman -S --needed --noconfirm nushell

# Run the main nushell install script
echo ":: Running Hyperion installer..."
HYPERION_USER="$username" nu "$HYPERION_DIR/hyperion.nu"

echo ":: Hyperion CE complete. Log out and back in for all changes to take effect."
