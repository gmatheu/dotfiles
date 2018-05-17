FROM ubuntu:16.04
MAINTAINER Gonzalo Matheu <gonzalommj@gmail.com>

RUN apt-get update \
  && apt-get install -y curl git vim zsh sudo
RUN apt-get install -y python python-dev build-essential cmake ruby
RUN gem install rake

WORKDIR /root
ADD . /root/.dotfiles/
RUN bash .dotfiles/install.sh

CMD /bin/bash -C './setup.sh'; '/bin/bash'
