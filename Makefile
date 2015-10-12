build_file=.bin/build.sh
build_file_url= 'https://raw.githubusercontent.com/caarlos0/shell-ci-build/master/build.sh'

lint: build.sh
	/bin/bash -c $(build_file)

build.sh:
	mkdir -p .bin
	wget -nc -O $(build_file) $(build_file_url) || echo ""
	chmod +x $(build_file)

build:
	sudo docker build --tag dotfiles .

interactive:
	sudo docker run --rm -it dotfiles /bin/bash

run: build
	sudo docker run --rm -it dotfiles 

share: build
	sudo docker run --rm -it -v `pwd`/.:/root/.dotfiles dotfiles /bin/bash

.PHONY: build run share build.sh lint
