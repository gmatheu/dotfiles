FROM ubuntu:15.04
MAINTAINER Gonzalo Matheu <gonzalommj@gmail.com>

RUN apt-get install -y curl git tmux vim zsh

WORKDIR /root/.dotfiles
