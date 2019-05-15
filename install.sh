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
  sudo apt-get install -yqq software-properties-common &&\
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
  sudo apt install -yqq autojump zsh
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
  sudo apt install -yqq build-essential cmake silversearcher-ag python3-dev
  vim +PlugInstall +qall
  python3 ~/.local/share/nvim/plugged/YouCompleteMe/install.py --java-completer
  # --ts-completer --go-completer

  fonts_dir="${DOTFILES_HOME}/fonts"
  if [ ! -d "${fonts_dir}" ];
  then
    git clone https://github.com/powerline/fonts.git --depth=1 ${fonts_dir}
  fi
  ${fonts_dir}/install.sh

}

bootstrap() {
  sudo apt install -yqq git curl ack
}

setup_git() {
  sudo apt install -yqq git meld

  read -p "Enter full name: " fullname
  read -p "Enter e-mail address: " email
  git config --global user.name "$fullname"
  git config --global user.email $email
  git config --global core.pager ''
  git config --global color.ui true
  git config --global merge.tool meld
  git config --global diff.tool meld
  git config --global credential.helper 'cache --timeout=3600'

  info "Git global config: "
  git config --global -l
}

setup_vim() {
  sudo apt install -yqq vim vim-gtk
  bin="vim"
  info "Setting up $bin"
  exists=$(check_bin $bin)
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
  set -- "$@" "--update" "--bootstrap" "--vim" "--zsh" "--tmux"
fi
for arg in "$@"; do
  shift
  case "$arg" in
    "-u"|"--update")
      get_repo
      ;;
    "-b"|"--bootstrap")
      bootstrap
      ;;
    "-g"|"--git")
      setup_git
      ;;
    "-v"|"--vim")
      setup_vim
      ;;
    "-t"|"--tmux")
      setup_tmux
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


