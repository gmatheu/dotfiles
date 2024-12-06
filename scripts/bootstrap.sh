#!/bin/bash

sudo apt update
sudo apt install --assume-yes -y nala
sudo nala update
sudo nala upgrade --assume-yes -y
sudo nala install --assume-yes -y vim neovim tmux htop zsh git "linux-headers-$(uname -r)" gcc make perl kitty stow

sh <(curl -L https://nixos.org/nix/install) --daemon
# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

make bootstrap
