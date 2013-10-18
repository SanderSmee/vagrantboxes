# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  ## Ubuntu 12.04 LTS
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Set the Timezone to something useful
  config.vm.provision :shell, :inline => "echo \"Europe/Amsterdam\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # Update the server
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  # BEGIN Landrush configuration ###############################################
  if Vagrant.has_plugin?('landrush')
    config.landrush.enable
  end
  # END Landrush configuration #################################################

  # BEGIN VBGuest configuration ################################################
  # Borrowed from http://goo.gl/JSeN7H
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end
  # END VBGuest configuration ##################################################

  config.vm.define :postgresql do |pgsql_config|
    # map pgsql.vagrant.dev to this IP
    config.vm.network :private_network, ip: "172.16.0.21"
    config.vm.hostname = "pgsql.vagrant.dev"

    # use SSH private keys that are present on the host
    config.ssh.forward_agent = true

    # Provider-specific configuration so you can fine-tune various
    # config.vm.provider :virtualbox do |vb|
    #   vb.name =
    #   vb.customize ["modifyvm", :id, "--memory", "1024"]
    #   vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    #
    #   # Borrowed from https://github.com/purple52/librarian-puppet-vagrant/
    #   vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    # end

    # enable puppet
    pgsql_config.vm.provision :puppet do |puppet|
      puppet.facter = {
        "fqdn" => "pgsql.vagrant.dev",
        "hostname" => "www",
        "docroot" => '/vagrant/www/pyrocms/'
      }

      puppet.options = "--verbose --debug"
      puppet.manifest_file  = "base.pp"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path  = "puppet/modules"
    end
  end #vm.define :postgresql

end
