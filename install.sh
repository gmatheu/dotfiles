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
  DOTFILES_HOME=${DOTFILES_HOME:="$HOME/.dotfiles"}
  info "DOTFILES_HOME: $DOTFILES_HOME"
  export DOTFILES_FILES="$DOTFILES_HOME/files"

  VIM_HOME="$HOME/.vim"
}

update_repo() {
  local current=`git rev-parse HEAD`
  git pull origin master
  git shortlog -e -n $current..HEAD
}

get_repo() {
  info "Getting latest changes"
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
    error "$bin is not available"
    echo "false"
  }
}

check_function() {
  type $1 | grep -q 'shell function'
}

link_file() {
  local file="$1"
  ln -fs $DOTFILES_FILES/$file $HOME/.$file && info "$file linked"
}

setup_tmux() {
  info "Going to install tmux, sudo is required"
  sudo add-apt-repository -y ppa:pi-rho/dev &&\
  sudo apt-get install -yqq python-software-properties software-properties-common &&\
  sudo apt-get update -yqq &&\
  sudo apt install -yqq tmux
  local bin="tmux"
  info "Setting up $bin"
  local exists=$(check_bin $bin)
  if [ "$exists" = "true" ]; then
    tpm_home=$HOME/.tmux/plugins/tpm
    if [ ! -d "$tpm_home" ]; then
      info "Cloning tpm"
      git clone https://github.com/tmux-plugins/tpm $tpm_home
    fi
    link_file "tmux.conf"
  fi
}

configure_zsh() {
  cat /etc/passwd | grep -e ^$(whoami) | grep -q $(which zsh) && info "zsh is current default shell" ||\
    (info "Setting $bin as default shell" && chsh -s $(which zsh))
}

setup_zsh() {
  sudo apt install -yqq autojump
  bin="zsh"
  info "Setting up $bin"
  zsh_exists=$(check_bin $bin)
  if [ "$zsh_exists" = "true" ]; then
    link_file "zshrc"
    link_file "zshenv"
    configure_zsh
  fi
}

configure_vim() {
  vim +PlugInstall +qall
}

setup_vim() {
  sudo apt install -yqq cmake
  local bin="vim"
  info "Setting up $bin"
  local exists=$(check_bin $bin)
  if [ "$exists" = "true" ]; then
    if [ ! -d "$VIM_HOME" ];
    then
      git clone https://github.com/gmatheu/dot_vim.git "$VIM_HOME" || {
        echo 'Could not clone repository'
        exit 1
      }
    else
      cd "$VIM_HOME" && update_repo
    fi
    configure_vim
  fi
}

setup_theme() {
  base16_home="$HOME/.config/base16-shell"
  if [ ! -d "$base16_home" ]; then
    git clone https://github.com/chriskempson/base16-shell.git $base16_home
  fi
  info "Use 'base16' prefixed functions to change color scheme"
}

# Run!
set_env

if [ $# -eq 0 ]; then
  set -- "$@" "--update" "--tmux" "--zsh" "--vim"
fi
for arg in "$@"; do
  shift
  case "$arg" in
    "-u"|"--update")
      get_repo
      ;;
    "-t"|"--tmux")
      setup_tmux
      ;;
    "-v"|"--vim")
      setup_vim
      ;;
    "-z"|"--zsh")
      setup_zsh
      ;;
    "-c"|"--theme")
      setup_theme
      ;;
    *)
      error "Unkown option: $arg"
      ;;
  esac
done


