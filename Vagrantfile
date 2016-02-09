# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.box_url = "http://files.vagrantup.com/precise32.box"


  config.vm.network :private_network, ip: "10.0.0.2"

  config.vm.network :forwarded_port, guest: 27017, host: 27017

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "mongodb.pp"
  end

end
