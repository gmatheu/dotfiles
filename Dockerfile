FROM ubuntu:15.04
MAINTAINER Gonzalo Matheu <gonzalommj@gmail.com>

RUN apt-get install -y curl git tmux vim zsh sudo
RUN apt-get install -y python python-dev build-essential cmake ruby
RUN gem install rake

WORKDIR /root
RUN echo "curl -sL https://raw.githubusercontent.com/gmatheu/dotfiles/master/install.sh | sh" > setup.sh
RUN chmod +x setup.sh

CMD /bin/bash -C './setup.sh'; '/bin/bash'
