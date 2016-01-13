#! /bin/sh
DOTFILES_HOME=${DOTFILES_HOME:="$HOME/.dotfiles"}

update-dotfiles() {
  sh "$DOTFILES_HOME/install.sh"
}

install-terminal-theme() {
  curl -s "https://raw.githubusercontent.com/chriskempson/base16-gnome-terminal/master/base16-3024.dark.sh" | bash
}
