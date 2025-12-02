#!/usr/bin/env bash

if ! command -v zsh &>/dev/null; then
    yay -S --needed --noconfirm zsh
fi