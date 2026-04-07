#!/usr/bin/env bash
# hyperion-install.sh
# EndeavourOS Community Edition — Hyperion
# Manual post-install script. Run from inside the cloned repo:
#
#   git clone --depth=1 --branch feat/hyperion https://github.com/patrixr/dotfiles.git hyperion
#   cd hyperion/hyperion
#   sudo ./hyperion-install.sh
#
# Must be run with sudo.

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

username="$(logname)"

echo ":: Hyperion CE — manual install for user: $username"

# Install nushell first so we can hand off to hyperion.nu
echo ":: Bootstrapping nushell..."
pacman -S --needed --noconfirm nushell

# Run the main nushell install script as root, passing the target username via env
echo ":: Handing off to hyperion.nu..."
HYPERION_USER="$username" nu "$(dirname "$0")/hyperion.nu"

echo ":: Hyperion CE install complete. Please reboot."
