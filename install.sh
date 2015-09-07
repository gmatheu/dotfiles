#! /bin/sh

NC='\033[0m'
error() {
  color='\033[0;31m'
  echo "${color}$1${NC} "
} 
info() {
  color='\033[0;32m'
  echo "${color}$1${NC} "
} 

set_env() {
  if [ ! -n "$DOTFILES_HOME" ]; then
    export DOTFILES_HOME="$HOME/.dotfiles"
  fi
  info "DOTFILES_HOME: $DOTFILES_HOME"
  export DOTFILES_FILES="$DOTFILES_HOME/files"
}

get_repo() {
  if [ ! -d $DOTFILES_HOME ];
  then
    echo 'Cloning repository'
    which git >/dev/null 2>&1 && \
    git clone https://github.com/gmatheu/dotfiles.git $DOTFILES_HOME || {
      echo 'Could not clone repository'
      exit 1
    }
  else
    echo 'Updating Repository'
    cd $DOTFILES_HOME && \
      git pull origin master
  fi
}

check_bin() {
  local bin=$1
  which $bin >/dev/null 2>&1 && \
    echo "true" || {
    error '$bin is not available'
    echo "false"
  }
}

link_file() {
  local file="$1"
  ln -fs $DOTFILES_FILES/$file $HOME/.$file && info "done!" 
}

setup_tmux() {
  local bin="tmux"
  info "Setting up $bin"
  local exists=$(check_bin $bin)
  if [ "$exists" = "true" ]; then
    link_file "tmux.conf" 
  fi
}

# Run!
set_env
info "Getting latest changes"
get_repo
setup_tmux

