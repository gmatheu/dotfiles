build_file=.bin/build.sh
build_file_url= 'https://raw.githubusercontent.com/gmatheu/shell-ci-build/master/build.sh'

lint: build.sh
	/bin/bash -c $(build_file)

build.sh:
	mkdir -p .bin
	wget -nc -O $(build_file) $(build_file_url) || echo ""
	chmod +x $(build_file)

build:
	docker build --tag dotfiles .

interactive:
	docker run --rm -it dotfiles /bin/bash

run: build
	docker run --rm -it dotfiles

share: build
	docker run --rm -it -v `pwd`/.:/root/.dotfiles dotfiles /bin/bash


${HOME}/.config/starship.toml:
	ln -fs $(CURDIR)/files/starship.toml $@
${HOME}/.config/atuin/config.toml:
	ln -fs $(CURDIR)/files/atuin.toml $@

atuin.toml: ${HOME}/.config/atuin/config.toml
starship.toml: ${HOME}/.config/starship.toml

stow-dry-run:
	stow -n .
stow:
	stow .


home-manager-setup:
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install

home-manager-edit:
	home-manager edit
home-manager-switch:
	home-manager switch
home-manager-clean:
	nix-collect-garbage -d

i3-setup:
	git clone https://github.com/gmatheu/i3config ${HOME}/.config/i3
vim-setup:
	curl -sL https://raw.githubusercontent.com/gmatheu/vim-minimal/master/install.sh | sh

neovim-setup:
	git clone https://github.com/gmatheu/nvim-config ${HOME}/.config/nvim

nala:
	sudo apt update -q
	sudo apt install -y nala
node:
	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
	sudo nala install -y nodejs
tmux:
	sudo nala install -y tmux tmuxp
i3:
	sudo nala install -y i3 i3lock i3lock-fancy polybar feh rofi pulseaudio-utils libnotify-bin light dunst flameshot picom

eget:
	mkdir -p ${HOME}/.local/eget/bin
	wget --no-clobber https://github.com/zyedidia/eget/releases/download/v1.3.4/eget-1.3.4-linux_amd64.tar.gz
	tar -C ${HOME}/.local/eget/bin/ --strip-components 1 --wildcards -xf eget-1.3.4-linux_amd64.tar.gz '*/eget'
	rm eget-1.3.4-linux_amd64.tar.gz
eget-packages: eget
	bash ./scripts/eget-packages.sh

ulauncher:
	sudo add-apt-repository universe -y
	sudo add-apt-repository ppa:agornostal/ulauncher -y
	sudo nala update
	sudo nala install ulauncher

bootstrap: nala node tmux i3 eget eget-packages
	sudo nala install -y stow neovim kitty htop ripgrep
	sudo chsh -s $$(which zsh) $$(whoami)
	curl -sSf https://raw.githubusercontent.com/lasantosr/intelli-shell/main/install.sh | bash
	zsh -c 'source ~/.zshrc; zplug install;'


.PHONY: build run share build.sh lint starship.toml atuin.toml
