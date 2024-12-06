# -*- mode: ruby -*-
# vi: set ft=ruby :

username = ENV['VAGRANT_USERNAME']
password = ENV['VAGRANT_PASSWORD']
puts "Username: #{username}"
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_check_update = true

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/#{username}/.dotfiles"
  # config.vm.synced_folder "../.config/i3", "/home/vagrant/.config/i3"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true

    vb.memory = "#{1024 * 16}"
    vb.cpus = 3
  end

  config.ssh.forward_agent = true
  if not ENV['VAGRANT_BOOTSTRAP']
    config.ssh.username = username
    # config.ssh.password = password
    # config.ssh.insert_key = true
  else
    puts "Provisioning mode with default user"
  end
  config.vm.provision "shell", inline: <<-SHELL
    useradd -G sudo -m -U #{username}
    chsh -s /usr/bin/bash #{username}
    echo '#{username}:#{password}' | chpasswd
    grep -qxF '#{username}' /etc/sudoers || echo '#{username} ALL=(ALL) NOPASSWD:ALL' | EDITOR='tee -a' visudo
    cp -r /home/vagrant/.ssh /home/#{username}/.ssh
    chown -R #{username}:#{username} /home/#{username}/.ssh
    chown -R #{username}:#{username} /home/#{username}

    apt update
    apt install --assume-yes -y nala
    nala update
    nala upgrade --assume-yes -y
    nala install --assume-yes -y vim neovim tmux htop zsh git linux-headers-$(uname -r) gcc make perl kitty stow

    nala install --assume-yes -y ubuntu-desktop
  SHELL
end
