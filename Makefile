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

neovim-setup:
	git clone https://github.com/gmatheu/nvim-config ${HOME}/.config/nvim

.PHONY: build run share build.sh lint starship.toml atuin.toml
