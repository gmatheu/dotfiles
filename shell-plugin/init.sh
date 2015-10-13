#! /bin/sh
DOTFILES_HOME=${DOTFILES_HOME:="$HOME/.dotfiles"}

update-dotfiles() {
  sh "$DOTFILES_HOME/install.sh"
}
