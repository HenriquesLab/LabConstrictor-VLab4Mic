#!/usr/bin/env bash
PREFIX="BASE_PATH"
echo "Uninstalling VLab4Mic from $PREFIX"
if [ -f "$PREFIX/pre_uninstall.sh" ]; then
    bash "$PREFIX/pre_uninstall.sh"
fi
rm -rf "$PREFIX"

echo "VLab4Mic removed."

if [ -t 0 ]; then
    echo
    read -rp "Press Enter to close the installer..." _
fi