build:
	sudo docker build --tag dotfiles .

interactive:
	sudo docker run --rm -it dotfiles /bin/bash

run: build
	sudo docker run --rm -it dotfiles 

share: build
	sudo docker run --rm -it -v `pwd`/.:/root/.dotfiles dotfiles /bin/bash

.PHONY: build run share
