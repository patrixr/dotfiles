#!/usr/bin/env bash
# setup_hyperion_isomode.bash
# EndeavourOS Community Edition — Hyperion
# Called by the EOS Welcome app during a live ISO installation.
# Usage: setup_hyperion_isomode.bash <username>
# Must be run as root.

set -euo pipefail

username="${1:?Usage: setup_hyperion_isomode.bash <username>}"

echo ":: Hyperion CE — ISO mode install for user: $username"

# Clone the repo
echo ":: Cloning the Hyperion CE repo..."
git clone --depth=1 https://github.com/patrixr/hyperion.git

# Install nushell first so we can hand off to hyperion.nu
echo ":: Bootstrapping nushell..."
pacman -S --needed --noconfirm nushell

# Run the main nushell install script as root, passing the target username via env
echo ":: Handing off to hyperion.nu..."
HYPERION_USER="$username" nu hyperion/hyperion.nu

# Clean up the cloned repo
echo ":: Cleaning up..."
rm -rf hyperion

echo ":: Hyperion CE install complete. Please reboot."
