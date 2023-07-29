#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Backing up doom config"
cp -r ~/.config/doom "$SCRIPT_DIR/../backups"
