#!/usr/bin/env bash

# Install Zsh
if ! command -v zsh &>/dev/null; then
    yay -S --needed --noconfirm zsh
fi