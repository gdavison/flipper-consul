# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.network "forwarded_port", guest: 8500, host: 8500
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install unzip

    wget 'https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip' --output-document=consul.zip
    unzip consul.zip
    sudo chmod +x consul
    sudo mv consul /usr/bin/consul
  
    wget 'https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip' --output-document=ui.zip
    unzip ui.zip
  
    consul agent -server -client 0.0.0.0 -bootstrap-expect 1 -data-dir /tmp/consul -ui-dir /home/vagrant/dist > /var/log/consul.log 2>&1 &
  SHELL
end
