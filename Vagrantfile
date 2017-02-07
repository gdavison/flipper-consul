# -*- mode: ruby -*-
# vi: set ft=ruby :

CONSUL_VERSION = '0.7.4'

Vagrant.configure(2) do |config|
  config.vm.box = "opscode-ubuntu-14.04"
  config.vm.network "forwarded_port", guest: 8500, host: 8500
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install unzip

    wget "https://releases.hashicorp.com/consul/#{CONSUL_VERSION}/consul_#{CONSUL_VERSION}_linux_amd64.zip" --output-document=consul.zip
    unzip consul.zip
    sudo chmod +x consul
    sudo mv consul /usr/bin/consul
  
    consul agent -server -client 0.0.0.0 -data-dir /tmp/consul -bootstrap-expect 1 -ui -dc dev04 > /var/log/consul.log 2>&1 &
  SHELL
end
