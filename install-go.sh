#!/usr/bin/env bash
set -e

# Activate mise for non-interactive shells
. <(mise activate bash)

# Check if mise is installed
if ! command -v mise &>/dev/null; then
    echo "mise is not installed. Please run ./install-mise.sh first."
    exit 1
fi

# Install go
if ! command -v go &>/dev/null; then
    mise install go@latest
    mise use -g go@latest
fi

# Only set up Go workspace if GOPATH is not set
if [ -z "$GOPATH" ]; then
    # Set up Go workspace
    mkdir -p "$HOME/go"/{bin,src,pkg}
fi

# Install godoc
if ! command -v godoc &>/dev/null; then
    go install golang.org/x/tools/cmd/godoc@latest
fi