# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "hashicorp/precise64"
  
#  config.berkshelf.enabled = true
#  config.berkshelf.berksfile_path = "./Berksfile" 

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8500, host: 8500

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    #echo Installing dependencies...
    #sudo apt-get install -y unzip curl
    #echo Fetching Consul...
    #cd /tmp/
    #wget https://dl.bintray.com/mitchellh/consul/0.3.1_linux_amd64.zip -O consul.zip
    #echo Installing Consul...
    #unzip consul.zip
    #sudo chmod +x consul
    #sudo mv consul /usr/bin/consul
    #echo Installing Ruby
    #sudo apt-get install python-software-properties -y
    #sudo apt-add-repository ppa:brightbox/ruby-ng -y
    #sudo apt-get update
    #sudo apt-get install ruby2.1 -y
    wget -qO- https://get.docker.com/ | sh
    
    # add vagrant to docker group
    sudo usermod -aG docker vagrant
    
    docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -ui-dir /ui
  SHELL
#  config.vm.provision "chef_zero" do |chef|
#    chef.add_recipe "consul-cookbook"
#  end
end
