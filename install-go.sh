#!/usr/bin/env bash
set -e

if ! command -v mise &>/dev/null; then
    echo "mise is not installed. Please run ./install-mise.sh first."
    exit 1
fi

# --- Activate mise for non-interactive shells ---
eval (mise activate bash)

if ! command -v go &>/dev/null; then
    mise install go@latest
    mise use -g go@latest
fi

# --- Set up workspace if GOPATH is not set ---
if [ -z "$GOPATH" ]; then
    # Set up Go workspace
    mkdir -p "$HOME/go"/{bin,src,pkg}
fi

# --- Install godoc ---
if ! command -v godoc &>/dev/null; then
    go install golang.org/x/tools/cmd/godoc@latest
fi