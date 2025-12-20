#!/bin/bash

# Setup script for git hooks
# Run this after cloning the repo on a new machine to enable auto-commit hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -d ".githooks" ]; then
    echo "Error: .githooks directory not found!"
    exit 1
fi

# Make hooks executable
chmod +x .githooks/*

# Configure git to use the tracked hooks directory
git config core.hooksPath .githooks

echo "✓ Git hooks configured successfully!"
echo "  Hooks directory: .githooks"
echo "  Run 'git config --get core.hooksPath' to verify"

