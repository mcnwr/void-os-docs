#!/bin/bash
# Void OS - Run Script (Public Release)
# This script runs the pre-compiled ISO in QEMU

set -e

ISO_FILE="releases/os_manual.iso"

# Check if ISO file exists
if [ ! -f "$ISO_FILE" ]; then
    echo "❌ Error: ISO file not found at $ISO_FILE"
    echo ""
    echo "Please ensure the ISO file exists in the releases/ directory."
    echo "If you just cloned this repo, the ISO should be included."
    exit 1
fi

# Check if QEMU is installed
if ! command -v qemu-system-x86_64 &> /dev/null; then
    echo "❌ Error: QEMU is not installed"
    echo ""
    echo "Please install QEMU:"
    echo "  macOS:   brew install qemu"
    echo "  Linux:   sudo apt-get install qemu-system-x86"
    echo "  Arch:    sudo pacman -S qemu"
    exit 1
fi

echo "🚀 Starting Void OS in QEMU..."
echo ""
echo "📋 Controls:"
echo "  - Press ESC in the OS to exit"
echo "  - Press Ctrl+Alt+G to release mouse/keyboard"
echo "  - Press Ctrl+Alt+Q to quit QEMU"
echo ""
echo "💡 Tip: Check serial output in terminal for kernel debug messages"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detect OS for display backend
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use cocoa display
    DISPLAY_BACKEND="-display cocoa"
else
    # Linux - use default display
    DISPLAY_BACKEND=""
fi

# Run QEMU with the ISO
qemu-system-x86_64 \
    -cdrom "$ISO_FILE" \
    -serial stdio \
    -m 512M \
    -device isa-debug-exit,iobase=0x501,iosize=0x01 \
    $DISPLAY_BACKEND

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Void OS has exited."
echo ""

