build:
	sudo docker build --tag dotfiles .

run: build
	sudo docker run --rm -it dotfiles /bin/bash

share: build
	sudo docker run --rm -it -v `pwd`/.:/root/.dotfiles dotfiles /bin/bash
