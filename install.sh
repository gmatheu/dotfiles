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
  REPO_URL=${REPO_URL:="https://github.com/gmatheu/dotfiles.git"}
  if [ ! -n "$DOTFILES_HOME" ]; then
    export DOTFILES_HOME="$HOME/.dotfiles"
  fi
  info "DOTFILES_HOME: $DOTFILES_HOME"
  export DOTFILES_FILES="$DOTFILES_HOME/files"
}

update_repo() {
  local current=`git rev-parse HEAD`
  git pull origin master
  git shortlog -e -n $current..HEAD
}

get_repo() {
  local exists=$(check_bin "git")
  if [ "$exists" = "true" ]; then
    if [ ! -d $DOTFILES_HOME ];
    then
      git clone $REPO_URL $DOTFILES_HOME || {
        echo 'Could not clone repository'
        exit 1
      }
    else
      echo 'Updating Repository'
      cd $DOTFILES_HOME && \
        update_repo
    fi
  else
    error "git is not available. can not clone or update repo"
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
  ln -fs $DOTFILES_FILES/$file $HOME/.$file && info "$file linked" 
}

setup_tmux() {
  local bin="tmux"
  info "Setting up $bin"
  local exists=$(check_bin $bin)
  if [ "$exists" = "true" ]; then
    link_file "tmux.conf" 
  fi
}

setup_zsh() {
  local bin="zsh"
  info "Setting up $bin"
  local exists=$(check_bin $bin)
  if [ "$exists" = "true" ]; then
    link_file "zshrc" 
    link_file "zshenv" 
  fi
}

# Run!
set_env
info "Getting latest changes"
get_repo
setup_tmux
setup_zsh

