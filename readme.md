# Vagrant Lamp Stack

This is the Vagrant - Puppet configuration I use for developing my projects.
Credit goes to pyrocms's similar setup https://github.com/pyrocms/devops-vagrant

## How to use

Download this repository and use it as a git submoudle in your projects. Change the Vagrantfile settings to better suit your needs all the rest should work fine out of the box. Here's an example Vagrantfile

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # choose which box to use
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  
  # set the timezone to something that makes sense to you
  config.vm.provision :shell, :inline => "echo \"Europe/Rome\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
  
  # use a meaningful hostname
  config.vm.host_name = "lamp"
  
  #set the ip address of the machine (choose a different one if it's aleady taken by another vm)
  config.vm.network :hostonly, "198.18.0.11"
  
  # enable nfs on the root folder
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)
  
  # update the machine
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  # provision the stack
  config.vm.provision :puppet do |puppet|
  
    # change fqdn to give to change the vm virtual host
  	puppet.facter = { 
  	  "fqdn" => "vagrant-lamp-stack", 
  	  "hostname" => "www", 
  	  "docroot" => '/vagrant/public'
  	}
    
    # set the puppet manifests directory (relative to the project's root)
    puppet.manifests_path = "vagrant-puppet/manifests"
    
    # choose the manifest
    puppet.manifest_file  = "ubuntu-apache2-mysql-php5.pp"
    
    # instruct puppet where the modules are
    puppet.module_path = "vagrant-puppet/modules"
    
  end
  
  # ready to go!
  
end
```

### Connecting to the DB

Since this was a pain for me at first, to connect to the DB from outside the VM you have to tunnel inside the machine, then connect to the database.