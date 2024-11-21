#! /bin/bash -x

export EGET_BIN=~/.local/eget/bin
mkdir -p $EGET_BIN
export PATH=$EGET_BIN:$PATH
export EGET_CONFIG=$HOME/.config/.eget.toml

eget ogham/exa
eget sxyazi/yazi
eget lasantosr/intelli-shell
eget ajeetdsouza/zoxide
eget atuinsh/atuin
eget direnv/direnv
eget sharkdp/vivid
